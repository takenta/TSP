#include<stdio.h>
#include<stdlib.h>


#define RANDOW_SEED 3

typedef struct CITY{
  int **distanceMatrix;
  int numCity;
}CITY;



typedef struct ROUTE{
  int cost;
  struct NODE *root;
}ROUTE;

typedef struct NODE_ROUTE{
  struct ROUTE route;
  struct NODE *next;
}NODE_ROUTE;

typedef struct NODE_VAL{
  int value;
  struct NODE *next;
}NODE_VAL;

FILE *func_InputFile(char *);
CITY func_makeDistanceMatrix(FILE *);
/*リスト系関数*/
NODE_ROUTE *func_makeAllOfRoute_List(CITY);
ROUTE func_makeARoute(ROUTE,CITY,int[]);
NODE_ROUTE *func_getMinimumFromList(NODE_ROUTE *);
NODE_ROUTE *func_addRouteToList(ROUTE,NODE_ROUTE *);
NODE_VAL *func_addValueToList(int,NODE_VAL *);
void func_printList(NODE_VAL *);
void func_freeList(NODE_VAL *);
/*clang*/


/*配列系関数*/
int **func_makeAllOfRoute_Array();
int func_getMinimumFromArray();
int func_getSizeOfArray();

int main(void){
  FILE *fpin;
  char graph_Name[20];
  CITY city;
  NODE_ROUTE *root;
  NODE *minimum;
  int i,j;
  /*---------------------------------------------------
    ファイルインプット
   ---------------------------------------------------*/  
  printf("グラフのファイル名を入力してください.\nファイル名 = ");
  scanf("%s",graph_Name);
  fpin = func_InputFile(graph_Name);
   
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
  
  /*------------------------------------------
    全経路の算出
   ------------------------------------------*/
  root = func_makeAllOfRoute_List(city);
  
  /*----------------------------------------
    全経路から最小コスト経路の算出
    -----------------------------------------*/
  minimum = func_getMinimumFromList(root);

  /*-----------------------------------------
    コンソール出力
  ------------------------------------------*/
  printf("最小コスト経路=\n");
  func_printList(minimum);
  printf("\n");
  printf("コスト = %d\n",minimum->route.cost);
  
  
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

NODE *func_makeAllOfRoute_List(CITY city){
  int i,j;
  int *unusedNode;
  ROUTE route;
  NODE *root;
  root = NULL;
  route.root = NULL;
  route.cost = 0;
  unusedNode = (int *)malloc(sizeof(int)*city.numCity);
  for(i=0;i<city.numCity;i++)
    unusedNode[i] = 1;
  func_makeARoute(route,city,unusedNode,root);
  

  return root;
}

ROUTE func_makeARoute(ROUTE route,CITY city,int unusedNode[],NODE *root){
  int i,j;
  int sum;
  for(i=0;i<city.numCity;i++)
    sum += unusedNode[i];
  if(sum)
    return route;
  
  for(i=0;i<city.numCity;i++){
    unusedNode[i] = 0;
    route.root = func_addValueToList(i,route.root);
    func_makeARoute(route,city,unusedNode,root);
  }
}
  


NODE *func_getMinimumFromList(struct NODE *root){
  
  NODE *min_node;
  int val = root->route.cost;
  
  while(root->next != NULL){
    root = root -> next;
    if(root->route.cost < val){
      val = root->route.cost; 
      min_node = root;
    }
  }
  return min_node;
}

struct NODE * func_addRouteToList(ROUTE route,struct NODE *root){
  struct NODE *node = (struct NODE *)malloc(sizeof(struct NODE));
  node->route = route;
  node->next = NULL;
  if(root == NULL){
    return node;
  }
  else{
    struct NODE *temp = root;
    while(temp->next != NULL)
      temp = temp->next;
    temp -> next = node;
    return root;
  }
}

NODE * func_addValueToList(int val,struct NODE *root){
  struct NODE *node = (struct NODE *)malloc(sizeof(struct NODE));
  node->value = val;
  node->next = NULL;
  if(root == NULL){
    return node;
  }
  else{
    struct NODE *temp = root;
    while(temp->next != NULL)
      temp = temp->next;
    temp -> next = node;
    return root;
  }
}
