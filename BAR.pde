class BAR{
  PImage im;
  boolean seF=false;
  boolean imF=false;
  AudioSnippet se;
  int sec;
  
  BAR (String fn, String fn2){
    im = loadImage(fn);
    se = minim.loadSnippet(fn2);
  }
  
  void draw(){
    image(im, 0, 0);
    if(!imF){
      sec = second();
      se.play();
      se.rewind();
    }
    imF = true;
  }
  void draw(boolean seflag){
    image(im, 0, 0);
    if(!imF){
      sec = second();
      if(seflag){
        se.play();
        se.rewind();
      }
    }
    imF = true;
  }  
  void draw(int x, int y){
    if(!imF)image(im, x, y);
    imF = true;
  }
  
  void reset(){
    imF = false;
    seF = false;
  }
}
