digit[0-9]
letter[a-zA-z_]
variable[a-zA-z0-9_] 
%{

     #include <string.h>
    #include <stdlib.h>
    #include <stdio.h>
    #include "StructFile.h"
    #include "y.tab.h"
    #include <string.h>
    void yyerror(char *);
%}

%%  
"exit" 	    {return EXIT;}
"int"	    {return INT; }
"const"     {return CONST;}
"float"     {return FLOAT;}
"char"      {return CHAR;}
"boolean"   {return BOOLEAN;}
"double"    {return DOUBLE;}
"string" 	{return STRING;}
"false" 	{return FALSE;}
"true" 	    {return TRUE;}
"+"         {return PLUS;}
"-"         {return MINUS;}
"*"         {return MULTIPLICATION;}
"/"         {return DIVISION;}
"="         {return EQUAL;}
";"         {return SC;}
" "         {return SPACE;}
{digit}+    {
                yylval.intValue = atoi(yytext);
                return INTEGER;
            }
{digit}*\.?{digit}+ {
                yylval.floatValue = atof(yytext); return FLT;
                }
\"[\x20-\x7E]*\" {
				yylval.stringValue = strdup(strdup(yytext)); return STR;
				}
\'[\x20-\x7E]?\' {
				yylval.charValue = yytext[1]; 
				return CHR;
				}				

{letter}{variable}*   {
                yylval.identifier = strdup(yytext);
                return IDENTIFIER;
                }
				

[-+()=/*\n]     {  return *yytext; }

[ \t\r\v\f]+   ;       /* skip whitespace */

.              yyerror("Unknown character");

%%

int yywrap(void) {
    return 1;
}