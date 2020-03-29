class RemoteControl{
  
  PVector pos = new PVector(10, 30);
  color lines = color(70);
  int lighterLines = 90;
  color background = color(50);
  boolean selected = false;
  boolean hover = false;
  boolean click = false;
  
  void render(){
    updateHover();
    stroke(hover ? 100 : 70);
    fill(hover ? 70: 30);
    rect(width - (pos.x + width * .05), height * 0.03, width * .1, height * .05, borderRadius);
    
    fill(255);
    stroke(255);
    textSize(height * 0.025);
    String msg = "RC: " + (selected ? "ON" : "OFF");
    float tw = textWidth(msg);
    text(msg, width - pos.x - tw * 1.5, height * 0.037);
  }
  
  void updateHover(){
    float w = width * .1;
    float h = height * 0.025;
    boolean betweenX = mouseX > width - pos.x - w && mouseX < width - pos.x;
    boolean betweenY = mouseY > pos.y - h && mouseY < pos.y + h;
    hover = betweenX && betweenY;
  }
  
  void click(){
    selected = !selected;
  }
}

void renderMasterGain(){
  fill(30, 100);
  stroke(90);
  textSize(height * 0.025);
  String msg = "Gain: " + masterGain + " dB";
  float tw = textWidth(msg);
  rect(width * 0.07, height * 0.03, width * 0.12, height * 0.05, borderRadius);
  fill(colors.white);
  text(msg, width * 0.07 - tw / 2, height * 0.037);
}

void checkRemote(){
  if(!rc.selected) return;
  String[] lines = loadStrings("https://interwing.nl/soundcontrol/song.txt");
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
  for(String line: response) if(line.trim().length() > 1) println(line);
}
