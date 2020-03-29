final int borderRadius = 5;
int buttonRows = -1;
int buttonCols = -1;
final int GAIN_ON = 0;
final int GAIN_OFF = -60;
final float GAIN_EASE = 0.1;
final PVector buttonExtra = new PVector();
final PVector buttonMargin = new PVector();
final PVector buttonSize = new PVector(1, 1);
final PVector headerSize = new PVector();
final PVector halfBs = new PVector();
final int lines = 70;
final int lighterLines = 90;
final int bgColor = 50;
  
class MusicButton{
  final PVector pos = new PVector();
  AudioPlayer audio;
  String title = "-";
  String url = null;
  boolean triedLoading = false;
  boolean needsUpdate = true;
  PGraphics buffer;
  
  color highlight = color(255, 125, 0);
  boolean hovered = false;
  boolean clicked = false;
  
  float sizeMult = 0;
  float targetGain = GAIN_OFF;
  float gain = GAIN_OFF;
  float rms = 0;
  float bw2 = 0;
  float bh2 = 0;
  final String hotkey;
  
  MusicButton(String hotkey){
    this.hotkey = hotkey;
  }
  
  void createBuffer(){
    buffer = createGraphics(int(buttonSize.x * 1.3), int(buttonSize.y * 1.3));
    bw2 = buffer.width / 2;
    bh2 = buffer.height / 2;
  }
  
  void render(){
    //Stop rendering if no url is specified, and update hover status
    if(url == null || buffer == null) return;
    if(hovered && rc.selected) hovered = false;
    hovered = isUnderMouse();
    //Update the RMS from playing, this is eased
    rms = handleGain();
    if(rms != 0) {
      if(targetFrameRate < 10) needsUpdate = true;
      else if(frameCount % 2 == 0) needsUpdate = true;
    }
    
    //If necessary update the buffer, but render it whatever happens
    if(needsUpdate) updateRender();
    image(buffer, pos.x - bw2, pos.y - bh2);    
  }
  
  void updateRender(){
    buffer.beginDraw();
    buffer.clear();
    buffer.rectMode(CENTER);
    buffer.pushMatrix();
    buffer.translate(buffer.width / 2, buffer.height / 2);
    
    //Size mult makes for a nice highlightColor border around the edge
    sizeMult = hovered ? (clicked ? 1.3 : 1.1) : 0;
    
    //Create the button body, colors and header
    buffer.stroke(hovered ? (clicked ? colors.white : lighterLines) : lines);
    buffer.fill(highlight);
    buffer.rect(0, 0, buttonSize.x + buttonExtra.x * sizeMult, buttonSize.y + buttonExtra.y * sizeMult, borderRadius);
    buffer.stroke(hovered ? lines : bgColor);
    buffer.fill(hovered ? lines : bgColor);
    buffer.rect(0, -halfBs.y + headerSize.y, buttonSize.x, 10);
    buffer.rect(0, headerSize.y / 2, buttonSize.x, buttonSize.y - headerSize.y, borderRadius);
    
    //Fill the text
    buffer.textFont(fonts.bold);
    buffer.textSize(headerSize.y / 2);
    String caption = "[" + hotkey + "]: " + title;
    tw2 = buffer.textWidth(caption) / 2;
    buffer.fill(colors.black);
    buffer.text(caption, -tw2, -halfBs.y + headerSize.y / 1.7 + 2);
    buffer.fill(colors.white);
    buffer.text(caption, -tw2, -halfBs.y + headerSize.y / 1.7);
    
    //RMS outline
    buffer.stroke(lighterLines);
    buffer.noFill();
    buffer.rect(-buttonSize.x * .4, headerSize.y / 2 - 2, buttonSize.x * .1, (buttonSize.y - headerSize.y));
    
    //Draw icon
    drawIcon();
      
    //Draw rms if needed
    if(rms > 0){
      rms *= map(gain, GAIN_OFF, GAIN_ON, 0, 1);
      float rmsHeight = constrain((buttonSize.y - headerSize.y) * (rms * 4), 0, (buttonSize.y - headerSize.y));
      buffer.fill(colors.white);
      buffer.noStroke();
      buffer.rect(0 - buttonSize.x * .4, 0 - rmsHeight / 2 + buttonSize.y / 2 - 2, buttonSize.x * .1, -rmsHeight);
    }
    
    buffer.popMatrix();
    buffer.endDraw();
    needsUpdate = false;
  }
  
  void drawIcon(){
    buffer.fill(hovered ? lighterLines + 100 : lighterLines);
    buffer.noStroke();
    if(gain != targetGain){
      buffer.textSize(buttonSize.y * .3);
      String txt = "...";
      tw2 = buffer.textWidth(txt) / 2;
      buffer.text(txt, - tw2, buttonSize.y * .3);
    }else if(gain == GAIN_OFF){
      float x1 = -buttonSize.x * .1;
      float y1 = -buttonSize.y * .2;
      float x2 = -buttonSize.x * .1;
      float y2 = y1 * -1;
      float x3 = x1 * -1;
      float y3 = 0;
      float hsy2 = headerSize.y / 2;
      buffer.triangle(x1, y1 + hsy2, x3, y3 + hsy2, x2, y2 + hsy2);
    }else{
      buffer.rect(-buttonSize.x * .08, headerSize.y / 2, buttonSize.x * .1, buttonSize.y * .4);
      buffer.rect(buttonSize.x * .08, headerSize.y / 2, buttonSize.x * .1, buttonSize.y * .4);
    }
  }
  
  float handleGain(){
    if(audio != null){
      audio.setGain(gain + masterGain);
      if(gain != targetGain){
        float ease = targetFrameRate == normalFrameRate ? GAIN_EASE : GAIN_EASE * (normalFrameRate / targetFrameRate);
        if(gain < targetGain){
          gain += (targetGain - gain) * ease;
        }else{
          gain -= (gain * -ease) + ease;
        }
        if(abs(gain - targetGain) < .5) {
          gain = targetGain;
          if(gain == GAIN_OFF){
            audio.pause();
            audio.close();
            audio = null;
            triedLoading = false;
          }
        }
      }
      if(audio != null) return audio.mix.level();
      else return 0;
    }else{
      return 0;
    }
  }
  
  void click(){
    if(rc.selected) return;
    needsUpdate = true;
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
    needsUpdate = true;
  }
  
  void startPlayback(){
    targetGain = GAIN_ON;
    if(audio == null && !triedLoading) loadMusicFile(url);
    if(audio != null && !audio.isPlaying()) audio.loop();
    needsUpdate = true;
  }
  
  void stopPlayback(){
    targetGain = GAIN_OFF;
    needsUpdate = true;
  }
  
  boolean isUnderMouse(){
    boolean isNowHovered = (mouseX > pos.x - buttonSize.x / 2 && mouseX < pos.x + buttonSize.x / 2) && (mouseY > pos.y - buttonSize.y / 2 && mouseY < pos.y + buttonSize.y / 2);
    if(isNowHovered != hovered) needsUpdate = true;
    return isNowHovered;
  }
  
  void loadFromDef(ButtonDef def){
    title = def.title;
    highlight = def.fill;
    url = def.folder + def.url;
    triedLoading = false;
  }
  
  void loadMusicFile(String url){
    triedLoading = true;
    File soundFile = new File(url);
    if(!soundFile.exists()){
      println("Warning: Could not load soundfile: " + url);
      return;
    }
    this.url = url;
    audio = minim.loadFile(url); 
    if(audio != null) audio.setGain(GAIN_OFF);
    needsUpdate = true;
  }
}
