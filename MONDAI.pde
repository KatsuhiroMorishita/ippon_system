
// 問題の画像を管理するクラス
class question
{
  ArrayList<PImage> images = new ArrayList(); // 問題の画像を格納する
  
  question(){
    for(int i = 0; i < 1000; i++){
      String fname = "mondai" + nf(i, 2) + ".png";
      String path = dataPath(fname);
      
      File f = new File(path);
      if (f.exists()){
        println(path);
        images.add(loadImage(path));
      }else{
        break;
      }
    }
  }
  
  public int length(){
    return this.images.size();
  }
  
  public void draw(int index, int x, int y){
    if(index < 0 || index >= this.images.size()) return;
    
    PImage _image = images.get(index);
    if(_image != null)     // おそらく、読み込みの前に描画が始まることが有るので、その対策
      image(_image, x, y);
  }
}