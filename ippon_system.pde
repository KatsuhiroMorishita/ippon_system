///////////////////////////////////////////////////////////////
//
// 高専祭企画IPPONグランプリ用画面表示プログラム
// author: Youhei Iwasaki(original)
// created: 2015/10/14　
// 
// ＊＊操作方法
// 　＊キー操作
//   　　a～zキー     ：審判の加点（人数に合わせてaから順番に割り当て）
//   　　0(ゼロ)キー  ：背景を切替（カメラ<-->白色）
//   　　1～9キー     ：カメラの切替（カメラの台数に合わせて1から順番に割り当て）
//   　　TABキー      ：リセット
//   　　ENTERキー    ：ポイントの表示
//       +            :次の問題へ進む
//       -            :前の問題へ進む
//
// BGM：
// 　フリー音楽素材 Senses Circuit[http://www.senses-circuit.com/]
// 　On-Jin ～音人～[http://on-jin.com/]
//////////////////////////////////////////////////////////////
import processing.video.*;
import ddf.minim.*;



static int maxPoint = 10; // 最大得点

ArrayList<Capture> cam = new ArrayList(); // カメラ関係
boolean camViewEnable = false;
int nowCamera = 0;

judges judgeMems;     // 審判団オブジェクト
POINT_IM[] pointIm = new POINT_IM[maxPoint];
int nowMondaiNum = 0; // 画面に写すカメラのindex
question questions;
newBar bar;           // 枠を描画するオブジェクト

PImage ipponIm;       // ippon image
Movie ipponMv;        // ippon movie
AudioSnippet ipponSE; // ippon sound
Minim minim;

boolean drawReady = false;
boolean ipponSoundPlayedFlag = false; // IPPONを獲得した際の画像を表示済みだとtrue
boolean pointDispFlag = false; // 点数を表示する場合はtrueをセットすること


// Webカメラの情報をファイルに保存する
String[] saveCameraInfo()
{
  String cameras[] = Capture.list(); // アクセス可能なカメラの一覧を取得
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
  } else {
    PrintWriter output = createWriter("CameraInfo.txt");
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println("[" + i + "]" + cameras[i]);
      output.println("[" + i + "]" + cameras[i]);
    }
    output.flush(); //ストリームをフラッシュする
    output.close(); //ストリームをクローズする
  } 
  
  return cameras;
}



void readSetupCsv()
{
  // カメラ情報の保存
  String cameras[] = saveCameraInfo();
  
  //設定ファイルの読み込み
  String lines[] = loadStrings("setup.csv");
  
  //カメラ設定のセット
  String camSettingVal[] = split(lines[0], ',');
  int cameraNum = camSettingVal.length;        // 設定カメラ台数
  int cameraID[] = new int[cameraNum];
  for(int i = 0; i < camSettingVal.length; i++){
    cameraID[i] = int(camSettingVal[i]);
  }
  println("--cameraID--");
  println(cameraID);
  
  //審判設定のセット
  int judgeNum = int(lines[1]);               // 審判数
  judgeMems = new judges(judgeNum, maxPoint, maxPoint);
  
  //Webカメラのセットアップ
  if (cameras.length > 0) {
    for(int i = 0; i < cameraID.length; i++){
      cam.add(new Capture(this, cameras[cameraID[i]]));
      cam.get(i).start();
    }
  } 
  return;
}




void setup(){
  size(1280, 720); // windows size
  
  readSetupCsv();

  // 音の読み込み
  minim = new Minim(this);
  for(int i = 0; i < maxPoint; i++){
    String fn = "data/" + i + ".png";
    pointIm[i] = new POINT_IM(fn, "data/shock1.mp3");
  }
  ipponIm = loadImage("data/ippon.jpg");
  ipponMv = new Movie(this, "ipponMovie.mp4");
  ipponSE = minim.loadSnippet("data/ta_ge_ootaiko02.mp3");
  
  // 枠のオブジェクトのインスタンス確保（と画像・音源の読み込み）
  bar = new newBar(maxPoint);
  
  //問題の読み込み
  questions = new question();
  
  drawReady = true;
}



void draw()
{
  if(drawReady == false) return;
  background(255);
  
  // Webカメラを背景に描画
  if(cam.size() > 0){
    if(cam.get(nowCamera).available() == true) {
      cam.get(nowCamera).read();
    }
  }
  if(camViewEnable) 
    image(cam.get(nowCamera), 0, 0, width, height);
  else 
    questions.draw(nowMondaiNum, 0, 0);  

  //合計点の表示
  int totalPoint = int(judgeMems.getTotalPoint());
  if(pointDispFlag){
    if(totalPoint <= maxPoint - 1){
      pointIm[totalPoint].draw(width / 2-pointIm[totalPoint].im.width/2, height/2-pointIm[totalPoint].im.height/2);
    }
  }
  
  //barの描画
  bar.drawZero(); // 枠みたいなもので、必ず描画するらしい
  if(totalPoint >= 1) 
    bar.drawWithSound(totalPoint);
  
  // 必要ならIPPONの描画
  if(bar.isLastShowed())
  {
    // show IPPON logo
    image(ipponIm, width/2-ipponIm.width/2, height/2-ipponIm.height/2);
    // if you like movie, remove comment out //
    //ipponMv.play();
    //image(ipponMv, width/2-(ipponMv.width)/2,height/2-(ipponMv.height)/2-5,ipponMv.width,ipponMv.height);
    
    // 音を鳴らす（確実に1回）
    if(ipponSoundPlayedFlag == false){
      if((second() - bar.getPassTime()) >= 0.5){
        ipponSE.play();
        ipponSE.rewind();
        ipponSoundPlayedFlag = true;
        println("--IPPON sound played--");
      }
    }
  }else{
    ipponSoundPlayedFlag = false;
  }
}



void movieEvent(Movie m) 
{
  m.read();
}


// デスコンストラクタ的に使われるのだろうか・・・？
void stop(){
  minim.stop();
  super.stop();
}


// 1画面（問題）における、審判の投票や枠の描画をリセットする
void resetStage()
{
  pointDispFlag = false;
  camViewEnable = false;
  judgeMems.reset();
  bar.reset();     // 枠の表示されたという状態の初期化
  ipponMv.jump(-ipponMv.duration());
  ipponMv.pause(); 
}


// キー入力に対する応答
void keyPressed()
{
  print("--key pressed-- ");
  println(str(key));
  
  if(keyCode == TAB){
    resetStage();
  }
  else if(key == '0'){
    if(cam.size() > 0) camViewEnable = !(camViewEnable); // カメラのON/OFFを切り替える
  }
  else if(key == '+'){  // nest problem
    if(nowMondaiNum < questions.length() - 1) nowMondaiNum++;
    resetStage();
  }
  else if(key == '-'){
    if(nowMondaiNum > 0) nowMondaiNum--;
    resetStage();
  }
  else if(keyCode == ENTER){
    for(int i = 0; i < pointIm.length; i++){
      pointIm[i].reset();
    }
    pointDispFlag = true;
    //println(round(totalPoint));
  }
  else if(!pointDispFlag){
    // 審査員の加点処理
    judgeMems.vote(str(key)); 
    
    // カメラ切り替え処理
    for(int i = 0; i < cam.size(); i++){
      if(key == ('1' + i)) nowCamera = i;
    }
  }
}