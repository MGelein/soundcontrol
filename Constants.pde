Fonts fonts = new Fonts();
Colors colors = new Colors();

class Colors{
  color white = color(255);
  color black = color(0);
}

class Fonts{
  PFont normal, bold;
  
  void load(){
    normal = createFont("./CaviarDreams.ttf", 48);
    bold = createFont("./CaviarDreams_Bold.ttf", 48);
  }
}

class ButtonDef{
  String title;
  String url;
  String folder;
  int startPos;
  color fill;
}
