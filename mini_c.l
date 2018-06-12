%{
	#include "y.tab.h"
	extern int yylval;
%}

under_score [_]+
digit_first [0-9]+[a-zA-Z|0-9|_]+
id [a-zA-Z_][a-zA-Z0-9_]*
int [0-9]+
float ([0-9]*\.?[0-9]+)([eE][-+]?[0-9]+)?

%%

"if"		{ return IF; }
"then"		{ return THEN; }
"else"		{ return ELSE; }
"end"		{ return END; }
"while"		{ return WHILE; }
"def"		{ return DEF; }
"local"		{ return LOCAL; }
"print"		{ return PRINT; }

"="			{ return *yytext; }							/* assign */
">"			{ return *yytext; }							/* relop > */
"<"			{ return *yytext; }							/* relop < */
"<="		{ return LQ; }								/* relop <= */
">="		{ return GQ; }								/* relop >= */
"=="		{ return EQ; }								/* eqlop == */
"!="		{ return NQ; }								/* eqlop != */
"+"			{ return *yytext; }							/* plus */
"-"			{ return *yytext; }							/* minus */
"*"			{ return *yytext; }							/* multi */
"/"			{ return *yytext; }							/* div */


{int}		{ yylval = atoi(yytext); return NUMBER; }	/* integers */
{id}		{ return VAR; }
[ \t]		;											/* ignore whitespace */
[\n]			{ return *yytext; }
.			return yytext[0];							/* pass error handling to parser*/ 
%%
