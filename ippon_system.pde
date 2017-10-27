///////////////////////////////////////////////////////////////
//
// 2015年度高専祭企画IPPONグランプリ用画面表示プログラムVer.1.0
// IPPON_Processing.exe
//
// 2015/10/14 Ver.1.0 ロールアウト　
// 2015/10/26 Ver.1.1 ロールアウト
//                    問題の表示に対応　
// 
// ＊＊操作方法
// 　＊キー操作
//   　　a～zキー     ：審判の加点（人数に合わせてaから順番に割り当て）
//   　　0(ゼロ)キー  ：背景を切替（カメラ<-->白色）
//   　　1～9キー     ：カメラの切替（カメラの台数に合わせて1から順番に割り当て）
//   　　TABキー      ：リセット
//   　　ENTERキー    ：ポイントの表示
//
// BGM：
// 　フリー音楽素材 Senses Circuit[http://www.senses-circuit.com/]
// 　On-Jin ～音人～[http://on-jin.com/]
// を使用しています
//////////////////////////////////////////////////////////////

//Judgeでimport済み
//import ddf.minim.*;
//Minim minim;

//カメラ情報ファイル書き出し用
PrintWriter output;
String camInfoFileName = "CameraInfo.txt";
  
String csvFileName = "setup.csv";

import processing.video.*;
ArrayList<Capture> cam = new ArrayList();
boolean cameraExistFlag, cameraFlag;
int nowCamera = 0;

boolean pointDispFlag = false;
float allPoint = 0;
POINT_IM[] pointIm = new POINT_IM[10];

BAR[] bar = new BAR[11];
int judgeNum = 3;
int addLimit = 2;
ArrayList<JUDGE> judge = new ArrayList();

int mondaiNum = 20;
int nowMondaiNum = 0;
MONDAI[] mondai = new MONDAI[mondaiNum];

PImage ipponIm;
Movie ipponMv;
AudioSnippet ipponSE;

void setup(){
  //設定ファイルの読み込み
  String lines[] = loadStrings(csvFileName);
  String [] temp = new String [lines.length];
  int lineNum = 0;
  //カメラ設定の読み込み
  temp = split(lines[lineNum], ',');
  lineNum++;
  int cameraNum = int(temp[0]);
  int[] cameraID = new int[cameraNum];
  for(int i=0; i<cameraNum; i++){
    cameraID[i] = int(temp[1+i]);
  }
  
  //審判設定の読み込み
  temp = split(lines[lineNum], ',');
  judgeNum = int(temp[0]);
  addLimit = int(temp[1]);
  
  cameraFlag = false;
  //Webカメラのセットアップ
  String[] cameras = Capture.list();
 
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    cameraExistFlag = false;
    cameraFlag = false;
    //exit();
  } else {
    cameraExistFlag = true;
    output = createWriter(camInfoFileName);
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println("["+i+"]"+cameras[i]);
      output.println("["+i+"]"+cameras[i]);
    }
    for(int i=0; i<cameraNum; i++){
      cam.add(new Capture(this, cameras[cameraID[i]]));
      cam.get(i).start();     
    }
    output.flush(); //ストリームをフラッシュする
    output.close(); //ストリームをクローズする
  } 
  
  minim = new Minim(this);
  size(1280, 720);

  String fn;
  for(int i=0; i<10; i++){
    fn = "data/"+i+".png";
    pointIm[i] = new POINT_IM(fn,"data/shock1.mp3");
  }
  ipponIm = loadImage("data/ippon.jpg");
  ipponMv = new Movie(this,"ipponMovie.mp4");
  ipponSE = minim.loadSnippet("data/ta_ge_ootaiko02.mp3");
    
  for(int i=0; i<11; i++){
    fn = "data/ippon"+nf(i,2)+".png";
    bar[i] = new BAR(fn,"data/ta_ta_syun01.mp3");
  }
  
  float lp = 10.0/judgeNum;
  float w = lp/addLimit;
  for(int i=0; i<judgeNum; i++){
    judge.add(new JUDGE(addLimit, w, (char)('a'+i)));
    //println(judge.get(i).keyID);
  }
  //println(judge.size());
  
  //問題の読み込み
  for(int i=0; i<mondaiNum; i++){
    fn = "data/mondai"+nf(i,2)+".png";
    mondai[i] = new MONDAI(fn);
  }
}

void draw(){
  background(255);
    
  //合計点の計算
  allPoint = 0;
  for(int i=0; i<judgeNum; i++){
    //println("["+i+"]"+judge.get(i).point);
    allPoint += judge.get(i).point;
  }

  //背景の描画
  if(cameraExistFlag){
    if(cam.get(nowCamera).available() == true) {
      cam.get(nowCamera).read();
    }
  }
  if(cameraFlag) image(cam.get(nowCamera),0,0,800,600);
  else mondai[nowMondaiNum].draw(0,0);  
  bar[0].draw(false);

  //合計点の表示
  if(pointDispFlag){
    if(round(allPoint)<=9){
      pointIm[round(allPoint)].draw(width/2-pointIm[round(allPoint)].im.width/2, height/2-pointIm[round(allPoint)].im.height/2);
    }
  }
  
  //barの描画
  if(round(allPoint)>=1) bar[round(allPoint)].draw();
  //println("All Point["+allPoint+"] -> ["+round(allPoint)+"]");
  //IPPONの描画
  if(bar[10].imF){
    int now = second();
    if(bar[10].sec > now) now+=60;
    //println("time:"+(now - bar[10].sec));
    if((now - bar[10].sec)>=0.5){
      ipponSE.play();
      image(ipponIm, width/2-ipponIm.width/2, height/2-ipponIm.height/2);
      //ipponMv.play();
      //image(ipponMv, width/2-(ipponMv.width)/2,height/2-(ipponMv.height)/2-5,ipponMv.width,ipponMv.height);
    }
  }
  
  allPoint = 0;
}

void movieEvent(Movie m) {
  m.read();
}

void stop(){
  minim.stop();
  super.stop();
}

void keyPressed(){
  if(keyCode == TAB){
    allPoint = 0;
    pointDispFlag = false;
    for(int i=0; i<judgeNum; i++){
      judge.get(i).reset();
    }
    for(int i=0; i<bar.length; i++){
      bar[i].reset();
    }
    ipponMv.jump(-ipponMv.duration());
    ipponMv.pause();
    ipponSE.rewind();    
  }
  else if(key == '0'){
    if(cameraExistFlag) cameraFlag = !(cameraFlag);
  }
  else if(key == '+'){
    if(nowMondaiNum < mondaiNum-1) nowMondaiNum++;
  }
  else if(key == '-'){
    if(nowMondaiNum > 0) nowMondaiNum--;
  }
  else if(keyCode == ENTER){
    for(int i=0; i<pointIm.length; i++){
      pointIm[i].reset();
    }
    pointDispFlag = true;
    //println(round(allPoint));
  }
  else if(!pointDispFlag){
    for(int i=0; i<judgeNum; i++){
      if(key == judge.get(i).keyID){
        judge.get(i).AddPoint();
      }
    }
    for(int i=0; i<cam.size(); i++){
      if(key == ('1'+i)) nowCamera = i;
    }
  }
}
