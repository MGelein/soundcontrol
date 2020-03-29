boolean gainNeedsUpdate = true;
PGraphics gainBuffer;

class RemoteControl{
  
  PGraphics buffer;
  PVector pos = new PVector(10, 30);
  color lines = color(70);
  int lighterLines = 90;
  color background = color(50);
  boolean selected = false;
  boolean hover = false;
  boolean click = false;
  boolean needsUpdate = true;
  
  RemoteControl(){
    buffer = createGraphics(500, 300);
  }
  
  void render(){
    hover = updateHover();
    
    if(needsUpdate){
      buffer.beginDraw();
      buffer.clear();
      buffer.rectMode(CENTER);
      buffer.pushMatrix();
      buffer.translate(buffer.width / 2, buffer.height / 2);
      buffer.stroke(hover ? 100 : 70);
      buffer.fill(hover ? 70: 30);
      buffer.rect(- (pos.x + width * .05), 0, width * .1, height * .05, borderRadius);
      
      buffer.fill(255);
      buffer.stroke(255);
      buffer.textSize(height * 0.025);
      String msg = "RC: " + (selected ? "ON" : "OFF");
      float tw = buffer.textWidth(msg);
      buffer.text(msg, - pos.x - tw * 1.5, 0.007 * height);
      buffer.popMatrix();
      buffer.endDraw();
      needsUpdate = false;
    }
    
    image(buffer, width - pos.x - buffer.width / 2, pos.y - buffer.height / 2);
  }
  
  boolean updateHover(){
    float w = width * .1;
    float h = height * 0.025;
    boolean betweenX = mouseX > width - pos.x - w && mouseX < width - pos.x;
    boolean betweenY = mouseY > pos.y - h && mouseY < pos.y + h;
    boolean currentHover = betweenX && betweenY;
    if(currentHover != hover) needsUpdate = true;
    return currentHover;
  }
  
  void click(){
    selected = !selected;
    needsUpdate = true;
  }
}

void renderMasterGain(){
  if(gainNeedsUpdate){
    gainBuffer.beginDraw();
    gainBuffer.clear();
    gainBuffer.rectMode(CENTER);
    gainBuffer.fill(30, 100);
    gainBuffer.stroke(90);
    gainBuffer.textSize(height * 0.025);
    String msg = "Gain: " + masterGain + " dB";
    tw2 = gainBuffer.textWidth(msg) / 2;
    gainBuffer.rect(width * 0.07, height * 0.03, width * 0.12, height * 0.05, borderRadius);
    gainBuffer.fill(colors.white);
    gainBuffer.text(msg, width * 0.07 - tw2, height * 0.037);
    gainBuffer.endDraw();
    gainNeedsUpdate = false;
  }
  image(gainBuffer, 0, 0);
}

void checkRemote(){
  if(!rc.selected) return;
  String[] lines = loadStrings("https://interwing.nl/soundcontrol/song.txt");
  if(lines == null) return;
  String newSong = "";
  for(String line: lines){
    if(line.trim().length() > 1){
      newSong = line.trim();
    }
  }
  playSongByName(newSong);
}

void playSongByName(String name){
  for(MusicButton b : buttons){
    if(name.equals(b.title.toLowerCase().replace(" ", ""))){
      b.startPlayback();
    }else{
      b.stopPlayback();
    }
  }
}

void sendSongToRemote(String name){
  name = name.replace(" ", "");
  String[] response = loadStrings("https://interwing.nl/soundcontrol/song.php?song=" + name);
  if(response == null) return;
  for(String line: response) if(line.trim().length() > 1) println(line);
}
