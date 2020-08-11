%{
	#define _GNU_SOURCE
	#include <stdarg.h>
	#include "SymTable.h"
    #include <stdlib.h>
    #include <stdio.h>
	#include <stdbool.h>
	
    int yylex(void);
	void yyerror(char* s);
	int yyparse(void);
	void freeNode(nodeType *p);
	int ex(nodeType *p);
	
	void necessaryInitializations (nodeType *p);

	//-----------------------------PROTOTYPES
	nodeType *opr(int oper, int nops, ...);
	nodeType *id( int flag, char name[], int per);
	nodeType *get_id(char name[]);
	nodeType *con(char* s, int flag);

	//-----------------------------GLOBAL VARIABLES
	int leftType=-10; /* 0-->int, 1-->float, 2-->char, 3-->string, 4-->boolean */
	int rightType=-10; /* 0-->int/float, 2-->char, 3-->string , 4-->boolean*/
	int counter = -1;
	int last_value = 0;
	int access;
	int test_case_file;
%}
%union {     
	int   intValue;	    	/* integer value */
	float floatValue;    	/* float value */
	char  charValue;    	/* char value */
	char* stringValue;  	/* string value*/
	char* identifier;       /* identifier name */
	char* DataType;
	nodeType* nPtr;
}; 

%token <intValue> INTEGER
%token <floatValue> FLT
%token <stringValue> STR FALSE TRUE
%token <charValue> CHR
%token <identifier> IDENTIFIER
%token <DataType> CHAR FLOAT BOOLEAN DOUBLE INT STRING

%token PLUS
%token MINUS
%token DIVISION
%token MULTIPLICATION
%token SC
%token EQUAL
%token SPACE
%token CONST
%token EXIT

%type <nPtr> statement expr bool_expr
%type <DataType> datatype
%%

program:
        program statement '\n'  { fprintf(yyout," "); int error = ex($2);freeNode($2);Print_SymTable(test_case_file); }
        | /* NULL */
        ;
statement:
        expr
		| EXIT								   {exit(0);}                          
        | IDENTIFIER EQUAL expr SC             { $$ = opr(EQUAL, 2, get_id($1), $3); }
        | IDENTIFIER EQUAL IDENTIFIER  SC      { $$ = opr(EQUAL, 2, get_id($1), get_id($3));}
        | datatype SPACE IDENTIFIER EQUAL expr SC   
							   { if ($1 == "int")     $$ = opr(EQUAL, 2, id(0, $3, 0), $5);
							else if ($1 == "float")   $$ = opr(EQUAL, 2, id(1, $3, 0), $5);
							else if ($1 == "char")    $$ = opr(EQUAL, 2, id(2, $3, 0), $5);
							else if ($1 == "string")  $$ = opr(EQUAL, 2, id(3, $3, 0), $5);
							else if ($1 == "boolean") $$ = opr(EQUAL, 2, id(4, $3, 0), $5);}

        | datatype SPACE IDENTIFIER SC              { 
                                                             if ($1 == "int" ) 		$$ = id(0, $3, -4);
														else if($1 == "float") 		$$ = id(1, $3, -4);
														else if($1 == "char" ) 		$$ = id(2, $3, -4);
														else if($1 == "string") 	$$ = id(3, $3, -4);
														else if($1 == "boolean") 	$$ = id(4, $3, -4);
													};
expr:
		  INTEGER 						{ char c[] = {}; itoa($1, c, 10);  $$ = con(c,0);}
        | FLT    						{ char c[] = {}; gcvt($1, 10, c);   $$ = con(c,1);}
		| CHR   						{ char *pChar = malloc(sizeof($1));  stpcpy(pChar,&$1);  $$ = con(pChar,2);}
		| STR   						{ $$ = con($1,3);}
		| IDENTIFIER 					{ $$= get_id($1);}
		| bool_expr 					{ $$ = $1 ;}
        | MINUS expr 					{ $$ = opr(MINUS, 1, $2);}
        | expr DIVISION expr            { $$ = opr(DIVISION, 2, $1, $3); }
		| expr PLUS expr                { $$ = opr(PLUS, 2, $1, $3);}
        | expr MINUS expr               { $$ = opr(MINUS, 2, $1, $3); }
		| expr MULTIPLICATION expr      { $$ = opr(MULTIPLICATION, 2, $1, $3); }
		;

bool_expr:   
			  TRUE  {  $$ = con("true",4);}
			| FALSE {  $$ = con("false",4);}
	        ;

datatype: 		
			  INT     {$$ = "int";}
			| FLOAT   {$$ = "float";}
			| STRING  {$$ = "string";}
			| CHAR    {$$ = "char"; }
			| BOOLEAN {$$ = "boolean";}
		    ;


%%

nodeType *con(char* s, int flag) {
	nodeType *p;

	/* allocate node */
	if ((p = malloc(sizeof(nodeType))) == NULL)
		yyerror("out of memory");

	/* copy information */
	p->type = typeCon;
	p->con.value = strdup(s);
	p->con.flag = flag;
	return p;
}

nodeType *opr(int oper, int nops, ...) {
	va_list ap;
	nodeType *p;
	int i;
	/* allocate node, extending op array */
	if ((p = malloc(sizeof(nodeType) + (nops-1) * sizeof(nodeType *))) == NULL)
		yyerror("out of memory");
	/* copy information */
	p->type = typeOpr;
	p->opr.oper = oper;
	p->opr.nops = nops;
	va_start(ap, nops);
	for (i = 0; i < nops; i++)
		p->opr.op[i] = va_arg(ap, nodeType*);

	va_end(ap);
	return p;
}

void freeNode(nodeType *p) {
	int i;
	if (!p)
		return;

	if (p->type == typeOpr) {
		for (i = 0; i < p->opr.nops; i++)
			freeNode(p->opr.op[i]);
	}
	free (p);
}
void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(){
	
	
	yyin = fopen("testcase3.txt", "r");
	yyout = fopen("output_file3.txt", "w");
	test_case_file=3;
	if(yyin==NULL)
		 fprintf(yyout, "Error file not found!");
	else
	{
		
		printf("opened,content of file:%c\n",*yyin);
		yyparse();
		fclose(yyin);
	}
			
		return 0;
}

nodeType *id( int flag, char name[], int per) {
	struct symbol_info *STEntry = malloc(sizeof(struct symbol_info));
	(*STEntry).name = name;
	(*STEntry).classtype = flag;

    nodeType *p;        
	/* allocate node */
	if ((p = malloc(sizeof(nodeType))) == NULL)
		yyerror("their is no space");

	if( Insert_In_Table(STEntry) )
	{
		p->type = typeId;
		p->id.name = strdup(name);
		p->id.access = per;
		p->id.flag = flag;
		return p;
	}
	p->id.name = strdup(name);
	p->type = typeId;
	p->id.access = -3;
	return p;
}

nodeType *get_id(char name[]) {
	nodeType *p;
        /* allocate node */
	if ((p = malloc(sizeof(nodeType))) == NULL)
		yyerror("their is no space");	

	int *error;
	struct symbol_info *STEntry = Search_and_return(name,error);
	p->type = typeId;
	p->id.name = strdup(name);
	if(*error == 404){
		p->id.access = -1;
		return p;
	}
	p->id.flag = STEntry->classtype;
	p->id.name = strdup(name);

	p->type = typeId;

	return p;
}
void necessaryInitializations (nodeType *p){
	if (p->opr.oper ==271 || p->opr.oper ==276 || p->opr.oper >= 281 && p->opr.oper <= 309 || p->opr.oper == 312 || p->opr.oper == 314 || p->opr.oper == 272)
		{
			p->type = 2;
		}
}
int ex(nodeType *p) {
	int i,j,value1,value2;
    if (!p) 
		return 0;
	 necessaryInitializations (p);
    switch(p->type) 
	{
		case typeCon: 
		printf("Typecon:  \n\n");
			/* 0-->int, 1-->float, 2-->char, 3-->string */
			//p->con.flag ==> constant node being sent to ex();
			if (leftType == 0  && (p->con.flag == 1 || p->con.flag == 2 || p->con.flag == 3 || p->con.flag == 4) ) {
				fprintf(yyout,"Error: type clash assigning wrong class to int \n");
				return -1;
			}
			else if (leftType == 1  && (p->con.flag == 0 || p->con.flag == 2 || p->con.flag == 3 || p->con.flag == 4) ) {
				fprintf(yyout, "Error: type clash assigning wrong class to float \n");
				return -1;
			}
			else if (leftType == 2  && (p->con.flag == 0 || p->con.flag == 1 || p->con.flag == 3 || p->con.flag == 4) ) {
				fprintf(yyout, "Error: type clash assigning wrong class to char \n");
				return -1;
			}
			else if (leftType == 3  && (p->con.flag == 0 || p->con.flag == 1 || p->con.flag == 2 || p->con.flag == 4) ) {
				fprintf(yyout, "Error: type clash assigning wrong class to String \n");
				return -1;
			}
			else if (leftType == 4  && (p->con.flag == 0 || p->con.flag == 1 || p->con.flag == 2 || p->con.flag == 3) ) {
				fprintf(yyout, "Error: type clash assigning wrong class to String \n");
				return -1;
			}
			else
			{
				if (p->con.flag == 2 )
				{
					fprintf(yyout,  "\t MOV R%d, %c \n", last_value, p->con.value[0]);
				}
				else if (p->con.flag == 3 )
				{
					int len=strlen(strdup(p->con.value));
					char * s2[len-2];
					strncpy(s2,strdup(p->con.value)+1,len-2);
					p->con.value=s2;
					fprintf(yyout,  "\t MOV R%d, %s \n", last_value, p->con.value);
				}
				else
				{
					fprintf(yyout,  "\t MOV R%d, %s \n", last_value, p->con.value);
				}
				counter++;
				last_value++;
				rightType = p->con.flag;	
			}	
			break;  
    	/*------------------------------------------------------------------------------------------------------------------------------*/
		case typeId: 
		printf( "typeId:  \n\n");
			if (p->id.access == -1) {
				fprintf(yyout, "Error: %s is not declared \n", p->id.name);
				return -1;
			}
			if (p->id.access == -3) {
				fprintf(yyout,"Error: %s is already declared \n", p->id.name);
				return -1;
			}
			if (p->id.access == -4) {
				p->id.access =0;
				fprintf(yyout,"\t ST  %s , %s  \n\n", p->id.name,"NULL");
				break;	
			}
			else if (p->id.access == 0)  
			{
				if (p->id.name != NULL)
				{

					if (leftType == 0  && (p->id.flag == 1 || p->id.flag == 2 || p->id.flag == 3 || p->id.flag == 4) ) {
						fprintf(yyout,"Warning: assigning wrong class to int \n");
						return -1;
					}
					else if (leftType == 1  && (p->id.flag == 0 || p->id.flag == 2 || p->id.flag == 3 || p->id.flag == 4) ) {
						fprintf(yyout, "Warning: assigning wrong class to float \n");
						return -1;
					}
					else if (leftType == 2  && (p->id.flag == 0 || p->id.flag == 1 || p->id.flag == 3 || p->id.flag == 4) ) {
						fprintf(yyout, "Warning: assigning wrong class to char \n");
						return -1;
					}
					else if (leftType == 3  && (p->id.flag == 0 || p->id.flag == 1 || p->id.flag == 2 || p->id.flag == 4) ) {
						fprintf(yyout, "Warning: assigning wrong class to String \n");
						return -1;
					}
					else if (leftType == 4  && (p->id.flag == 0 || p->id.flag == 1 || p->id.flag == 2 || p->id.flag == 3) ) {
						fprintf(yyout, "Warning: assigning wrong class to Boolean \n");
						return -1;
					}
					
					fprintf(yyout,  "\t LD R%d, %s \n", last_value, p->id.name);
					counter++;
					last_value++;
					rightType = p->id.flag;			
				}
			}
			else
			{  
				fprintf(yyout, "Error: %s is not declared \n\n", p->id.name);
				return -1;
			}
			break;
    	/*------------------------------------------------------------------------------------------------------------------------------*/
		case typeOpr:
		printf("typeOpr:  \n\n");
			switch(p->opr.oper) 
			{
				case EQUAL:
				printf("\nEQUAL\n");
				if( p->opr.op[0]->id.flag != 4 )
					leftType = p->opr.op[0]->id.flag;

				access = p->opr.op[0]->id.access;
				if (access == -1) {
					fprintf(yyout,"Error: %s is not declared \n", p->opr.op[0]->id.name);
					return -1;
				}
				else if (access == -3) {
					fprintf(yyout,"Error: %s is already declared \n", p->opr.op[0]->id.name);
					return -1;
				}

				if(ex(p->opr.op[1])==-1) return -1; 

				Set_isInitialized(p->opr.op[0]->id.name);  
				p->opr.op[0]->id.access =0;        
				
				if( p->opr.op[0]->id.flag == 4 )
					leftType = p->opr.op[0]->id.flag;

				if (rightType != leftType)
				{
					fprintf(yyout,"Error : right operand type != left operand type \n\n");
					return -1;

				}

				fprintf(yyout, "\t ST   %s , R%d \n\n", p->opr.op[0]->id.name,last_value - 1);

				leftType = -10;
				rightType = -10;
				break;


				default:
				printf( "#3 in Equal case default: \n\n");
					if( ex(p->opr.op[0])==-1 ) return -1;

					i = counter; 
					value1 = rightType;

					if (p->opr.nops == 2 && p->opr.op[1] != NULL) {
						if(ex(p->opr.op[1])==-1) return -1;
						value2 = rightType;
					}
					j = counter;

					switch(p->opr.oper)
					{
						case PLUS:
						printf("PLUS:  v1: %d   v2: %d \n\n",value1,value2);
							if ((value1 == 0 && value2 == 0 ) || (value1 == 1 && value2 == 1 ) || (value1 == 3 && value2 == 3 ) )
							{
								 fprintf(yyout,  "\t ADD R%d, R%d\n", j, i);
							}
							break;
						case MINUS: 
						printf("MINUS: \n\n");
							if ((value1 == 0 && value2 == 0 ) || (value1 == 1 && value2 == 1 ))
							{
								 fprintf(yyout,  "\t SUB R%d, R%d \n", i, j);
							} 		 
							break; 
						case MULTIPLICATION: 
						printf("MULTIPLICATION: \n\n");  
							if ((value1 == 0 && value2 == 0 ) || (value1 == 1 && value2 == 1 ))
							{
								 fprintf(yyout,  "\t MUL R%d, R%d\n", i, j);
							}
							break;
						case DIVISION: 
						printf("DIVISION: \n\n");         
							if ((value1 == 0 && value2 == 0 ) || (value1 == 1 && value2 == 1 ))
							{
								 fprintf(yyout,  "\t DIV R%d, R%d \n", i, j);
							}
							break;
						default:
							fprintf(yyout,"Error: incompatible operands \n");
							return -1;
					}
			}
    }
    return 0;
}
