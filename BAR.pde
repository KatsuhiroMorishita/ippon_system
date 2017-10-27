import ddf.minim.*;

class BAR{
  PImage im;
  boolean seF = false;
  boolean imF = false;
  AudioSnippet se;
  int sec;
  
  BAR (String imageFileName, String soundFileName){
    this.im = loadImage(imageFileName);
    this.se = minim.loadSnippet(soundFileName);
  }
  
  void draw(){
    this.draw(true);
  }
  
  void draw(boolean seflag){
    image(this.im, 0, 0);
    if(!this.imF){
      this.sec = second();
      if(seflag){
        this.se.play();
        this.se.rewind();
      }
    }
    this.imF = true;
  }  
  
  void draw(int x, int y){
    if(!this.imF) image(this.im, x, y);
    this.imF = true;
  }
  
  void reset(){
    this.imF = false;
    this.seF = false;
  }
}



class newBar
{
  private PImage[] image;
  private AudioSnippet sound;
  private int maxIndex;
  private int showedIndex;
  private float showedTime;
  
  newBar(int maxIndex){
    this.reset();
    this.maxIndex = maxIndex;
    
    this.image = new PImage[maxIndex + 1];
    for(int i = 0; i <= maxPoint; i++){
      String fname = "data/ippon" + nf(i,2)+".png";   // nf is int/float to string
      this.image[i] = loadImage(fname);
    }
    
    this.sound = minim.loadSnippet("data/ta_ta_syun01.mp3");
  }
  
  void draw(int index){
    this.draw(index, true);
  }
  
  void draw(int index, boolean soundFlag){
    if(index < 0 || index > this.maxIndex){
      println("--index is over of index range--");
      return;
    }
    
    image(this.image[index], 0, 0);
    if(this.showedIndex != index){
      this.showedTime = second();
      if(soundFlag){
        this.sound.play();
        this.sound.rewind();
      }
    }
    this.showedIndex = index;
  }  
  
  boolean isLastShowed(){
    return this.showedIndex == this.maxIndex;
  }
  
  
  float getPassTime(){
    return second() - this.showedTime;
  }
  
  void reset(){
    this.showedIndex = -1;
    this.showedTime = second();
  }

}