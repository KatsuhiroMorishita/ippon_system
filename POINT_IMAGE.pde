import ddf.minim.*;


Minim pointMinim = new Minim(this); // クラスメンバとして使いたいのだが、、、


// 点数の画像を管理するクラス
class point
{
  private PImage[] images;     // 点数の画像を格納する
  private AudioSnippet player; // 音源を再生させるオブジェクト
  private float drawTime;
  
  // コンストラクタ
  point(int maxPoint){
    this.images = new PImage[maxPoint]; // 最大が10点なら、0-9点分を読み込む
    this.drawTime = second();
    
    for(int i = 0; i < maxPoint; i++){
      String fname = i + ".png";
      String path = dataPath(fname);
      println(path);
      this.images[i] = loadImage(path);
    }
    
    String soundFile = dataPath("shock1.mp3");
    println(soundFile);
    this.player = pointMinim.loadSnippet(soundFile);
    print("--point sound--  ");
    println(this.player);
  }
  
  // ポイントの画像の数を返す
  public int length(){
    return this.images.length;
  }
  
  // 描画する
  public void draw(int score){
    if(score < 0 || score >= this.images.length) return;
    
    PImage img = this.images[score];
    if(img != null){     // 読み込みの前に描画が始まることが有るので、その対策
      int x = width / 2 - img.width / 2;
      int y = height / 2 - img.height / 2;
      image(img, x, y);
      
      if(second() - this.drawTime > 1){ // 毎回最初の描画直後にしか音を鳴らしたくない
        this.player.play();
        this.player.rewind();
      }
      this.drawTime = second();
    }
  }
}