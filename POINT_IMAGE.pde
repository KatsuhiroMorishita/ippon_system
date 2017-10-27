class POINT_IM{
  PImage im;
  AudioSnippet se;
  int sec;
  
  POINT_IM(String fn, String fn2){
    im = loadImage(fn);
    se = minim.loadSnippet(fn2);
  }
  
  void draw(int x, int y){
    sec = second();
    image(im, x, y);
    se.play();
  }

  void reset(){
    se.rewind();
  }  
}
