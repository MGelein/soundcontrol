final int borderRadius = 5;
int buttonRows = -1;
int buttonCols = -1;
final int GAIN_ON = 0;
final int GAIN_OFF = -60;
final float GAIN_EASE = 0.05;
final PVector buttonMargin = new PVector();
final PVector buttonSize = new PVector();
final PVector headerSize = new PVector();
  
class MusicButton{
  PVector targetPos = new PVector();
  PVector pos = PVector.random2D().mult(1000);
  PVector acc = new PVector();
  
  AudioPlayer audio;
  String title = "-";
  String url = null;
  color highlight = color(255, 125, 0);
  color lines = color(70);
  int lighterLines = 90;
  color background = color(50);
  boolean hovered = false;
  boolean clicked = false;
  boolean disabled = false;
  float sizeMult = 0;
  float targetGain = GAIN_OFF;
  float gain = GAIN_OFF;
  float rms = 0;
  
  void render(){
    if(url == null) return;
    
    disabled = url.length() < 2;
    if(hovered){
      sizeMult += ((clicked ? 2 : 1) - sizeMult) * (clicked ? 0.2 : 0.1);
    }else{
      sizeMult *= 0.9f;
    }
    
    if(hovered && rc.selected) hovered = false;
    
    rms += (handleGain() - rms) * 0.2;
        
    acc.x += (targetPos.x - pos.x) * 0.03;
    acc.y += (targetPos.y - pos.y) * 0.03;
    pos.add(acc);
    acc.mult(0.7);
    
    if(headerSize.y < 1) return;
    stroke(hovered ? lighterLines : lines);
    fill(disabled ? 120 : highlight);
    PVector extra = new PVector(buttonMargin.x / 2, buttonMargin.y / 2);
    extra.mult(sizeMult);
    rect(pos.x, pos.y, buttonSize.x + extra.x, buttonSize.y + extra.y, borderRadius);
    stroke(hovered ? lines : background);
    fill(hovered ? lines : background);
    rect(pos.x, pos.y - buttonSize.y / 2 + headerSize.y, buttonSize.x, 10);
    rect(pos.x, pos.y + headerSize.y / 2, buttonSize.x, buttonSize.y - headerSize.y, borderRadius);
    
    textFont(fonts.bold);
    textSize(headerSize.y / 2);
    String caption = title;
    float tw2 = textWidth(caption) / 2;
    fill(colors.black);
    text(caption, pos.x - tw2, pos.y - buttonSize.y / 2 + headerSize.y / 1.5 + 2);
    fill(colors.white);
    text(caption, pos.x - tw2, pos.y - buttonSize.y / 2 + headerSize.y / 1.5);
    
    //RMS outline
    stroke(lighterLines);
    noFill();
    rect(pos.x - buttonSize.x * .4, pos.y + headerSize.y / 2 - 2, buttonSize.x * .1, (buttonSize.y - headerSize.y));
    
    //Draw icon
    drawIcon();
      
    //Draw rms if needed
    if(rms > 0){
      rms *= map(gain, GAIN_OFF, GAIN_ON, 0, 1);
      float rmsHeight = constrain((buttonSize.y - headerSize.y) * (rms * 4), 0, (buttonSize.y - headerSize.y));
      color c = lerpColor(colors.white, highlight, rmsHeight / (buttonSize.y - headerSize.y));
      fill(c);
      noStroke();
      rect(pos.x - buttonSize.x * .4, pos.y - rmsHeight / 2 + buttonSize.y / 2 - 2, buttonSize.x * .1, -rmsHeight);
    }
  }
  
  void drawIcon(){
    fill(hovered ? lighterLines + 100 : lighterLines);
    noStroke();
    if(gain != targetGain){
      textSize(buttonSize.y * .3);
      String txt = "...";
      float tw2 = textWidth(txt) / 2;
      text(txt, pos.x - tw2, pos.y + buttonSize.y * .3);
    }else if(gain == GAIN_OFF){
      if(audio != null){
        float x1 = -buttonSize.x * .1;
        float y1 = -buttonSize.y * .2;
        float x2 = -buttonSize.x * .1;
        float y2 = y1 * -1;
        float x3 = x1 * -1;
        float y3 = 0;
        float hsy2 = headerSize.y / 2;
        triangle(pos.x + x1, pos.y + y1 + hsy2, pos.x + x3, pos.y + y3 + hsy2, pos.x + x2, pos.y + y2 + hsy2);
      }else{
        fill(200, 0, 0);
        textSize(buttonSize.y * .2);
        String msg = "Could not\nload file";
        float tw2 = textWidth(msg) / 2;
        text(msg, pos.x - tw2, pos.y + headerSize.y / 3.5);
      }
    }else{
      rect(pos.x - buttonSize.x * .08, pos.y + headerSize.y / 2, buttonSize.x * .1, buttonSize.y * .4);
      rect(pos.x + buttonSize.x * .08, pos.y + headerSize.y / 2, buttonSize.x * .1, buttonSize.y * .4);
    }
  }
  
  float handleGain(){
    if(audio != null){
      audio.setGain(gain + masterGain);
      if(gain != targetGain){
        if(gain < targetGain){
          gain += (targetGain - gain) * GAIN_EASE;
        }else{
          gain -= (gain * -GAIN_EASE) + GAIN_EASE;
        }
        if(abs(gain - targetGain) < .5) {
          gain = targetGain;
          if(gain == GAIN_OFF){
            audio.pause();
          }
        }
      }
      return audio.mix.level();
    }else{
      return 0;
    }
  }
  
  void click(){
    if(rc.selected) return;
    if(targetGain == GAIN_OFF){
      for(MusicButton b: buttons){
        if(b == this) {
          b.startPlayback();
          sendSongToRemote(b.title.toLowerCase());
        }
        else b.stopPlayback();
      }
    }else{
      stopPlayback();
      if(!rc.selected){
        sendSongToRemote("-");
      }
    }
  }
  
  void startPlayback(){
    targetGain = GAIN_ON;
    if(audio != null && !audio.isPlaying()) audio.loop();
  }
  
  void stopPlayback(){
    targetGain = GAIN_OFF;
  }
  
  void setPos(float x, float y){
    acc = PVector.random2D().mult(20);
    targetPos.set(x, y);
  }
  
  boolean updateUnderMouse(){
    hovered = (mouseX > pos.x - buttonSize.x / 2 && mouseX < pos.x + buttonSize.x / 2) && (mouseY > pos.y - buttonSize.y / 2 && mouseY < pos.y + buttonSize.y / 2);
    return hovered;
  }
  
  void loadFromDef(ButtonDef def){
    title = def.title;
    highlight = def.fill;
    loadMusicFile(def.folder + def.url);
  }
  
  void loadMusicFile(String url){
    File soundFile = new File(url);
    if(!soundFile.exists()){
      println("Warning: Could not load soundfile: " + url);
      return;
    }
    this.url = url;
    audio = minim.loadFile(url);
  }
}
