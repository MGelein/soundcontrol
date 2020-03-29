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
int ACTIVITY_TIMEOUT = 10 * 1000;
int lastActivity = 0;
int normalFrameRate = 20;
int slowFrameRate = 2;
int targetFrameRate = normalFrameRate;
final String keyString = "1234567890abcdefghijklmnopqrstuvwxyz";

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
  frameRate(targetFrameRate);
  gainBuffer = createGraphics(300, 100);
  repositionButtons();
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
  background(0);
  if(bg != null) image(clearImage, 0, 0);
  
  handleDynamicFrameRate();
  
  for(MusicButton mb: buttons) mb.render();
  rc.render();
  renderMasterGain();
  
  if(lastWidth != width) handleWindowResize();
  
  handleNetworking();
  
  drawFrameRate();
  
  if(targetFrameRate != normalFrameRate){
    fill(0, 180);
    noStroke();
    rect(width / 2, height / 2, width, height);
    fill(colors.white);
    textSize(height / 20);
    String msg = "Sleeping due to continuous inactivity...";
    tw2 = textWidth(msg) / 2;
    text(msg, width / 2 - tw2, height / 2);
  }
}

void drawFrameRate(){
  fill(colors.white);
  stroke(colors.white);
  textSize(10);
  text(round(frameRate) + "/" + targetFrameRate + " fps", 10, height - 10);
}

void handleDynamicFrameRate(){
  if(targetFrameRate == normalFrameRate){
    if(millis() - lastActivity > ACTIVITY_TIMEOUT){
      targetFrameRate = slowFrameRate;
      frameRate(targetFrameRate);
    }
  }else if(targetFrameRate == slowFrameRate){
    if(millis() - lastActivity < ACTIVITY_TIMEOUT){
      targetFrameRate = normalFrameRate;
      frameRate(targetFrameRate);
    }
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
  }else{
    int index = keyString.indexOf(key);
    if(index >= 0 && index < buttons.length){
      buttons[index].click();
    }
  }
  masterGain = constrain(masterGain, GAIN_OFF, GAIN_ON);
  settings.set("masterGain", masterGain);
  settings.save();
  gainNeedsUpdate = true;
  lastActivity = millis();
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
  for(int i = 0; i < buttons.length; i++) buttons[i] = new MusicButton(keyString.charAt(i) + "");
}

void repositionButtons(){  
  buttonSize.set(width / 8.5, height / 9);
  buttonMargin.set(width / 64, height / 36);
  buttonExtra.set(buttonMargin.x / 2, buttonMargin.y / 2);
  halfBs.set(buttonSize.x / 2, buttonSize.y / 2);
  headerSize.set(buttonSize.x, buttonSize.y * .4f);
  float incX = buttonSize.x + buttonMargin.x;
  float incY = buttonSize.y + buttonMargin.y; 
  float offX = (width - (incX * buttonCols)) / 2 + incX / 2;
  float offY = (height - (incY * buttonRows)) / 1.2 + incY / 2;
  for(int x = 0; x < buttonCols; x++){
    for(int y = 0; y < buttonRows; y++){
      MusicButton b = buttons[x + y * buttonCols];
      b.createBuffer();
      b.pos.set(offX + incX * x, offY + incY * y);
      b.needsUpdate = true;
    }
  }
}

void mouseMoved(){
  lastActivity = millis();
}

void mousePressed(){
  for(MusicButton mb: buttons){
    if(mb.hovered){
      mb.click();
      mb.clicked = true;
    }
  }
  if(rc.hover) rc.click();
}

void mouseReleased(){
  for(MusicButton mb: buttons){
    if(mb.clicked) {
      mb.clicked = false;
      mb.needsUpdate = true;
    }
  }
}

void modifySurface(){
  surface.setResizable(true);
  surface.setTitle("SoundControl V2.0");
  rectMode(CENTER);
}
