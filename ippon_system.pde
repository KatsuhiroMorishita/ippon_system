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

// 
ArrayList<Capture> cam = new ArrayList(); // カメラ関係
boolean camViewEnable = false;
int nowCamera = 0;

boolean pointDispFlag = false;
POINT_IM[] pointIm = new POINT_IM[10];

BAR[] bar = new BAR[11];
int judgeNum = 3;
int addLimit = 2;
ArrayList<JUDGE> judge = new ArrayList();

int mondaiNum = 14;    // 問題数？
int nowMondaiNum = 0;
static int maxPoint = 10; // 最大得点
MONDAI[] mondai = new MONDAI[mondaiNum];

PImage ipponIm;       // ippon image
Movie ipponMv;        // ippon movie
AudioSnippet ipponSE; // ippon sound

Minim minim;


void readSetupCsv()
{
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
  String judgeSettingVal[] = split(lines[1], ',');
  judgeNum = int(judgeSettingVal[0]);  // 審判数
  addLimit = int(judgeSettingVal[1]);  // 審判当たりの投票できる点数
  float w = (float)maxPoint / judgeNum / addLimit; // 1人1票当たりの点数かな？
  for(int i = 0; i < judgeNum; i++){
    judge.add(new JUDGE(addLimit, w, (char)('a' + i)));
    //println(judge.get(i).keyID);
  }
  //println(judge.size());
  
  //Webカメラのセットアップ
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
    for(int i = 0; i < cameraNum; i++){ // cameraNum
      cam.add(new Capture(this, cameras[cameraID[i]]));
      cam.get(i).start();
      break;
    }
    output.flush(); //ストリームをフラッシュする
    output.close(); //ストリームをクローズする
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
  
  // 枠画像と、それに紐づいた音源の読み込み
  for(int i = 0; i <= maxPoint; i++){
    String fn = "data/ippon" + nf(i,2)+".png";   // nf is int/float to string
    bar[i] = new BAR(fn,"data/ta_ta_syun01.mp3");
  }
  
  //問題の画像の読み込み
  for(int i = 0; i < mondaiNum; i++){
    String fn = "mondai" + nf(i,2) + ".png";  // nf()で数字を2桁の文字列にする
    mondai[i] = new MONDAI(fn);
  }
}



void draw()
{
  background(255);
    
  //合計点の計算
  float totalPoint = 0.0;
  for(int i=0; i < judgeNum; i++){
    //println("["+i+"]"+judge.get(i).point);
    totalPoint += judge.get(i).point;
  }

  //背景の描画
  if(cam.size() > 0){
    if(cam.get(nowCamera).available() == true) {
      cam.get(nowCamera).read();
    }
  }
  if(camViewEnable) 
    image(cam.get(nowCamera), 0, 0, width, height);
  else 
    mondai[nowMondaiNum].draw(0,0);  

  //合計点の表示
  if(pointDispFlag){
    if(round(totalPoint) <= maxPoint - 1){
      pointIm[round(totalPoint)].draw(width / 2-pointIm[round(totalPoint)].im.width/2, height/2-pointIm[round(totalPoint)].im.height/2);
    }
  }
  
  //barの描画
  bar[0].draw(false); // 枠みたいなもので、必ず描画するらしい
  if(round(totalPoint) >= 1) 
    bar[round(totalPoint)].draw();
  
  //IPPONの描画
  if(bar[10].imF)
  {
    int now = second();
    
    if(bar[10].sec > now) now += 60;
    
    if((now - bar[10].sec) >= 0.5)
    {
      ipponSE.play();
      image(ipponIm, width/2-ipponIm.width/2, height/2-ipponIm.height/2);
      //ipponMv.play();
      //image(ipponMv, width/2-(ipponMv.width)/2,height/2-(ipponMv.height)/2-5,ipponMv.width,ipponMv.height);
    }
  }
}



void movieEvent(Movie m) 
{
  m.read();
}



void stop(){
  minim.stop();
  super.stop();
}



// キー入力に対する応答
void keyPressed()
{
  if(keyCode == TAB){
    pointDispFlag = false;
    for(int i = 0; i < judgeNum; i++){
      judge.get(i).reset();
    }
    // 枠の表示されたという状態の初期化
    for(int i = 0; i < bar.length; i++){
      bar[i].reset();
    }
    ipponMv.jump(-ipponMv.duration());
    ipponMv.pause();
    ipponSE.rewind();    
  }
  else if(key == '0'){
    if(cam.size() > 0) camViewEnable = !(camViewEnable); // カメラのON/OFFを切り替える
  }
  else if(key == '+'){  // nest problem
    if(nowMondaiNum < mondaiNum-1) nowMondaiNum++;
  }
  else if(key == '-'){
    if(nowMondaiNum > 0) nowMondaiNum--;
  }
  else if(keyCode == ENTER){
    for(int i = 0; i < pointIm.length; i++){
      pointIm[i].reset();
    }
    pointDispFlag = true;
    //println(round(totalPoint));
  }
  else if(!pointDispFlag){    // 審査員の加点処理
    for(int i = 0; i < judgeNum; i++){
      if(key == judge.get(i).keyID){  // 個々の審査員をkeyで区別する
        judge.get(i).AddPoint();
      }
    }
    for(int i = 0; i < cam.size(); i++){
      if(key == ('1' + i)) nowCamera = i;
    }
  }
}