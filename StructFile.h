typedef enum { typeCon , typeId, typeOpr } nodeEnum;
/* constants */
typedef struct {
	int flag;    /* 0-->int, 1-->float, 2-->char, 3-->string, 4-->bool */
	char* value;
} conNodeType;

/* identifiers */
typedef struct {
	int flag;    /* 0->int, 1->float, 2->char, 3->string  4-->bool */
	int access; /* -1-> not declared,-3-> already defined ,-4-> declared not init */
    int isInit; /*1-> init  , 0-> not init*/
	char* name;
} idNodeType;

/* operators */
typedef struct {
    int oper;                   /* operator */
    int nops;                   /* number of operands */
    struct nodeTypeTag *op[1];	/* operands, extended at runtime */
} oprNodeType;

typedef struct nodeTypeTag {
    nodeEnum type;              /* type of node */

    union {
        conNodeType con;        /* constants */
        idNodeType id;          /* identifiers */   
        oprNodeType opr;        /* operators */
    };
} nodeType;

 extern FILE* yyin;
extern FILE* yyout;
