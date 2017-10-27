import ddf.minim.*;

class JUDGE{
  float point, weight;
  int addLimit, addNum;
  char keyID;
   
  JUDGE(int al, float w, char id){
    addNum = 0;
    addLimit = al;
    point = 0.0;
    weight = w;
    keyID = id;
  }
  
  void reset(){
    addNum = 0;
    point = 0.0;
  }
  void AddPoint(){
    if(addNum>=addLimit) return;
    point += 1*weight;
    addNum++;
  }
  char getID(){
    return keyID;
  }
}