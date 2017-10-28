
// 一人の審査員を表すクラス
class judge
{
  private float point;      // 投票したポイント数
  private float pointUnit;  // 1票当たりのポイント数
  private float pointLimit; // 投票したポイント数の上限
  private String name;      // 審査委員の名前
   
  judge(float pointLimit, float pointUnit, String name){
    this.point = 0.0;
    this.pointUnit = pointUnit;
    this.name = name;
    this.pointLimit = pointLimit;
  }
  
  public void reset(){
    this.point = 0.0;
  }
  
  // 投票する
  public void vote(String name){
    if(this.name.equals(name) == false) return; // 自分自身への要求なのか、名前でチェック
    if(this.point > this.pointLimit) return;
    point += this.pointUnit;
  }
  
  public float getPoint(){
    return this.point;
  }
}


// 審判団を表すクラス
class judges
{
  private judge[] judgeMem;  // 複数の審判を擁する
  float totalPointLimit;
  
  judges(int memberNum, float totalPointLimit, int totalVoteTimesLimit){
    this.totalPointLimit = totalPointLimit;
    
    float pointUnit = totalPointLimit / totalVoteTimesLimit;
    judgeMem = new judge[memberNum];
    for(int i = 0; i < memberNum; i++)
      this.judgeMem[i] = new judge(totalPointLimit / memberNum, pointUnit, str(char('a' + i)));
  }
  
  // 点数の初期化
  public void reset(){
    for(int i = 0; i < this.judgeMem.length; i++)
      this.judgeMem[i].reset();
  }
  
  // 投票する
  public void vote(String name){
    for(int i = 0; i < this.judgeMem.length; i++)
      this.judgeMem[i].vote(name);
  }
  
  // 合計点を返す
  public float getTotalPoint(){
    float sum = 0.0;
    for(int i = 0; i < this.judgeMem.length; i++)
      sum += this.judgeMem[i].getPoint();
    
    if(sum > this.totalPointLimit) sum = totalPointLimit; // 安全のために、、、上限処理
    return sum;
  }
}