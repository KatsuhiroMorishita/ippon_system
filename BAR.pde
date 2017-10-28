import ddf.minim.*;

Minim varMinim = new Minim(this); // クラスメンバとして使いたいのだが、、、

class newBar
{
  private PImage[] image;      // ポイント数に紐付いた枠の画像のオブジェクトを格納する配列
  private AudioSnippet player; // 音源を再生させるオブジェクト
  private int maxIndex;
  private int showedIndex;   // showed index of a image with sound play
  private float showedTime;  // showed time of a image with sound play
  
  // コンストラクタ（オブジェクトの初期化）
  newBar(int maxIndex){
    this.reset();
    this.maxIndex = maxIndex;
    
    this.image = new PImage[maxIndex + 1];
    for(int i = 0; i <= maxPoint; i++){
      String fname = "ippon" + nf(i,2)+".png";   // nf is int/float to string
      String path  = dataPath(fname);
      println(path);
      this.image[i] = loadImage(path);
      println(this.image[i]);
    }
    
    String soundFile = dataPath("ta_ta_syun01.mp3");
    println(soundFile);
    this.player = varMinim.loadSnippet(soundFile);
    print("--bar sound--  ");
    println(this.player);
  }
  
  // 描画する
  public void drawZero(){
    image(this.image[0], 0, 0);
  }
  
  // 描画する
  public void drawWithSound(int index){
    if(index < 0 || index > this.maxIndex){
      println("--index is over of index range--");
      return;
    }
    
    image(this.image[index], 0, 0);
    if(this.showedIndex != index){
      this.showedTime = second();
      println("--bar sounc play--");
      if(this.player != null){
        this.player.play();
        this.player.rewind(); // 再生が終わったら巻き戻し
      }else{
        println("--bar sound is null--");
      }
      this.showedIndex = index;
    }
  }  
  
  // 最後の枠の描画が終わっていたらtrueを返す
  public boolean isLastShowed(){
    return this.showedIndex == this.maxIndex;
  }
  
  // 最後の枠（index > 0）の描画からの時間を取得
  public float getPassTime(){
    return second() - this.showedTime;
  }
  
  // drawWithSound()により変わった内部変数の初期化（コンストラクタからも呼び出すけど）
  public void reset(){
    this.showedIndex = -1;
    this.showedTime = second();
  }

}