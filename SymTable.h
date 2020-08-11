   	#include <stdio.h>
	#include "StructFile.h"
    #include <stdlib.h>
     #include <string.h>
    #include <stdbool.h>
    #include <math.h>

/*---------------------------------------------STRUCTS AND UNINONS NEEDED---------------------------------------------*/
#define SIZE 106

struct symbol_info{
    char *name;
    int classtype;
    // bool isFinal;
    bool isInitialized;
    struct symbol_info *next;
} *table[SIZE];

/*---------------------------------------------SYMBOL TABLE FUNCTIONS PROTOYPES---------------------------------------------*/
int hash_function(char* name);
bool Insert_In_Table(struct symbol_info *newNode );
struct symbol_info* Search_and_return(char* name, int *error);
void Set_isInitialized(char* name);
void Print_SymTable();

/*--------------------------------------------------SYMBOL TABLE FUNCTIONS --------------------------------------------------*/

int hash_function(char* value){
    int index = 0;
    for(int i = 0; value[i]; ++i) {index = index + value[i];}
    int return_value = index  % SIZE;
    return return_value;
}

bool Insert_In_Table(struct symbol_info *newNode ){
    char* name = newNode->name;
    int position = hash_function(name);
    int ret=0;
    struct symbol_info* temp = table[position];
    while( temp != NULL )
    {
        if( !strcmp( (*temp).name, name ) )  {ret=1;}
        temp = temp->next;
    }
    if(ret==1)
    {   printf(" Error: already declared"); 
        return false;
    }
    newNode->isInitialized = false;
    if( table[position] == NULL ){
        table[position] = newNode;
        table[position]->next = NULL;
    }
    else{
        struct symbol_info* nextNode = table[position];
        table[position] = newNode;
        newNode->next = nextNode;
    }
    return true;
}

struct symbol_info* Search_and_return(char* name, int *error){
    int position = hash_function(name);

    struct symbol_info* temp= table[position];

        while( temp != NULL ){
            if( !strcmp( temp->name, name ) ) {
                *error = 0;
                return temp;
            }
            temp = temp->next;
        }

    fprintf(yyout,"Error -> Identifier not found"); 
    *error=404;
    return temp;
}

void Set_isInitialized(char* name)
{
  int position = hash_function(name);
  struct symbol_info* temp = table[position];
  while( temp != NULL ){
      if( !strcmp( (*temp).name, name ) ) {
          (*temp).isInitialized = true;
          return;
      }
      temp = temp->next;
  } return ;
}

void Print_SymTable(int test_case_file){
    FILE *sym_file;
    if(test_case_file==1)
    {
        sym_file = fopen("sym_file1.txt", "w");
    }else if(test_case_file==2){
        sym_file = fopen("sym_file2.txt", "w");
    }else if(test_case_file==3){
        sym_file = fopen("sym_file3.txt", "w");
    }
    if(sym_file==NULL)
		printf( "Error file not found!");
	else
	{
        fprintf(sym_file,"showing symbol table \n");
        int no_of_identifiers =0;
        for(int i = 0; i < SIZE; ++i){
            struct symbol_info* temp = table[i];
            while( temp != NULL ){
            fprintf(sym_file,"[ %d - Name  %s| Class %d | init %d ] \n", no_of_identifiers, (*temp).name, (*temp).classtype,(*temp).isInitialized);
                temp = (*temp).next;
                no_of_identifiers++;
            }
        }
    }
}
