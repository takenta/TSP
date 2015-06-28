#include<stdio.h>
#include<stdio.h>

#define RANDOW_SEED 3


typedef struct NODE{
  NODE route;
  struct NODE *next;
}NODE;

typedef struct Route{
  int cost;
  NODE *root;
}

int **func_makeDistanceMatrix(int);
/*リスト系関数*/
NODE *func_makeAllOfRoute_List();
NODE *func_getMinimumFromList(NODE *);
NODE *func_addValueToList(int,NODE*);
void func_printList(NODE *);
void func_freeList(NODE *);

/*配列系関数*/
int **func_makeAllOfRoute_Array();
int func_getMinimumFromArray();
int func_getSizeOfArray();

int main(void){
  srand48(RANDOW_SEED);
  int num_City;
  
  printf("都市数を入力してください.\n都市数 = ");
  scanf("%d",&num_City);

  /*都市距離行列の生成*/
  func_makeDistanceMatrix(num_City);

  /**/
  
  return 0;
}


