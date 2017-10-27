class MONDAI{
  PImage im;
  
  MONDAI(String fn){
    im = loadImage(fn);
  }
  
  void draw(int x, int y){
    image(im, x, y);
  }
}
