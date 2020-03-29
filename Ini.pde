Ini settings;

class Ini{
  String url;
  HashMap<String, String> map = new HashMap<String, String>();
  
  Ini(String url){
    this.url = url;
    String[] lines = loadStrings(url);
    for(String line: lines){
      parseLine(line);
    }
  }
  
  void parseLine(String line){
    String[] parts = line.split("=");
    if(parts.length < 2) return;
    
    for(int i = 0; i < parts.length; i++){
      parts[i] = parts[i].trim();
    }
    map.put(parts[0], parts[1]);
  }
  
  String getString(String key){
    return map.get(key);
  }
  
  float getFloat(String key){
    return float(map.get(key));
  }
  
  int getInt(String key){
    return int(map.get(key));
  }
  
  boolean getBoolean(String key){
    return boolean(map.get(key));
  }
  
  void set(String key, String value){
    map.put(key, value);
  }
  
  void set(String key, float value){
    map.put(key, "" + value);
  }
  
  void set(String key, int value){
    map.put(key, "" + value);
  }
  
  void set(String key, boolean value){
    map.put(key, "" + value);
  }
  
  void save(){
    StringList lines = new StringList();
    for(HashMap.Entry<String, String> entry: map.entrySet()){
      String value = entry.getValue();
      String key = entry.getKey();
      String line = key + " = " + value;
      lines.append(line);
    }
    saveStrings(url, lines.array());
  }
}
