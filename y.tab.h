
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     INTEGER = 258,
     FLT = 259,
     STR = 260,
     FALSE = 261,
     TRUE = 262,
     CHR = 263,
     IDENTIFIER = 264,
     CHAR = 265,
     FLOAT = 266,
     BOOLEAN = 267,
     DOUBLE = 268,
     INT = 269,
     STRING = 270,
     PLUS = 271,
     MINUS = 272,
     DIVISION = 273,
     MULTIPLICATION = 274,
     SC = 275,
     EQUAL = 276,
     SPACE = 277,
     CONST = 278,
     EXIT = 279
   };
#endif
/* Tokens.  */
#define INTEGER 258
#define FLT 259
#define STR 260
#define FALSE 261
#define TRUE 262
#define CHR 263
#define IDENTIFIER 264
#define CHAR 265
#define FLOAT 266
#define BOOLEAN 267
#define DOUBLE 268
#define INT 269
#define STRING 270
#define PLUS 271
#define MINUS 272
#define DIVISION 273
#define MULTIPLICATION 274
#define SC 275
#define EQUAL 276
#define SPACE 277
#define CONST 278
#define EXIT 279




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 31 "parser.y"
     
	int   intValue;	    	/* integer value */
	float floatValue;    	/* float value */
	char  charValue;    	/* char value */
	char* stringValue;  	/* string value*/
	char* identifier;       /* identifier name */
	char* DataType;
	nodeType* nPtr;



/* Line 1676 of yacc.c  */
#line 112 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


