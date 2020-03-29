String loadedFile = "-";

void loadFile(String url){
  File f = new File(url);
  loadedFile = url;
  String folder = f.getParentFile() + File.separator;
  String[] lines = loadStrings(url);
  int counter = 0;
  for(String line: lines){
    ButtonDef def = parseLine(line, folder);
    if(def != null){
      if(counter >= buttons.length) break;
      buttons[counter].loadFromDef(def);
      counter ++;
    }
  }
}

ButtonDef parseLine(String line, String folder){
  String[] parts = line.split("\t");
  if(parts.length < 3) return null;
  ButtonDef def = new ButtonDef();
  def.fill = unhex(parts[0].replace("#", "FF"));
  def.title = parts[1];
  def.url = parts[2];
  def.folder = folder;
  return def;  
}
