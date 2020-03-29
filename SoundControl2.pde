import ddf.minim.*; //<>//

import processing.sound.*;

PImage bg;
PGraphics clearImage;
Minim minim;
PApplet app;
MusicButton[] buttons;
RemoteControl rc;
int lastWidth = 0;
int lastUpdate = 0;
float masterGain = 0;

void settings(){
  PJOGL.setIcon("./img/icon.png");
  size(1280, 720, P2D);
}

void setup(){
  background(0);
  clearImage = createGraphics(width, height);
  clearImage.beginDraw();
  clearImage.background(0);
  clearImage.endDraw();
  modifySurface();
  fonts.load();
  minim = new Minim(this);
  loadSettings();
  rc = new RemoteControl();
}

void loadSettings(){
  settings = new Ini("./data/settings.ini");
  initButtons(settings.getInt("buttonRows"), settings.getInt("buttonCols"));
  //Now see if we can load the most recent file
  String recentFile = settings.getString("recent");
  if((new File(recentFile)).exists()) loadFile(recentFile);
  String bgUrl = sketchPath() + File.separator + settings.getString("background");
  File bgFile = new File(bgUrl);
  if(bgFile.exists()){
    bg = loadImage(bgUrl);
  }
  masterGain = settings.getInt("masterGain");
}

void draw(){
  if(bg == null){
    background(30);
  }else{
    image(clearImage, 0, 0);
  }
  
  for(MusicButton mb: buttons) mb.render();
  rc.render();
  renderMasterGain();
  
  if(lastWidth != width) handleWindowResize();
  
  int now = millis();
  if(now - lastUpdate > 2000){
    lastUpdate = now;
    checkRemote();
  }else if(lastUpdate - now > 2000){
    lastUpdate = now;
    checkRemote();
  }
}

void drawTitle(){
  clearImage.rectMode(CENTER);
  clearImage.textFont(fonts.normal);
  clearImage.textSize(height / 30);
  float tw = clearImage.textWidth(loadedFile);
  clearImage.fill(30, 150);
  clearImage.rect(width / 2, height / 25, tw * 1.1, height / 15, 10); 
  clearImage.fill(200);
  clearImage.text(loadedFile, width / 2 - tw / 2, height / 20);
}

void keyPressed(){
  if(keyCode == DOWN){
    masterGain -= 1;
  }else if(keyCode == UP){
    masterGain += 1;
  }
  masterGain = constrain(masterGain, GAIN_OFF, GAIN_ON);
  settings.set("masterGain", masterGain);
  settings.save();
}

void handleWindowResize(){
  lastWidth = width;
  repositionButtons();
  
  if(bg != null){
    clearImage = createGraphics(width, height);
    clearImage.beginDraw();
    clearImage.tint(120);
    clearImage.image(bg, 0, 0, clearImage.width, clearImage.height);
    drawTitle();
    clearImage.endDraw();
  }
}

void initButtons(int rows, int cols){
  buttonRows = rows;
  buttonCols = cols;
  buttons = new MusicButton[buttonRows * buttonCols];
  for(int i = 0; i < buttons.length; i++) buttons[i] = new MusicButton();
}

void repositionButtons(){  
  buttonSize.set(width / 8.5, height / 9);
  buttonMargin.set(width / 64, height / 36);
  headerSize.set(buttonSize.x, buttonSize.y * .4f);
  float incX = buttonSize.x + buttonMargin.x;
  float incY = buttonSize.y + buttonMargin.y; 
  float offX = (width - (incX * buttonCols)) / 2 + incX / 2;
  float offY = (height - (incY * buttonRows)) / 1.2 + incY / 2;
  for(int x = 0; x < buttonCols; x++){
    for(int y = 0; y < buttonRows; y++){
      buttons[x + y * buttonCols].setPos(offX + incX * x, offY + incY * y);
    }
  }
}

void mouseMoved(){
  for(MusicButton mb: buttons){
    mb.updateUnderMouse();
  }
}

void mousePressed(){
  for(MusicButton mb: buttons){
    if(mb.hovered){
      mb.clicked = true;
      mb.click();
    }
  }
  if(rc.hover) rc.click();
}

void mouseReleased(){
  for(MusicButton mb: buttons){
    mb.clicked = false;
  }
}

void modifySurface(){
  surface.setResizable(true);
  surface.setTitle("SoundControl V2.0");
  rectMode(CENTER);
}
