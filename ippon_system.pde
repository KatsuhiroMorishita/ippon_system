///////////////////////////////////////////////////////////////
// 高専祭企画IPPONグランプリ用画面表示プログラム
// author: Youhei Iwasaki (original ver.), Katsuhiro Morishita
// history: 
//   2021-10-26 カメラライブラリの更新に対応。Processing 4でないとエラーが出る。（笑）
// created: 2015/10/14　
//////////////////////////////////////////////////////////////
import processing.video.*;
import ddf.minim.*;
// --------------------------------------------


static int maxPoint = 10; // 最大得点

ArrayList<Capture> cam = new ArrayList(); // カメラ関係
boolean camViewEnable = false;
int nowCamera = 0;    // 画面に映すカメラのindex

judges judgeMems;     // 審判団オブジェクト
point points;         // 点数を表示するオブジェクト
int nowMondaiNum = 0; // 画面に映す問題のindex
question questions;   // 問題のオブジェクト
newBar bar;           // 枠を描画するオブジェクト

PImage ipponIm;       // ippon image
Movie ipponMv;        // ippon movie
AudioPlayer ipponSE;  // ippon sound
Minim minim = new Minim(this);

boolean drawReady = false;
boolean ipponSoundPlayedFlag = false; // IPPONを獲得した際の画像を表示済みだとtrue
boolean pointDispFlag = false; // 点数を表示する場合はtrueをセットすること
// --------------------------------------------


// Webカメラの情報をファイルに保存する
String[] saveCameraInfo()
{
  String cameras[] = Capture.list(); // アクセス可能なカメラの一覧を取得
  
  // カメラのリストが得られるまで、ひたすら待つ（video libのバージョンアップ対応）
  while (cameras.length == 0) {
    cameras = Capture.list();
    println("camera waiting...");
    delay(100);
  }
  
  
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
  
  if (cameras.length == 0){
    println("caution: There is no cameras.");
  }
  
  return cameras;
}


// 設定ファイルの読み込みと諸々の設定
void readSetupCsv()
{
  // カメラ情報の保存
  String cameras[] = saveCameraInfo();
  
  //設定ファイルの読み込み
  String lines[] = loadStrings("setup.txt");
  
  //カメラ設定のセット
  String camSettingVal[] = split(lines[0], ',');
  int cameraID[] = new int[camSettingVal.length];
  for(int i = 0; i < camSettingVal.length; i++){
    cameraID[i] = int(camSettingVal[i]);
  }
  println("--load camera ID setting--");
  println(cameraID);
  
  //審判設定のセット
  int judgeNum = int(lines[1]);               // 審判数
  judgeMems = new judges(judgeNum, maxPoint, maxPoint);
  
  //Webカメラのセットアップ
  if (cameras.length > 0) {
    for(int i = 0; i < cameraID.length; i++){
      var id_ = cameraID[i];
      if (id_ < cameras.length){   // 変なカメラ番号が使われないようにする
        cam.add(new Capture(this, cameras[id_]));
        cam.get(i).start();
      }
    }
  } 
  return;
}




void setup(){
  size(1280, 720); // window size
  
  readSetupCsv();

  // 音の読み込み
  ipponIm = loadImage("data/ippon.jpg");
  ipponMv = new Movie(this, "ipponMovie.mp4");
  ipponSE = minim.loadFile("data/ta_ge_ootaiko02.mp3");
  
  // 枠のオブジェクトのインスタンス確保（と画像・音源の読み込み）
  bar = new newBar(maxPoint);
  
  // 点数の画像のオブジェクトのインスタンス確保
  points = new point(maxPoint);
  
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
  
  // カメラ画像又は問題の表示
  if(camViewEnable) 
    image(cam.get(nowCamera), 0, 0, width, height);
  else 
    questions.draw(nowMondaiNum, 0, 0);  

  //合計点の表示
  int totalPoint = int(judgeMems.getTotalPoint());
  if(pointDispFlag){
    if(totalPoint <= maxPoint - 1){
      points.draw(totalPoint);
    }
  }
  
  //barの描画
  bar.drawZero(); // 枠みたいなもので、必ず描画するらしい
  if(totalPoint >= 1) 
    bar.drawWithSound(totalPoint);
  
  // 必要ならIPPONの描画
  if(bar.isLastShowed())
  {
    if(ipponSoundPlayedFlag == true){
      // show IPPON logo
      image(ipponIm, width/2-ipponIm.width/2, height/2-ipponIm.height/2);
      // if you like movie, remove comment out //
      //ipponMv.play();
      //image(ipponMv, width/2-(ipponMv.width)/2,height/2-(ipponMv.height)/2-5,ipponMv.width,ipponMv.height);
    }
    
    // 音を鳴らす（確実に1回）
    if(ipponSoundPlayedFlag == false){
      if(bar.getPassTime() >= 0.05){   // この遅延処理は必要なのか？
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

// 終了時に呼び出される
void dispose() {
  // カメラの停止
  for(int i = 0; i < cam.size(); i++){
    cam.get(i).stop();
  }
  
  stop();
  println("exit.");
}


// 1画面（問題）における、審判の投票や枠の描画をリセットする
void resetStage()
{
  pointDispFlag = false;  // 点数を非表示
  camViewEnable = false;  // カメラ画像も非表示
  judgeMems.reset();      // 審判達の投票も初期化
  bar.reset();            // 枠の表示されたという状態の初期化
  ipponMv.jump(-ipponMv.duration());
  ipponMv.pause(); 
}


// キー入力に対する応答
void keyPressed()
{
  print("--key pressed-- ");
  println(str(key));
  
  if(keyCode == TAB){  // reset voted point
    resetStage();
  }
  else if(key == '0'){ // カメラのON/OFFを切り替える
    if(cam.size() > 0) camViewEnable = !(camViewEnable); 
  }
  else if(key == '+'){  // next problem
    if(nowMondaiNum < questions.length() - 1) nowMondaiNum++;
    resetStage();
  }
  else if(key == '-'){
    if(nowMondaiNum > 0) nowMondaiNum--;
    resetStage();
  }
  else if(keyCode == ENTER){ // 点数の表示
    pointDispFlag = true;
  }
  else if(!pointDispFlag && 'a' <= key && key <= 'z'){    // 審査員の加点処理
    println("--vote--");
    judgeMems.vote(str(key)); 
  }
  else if(!pointDispFlag && '1' <= key && key <= '9'){    // カメラ切り替え処理
    for(int i = 0; i < cam.size(); i++){
      if(key == ('1' + i)) {
        nowCamera = i;
        println("--camera changed--");
        print("camera ID ");
        println(nowCamera);
      }
    }
  }
}
