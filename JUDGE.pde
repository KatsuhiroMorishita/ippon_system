

class judge
{
  private float point;
  private float pointUnit;
  private float pointLimit;
  private String name;
   
  judge(float pointLimit, float pointUnit, String name){
    this.point = 0.0;
    this.pointUnit = pointUnit;
    this.name = name;
    this.pointLimit = pointLimit;
  }
  
  public void reset(){
    this.point = 0.0;
  }
  
  public void vote(String name){
    if(this.name.equals(name) == false) return;
    if(this.point > this.pointLimit) return;
    point += this.pointUnit;
  }
  
  public float getPoint(){
    return this.point;
  }
}



class judges
{
  private judge[] judgeMem;
  private int memberNum;
  float totalPointLimit;
  
  judges(int memberNum, float totalPointLimit, int totalVoteTimesLimit){
    this.memberNum = memberNum;
    this.totalPointLimit = totalPointLimit;
    
    float pointUnit = totalPointLimit / totalVoteTimesLimit;
    judgeMem = new judge[memberNum];
    for(int i = 0; i < memberNum; i++)
      this.judgeMem[i] = new judge(totalPointLimit / memberNum, pointUnit, str(char('a' + i)));
  }
  
  public void reset(){
    for(int i = 0; i < this.memberNum; i++)
      this.judgeMem[i].reset();
  }
  
  public void vote(String name){
    for(int i = 0; i < this.memberNum; i++)
      this.judgeMem[i].vote(name);
  }
  
  public float getTotalPoint(){
    float sum = 0.0;
    for(int i = 0; i < this.memberNum; i++)
      sum += this.judgeMem[i].getPoint();
    
    if(sum > this.totalPointLimit) sum = totalPointLimit;
    return sum;
  }
}