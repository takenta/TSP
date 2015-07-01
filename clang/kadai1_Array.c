#include<stdio.h>
#include<stdlib.h>

typedef struct CITY{
  int numCity;
  int **distanceMatrix;
}CITY;

typedef struct ROUTE{
  int cost;
  int length;
  int *path;
}ROUTE;

FILE *func_InputFile(char *);
CITY func_makeDistanceMatrix(FILE *);
ROUTE *func_makeAllOfRoute(ROUTE,CITY,int *,ROUTE *,int,int *);
ROUTE func_makeARoute(ROUTE,CITY,int[]);
ROUTE func_ROUTECopy(ROUTE,int);
ROUTE func_getMinimumFromArray(ROUTE *,int);
void func_printROUTE(ROUTE route);
int *func_intArrayCopy(int *,int);
int func_fact(int);
int func_addROUTEtoArray(ROUTE,ROUTE *,int);

int main(int argc,char *argv[]){
  FILE *fpin;
  char graph_Name[20];
  CITY city;
  ROUTE *route_array;
  ROUTE *route_List;
  ROUTE route;
  ROUTE minimum;
  int route_array_Length;
  int *unusedNode;
  int i,j;
  int n = 0;
  int current=0;
  /*---------------------------------------------------
    ファイルインプット
   ---------------------------------------------------*/
  //printf("グラフのファイル名を入力してください.\nファイル名 = ");
  //scanf("%s",graph_Name);
  fpin = func_InputFile(argv[1]);

  /*------------------------------------
    都市距離行列の生成
  --------------------------------------*/
  city = func_makeDistanceMatrix(fpin);
  for(i=0;i<city.numCity;i++){
    for(j=0;j<city.numCity;j++){
      printf("%d ",city.distanceMatrix[i][j]);
    }
    printf("\n");
  }
  printf("都市数 = %d\n",city.numCity);

  /*------------------------------------------
    全経路の算出
   ------------------------------------------*/
  route_array_Length = func_fact(city.numCity);
  unusedNode = (int *)malloc(sizeof(int)*city.numCity);
  for(i=0;i<city.numCity;i++)
    unusedNode[i] = 1;
  route.length = 0;
  route.cost = 0;
  route.path = (int *)calloc(city.numCity,sizeof(int));

  for(i=0;i<city.numCity;i++)
    route.path[i] = 0;
  route_array = (ROUTE *)malloc(sizeof(ROUTE) * route_array_Length);
  route_List = func_makeAllOfRoute(route,city,unusedNode,route_array,route_array_Length,&current);

  /*----------------------------------------
    全経路から最小コスト経路の算出
    -----------------------------------------*/
  //for(i=0;i<route_array_Length;i++)
  //func_printROUTE(route_array[i]);
  minimum = func_getMinimumFromArray(route_array,route_array_Length);

  /*-----------------------------------------
    コンソール出力
  ------------------------------------------*/
  printf("最小コスト経路=\n");
  func_printROUTE(minimum);
  printf("\n");


  free(route_array);
  free(unusedNode);
  free(route.path);
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

int func_fact(int val){
  if(val > 0)
    return val * func_fact(val - 1);
  else if(val == 0)
    return 1;
}



ROUTE *func_makeAllOfRoute(ROUTE route,CITY city,int *unusedNode,ROUTE *route_List,int route_List_Length,int *current){
  int i;
  int temp;
  if(*current < route_List_Length ){
    if(route.length == city.numCity){
      //func_addROUTEtoArray(route,route_List,route_List_Length,current);
      //printf("current = %d\n",*current);
      route.cost += city.distanceMatrix[route.path[route.length-1]][0];
      route_List[*current] = route;
      route_List[*current].path = func_intArrayCopy(route.path,city.numCity);
      //func_printROUTE(route);
      *(current) = *(current) + 1;
    }else{
      for(i=0;i<city.numCity;i++){
	if(unusedNode[i]){
	  unusedNode[i] = 0;
	  temp = route.cost;
	  route.cost += city.distanceMatrix[route.path[route.length-1]][i];
	  route.path[route.length] = i;
	  route.length++;
	  func_makeAllOfRoute(route,city,unusedNode,route_List,route_List_Length,current);
	  route.length--;
	  unusedNode[i] = 1;
	  route.cost = temp;
	}
      }
    }
  }else{
    return route_List;
  }
}
ROUTE func_getMinimumFromArray(ROUTE *array,int length){
  int i;
  ROUTE min = array[0];
  for(i=0;i<length;i++){
    if(array[i].cost < min.cost){
      //printf("minimum replaced");
      min = array[i];
    }

  }
  return min;
}


int func_addROUTEtoArray(ROUTE route,ROUTE *array,int length){
  int i;
  int count = 0;
  for(i=0;i<length;i++)
    if(array[i].length){
      count++;
    }else if(count < length){
      array[i] = route;
      return 1;
    }else
      return 0;
}


void func_printROUTE(ROUTE route){
  int i;
  for(i=0;i<route.length;i++){
    printf("%d->",route.path[i]);
  }
  printf("    cost = %d",route.cost);
  printf("\n");
}


ROUTE func_ROUTECopy(ROUTE route,int pathlength){
  ROUTE temp;
  int i;
  temp.cost = route.cost;
  temp.length = route.length;
  temp.path = (int *)malloc(sizeof(int)*pathlength);
  for(i=0;i<pathlength;i++)
    temp.path[i] = route.path[i];
  return temp;
}

int *func_intArrayCopy(int *array,int length){
  int *temp;
  int i;
  temp = (int *)malloc(sizeof(int) * length);
    for(i=0;i<length;i++)
      temp[i] = array[i];
  return temp;
}

int func_length(ROUTE *array){
  int i=0;
  while(array[i].length > 0)
    i++;

  return i;
}
