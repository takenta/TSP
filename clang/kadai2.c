#include<stdio.h>
#include<stdlib.h>

typedef struct CITY{
  int numCity;
  int **distanceMatrix;
}CITY;




FILE *func_InputFile(char *);
CITY func_makeDistanceMatrix(FILE *);
int *func_nearestAddition(int *,int *,CITY);
void func_printArray(int *,int);
void func_printCost(int *,int,CITY);


int main(int argc,char *argv[]){
  FILE *fpin;
  char graph_Name[20];
  CITY city;
  int i;
  int *route;
  int *unusedNode;

  /*------------------
    ファイルインプット
   -------------------*/
  //printf("グラフのファイル名を入力してください.\nファイル名 = ");
  //scanf("%s",graph_Name);
  fpin = func_InputFile(argv[1]);
  printf("%s\n",argv[1]);
  /*-------------------
    都市距離行列の作成
    -------------------*/
  city = func_makeDistanceMatrix(fpin);
  /*-----------------------
    NearestAdditionによるpath生成
   ------------------------*/
  unusedNode = (int *)calloc(city.numCity,sizeof(int));
  
  route = (int *)calloc(city.numCity,sizeof(int)); 
  for(i=0;i<city.numCity;i++)
    unusedNode[i] = 1;
  route[0] = 0; //最初に0番目の都市を集合Tに代入
  unusedNode[0] = 0; //0はもう使っているのでunusedではない
  route = func_nearestAddition(route,unusedNode,city);

  /*-----------------
    コンソール出力
    -----------------*/
  printf("Nearest Additionによる経路生成結果\n");
  func_printArray(route,city.numCity);
  func_printCost(route,city.numCity,city);


  free(unusedNode);
  free(route);
  return 0;
}

FILE *func_InputFile(char *input){
  FILE *fp;
  if((fp = fopen(input,"r")) == NULL){
    printf("fuck off!!\n");
    exit(EXIT_FAILURE); //エラーなんで落ちます
  }
  return fp;
}

CITY func_makeDistanceMatrix(FILE *fp){
  CITY city;
  int i,j;
  int val;
  char c;
  i = 0;
  /*都市数の取得*/
  while(fscanf(fp,"%d%c",&val,&c)!=EOF){
    i++;
    if(c == '\n'){
      city.numCity = i;
      break;
    }    
  }
  /*都市行列*/
  city.distanceMatrix = (int **)malloc(sizeof(int *)*city.numCity);
  for(i=0;i<city.numCity;i++)
    city.distanceMatrix[i] = (int *)malloc(sizeof(int)*city.numCity);
  if(fseek(fp,0,SEEK_SET))
    exit;
  i=j=0;
  while(fscanf(fp,"%d%c",&val,&c)!=EOF){
    city.distanceMatrix[i][j]=val;
    i++;
    if(c == 10){
      j++;      
      i=0;
    }    
  }
  return city;
}

int *func_nearestAddition(int *route,int *unusedNode,CITY city){
  int j;
  int next;
  int temp;
  for(j=1;j<city.numCity;j++){
    next = func_getMinimumNextPath(j,city,route,unusedNode);
    temp = route[j];
    route[j] = next;
    route[j+1] = temp;
  }
  return route;
}

int func_getMinimumNextPath(int current,CITY city,int *route,int *unusedNode){
  int min = 30;
  int minimumNextPath;
  int i;
  for(i=0;i<city.numCity;i++){
    if(unusedNode[i])
      if(city.distanceMatrix[route[current]][i] < min){
	min = city.distanceMatrix[route[current]][i];
	minimumNextPath = i;
      }
  }
  unusedNode[minimumNextPath] = 0;
  return minimumNextPath;
  
}

void func_printArray(int *array,int length){
  int i;  
  for(i=0;i<length;i++)
    printf("%d -> ",array[i]);
}

void func_printCost(int *array,int length,CITY city){
  int i;
  int sum = 0;
  for(i=0;i+1<length;i++)
    sum += city.distanceMatrix[array[i]][array[i+1]]; 
  printf("Cost = %d\n",sum);
}
