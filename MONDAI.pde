class MONDAI{
  PImage im;
  
  MONDAI(String fileName){
    im = loadImage(dataPath(fileName));
  }
  
  void draw(int x, int y){
    image(this.im, x, y);
  }
}