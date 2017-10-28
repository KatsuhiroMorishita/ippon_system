class MONDAI{
  PImage im;
  
  MONDAI(String fileName){
    String path  = dataPath(fileName);
    println(path);
    this.im = loadImage(path);
    println(this.im);
  }
  
  void draw(int x, int y){
    if(this.im != null)     // おそらく、読み込みの前に描画が始まることが有るので、その対策
      image(this.im, x, y);
  }
}