%{
	#include "token.h"
	#include <stdlib.h>
	extern int yylval;
%}

/* regular definitions */

delim [ \t\n\v\f]
ws {delim}
under_score [_]+
digit_first [0-9]+[a-zA-Z|0-9|_]+ 
id [a-zA-Z_][a-zA-Z0-9_]*
int [0-9]+
double ([0-9]*\.?[0-9]+)([eE][-+]?[0-9]+)?
other .

%%
{int} { yylval = atoi(yytext); return INT; }
{double} { yylval = atoi(yytext); return DOUBLE; }
{digit_first} { return ERROR; } 
{under_score} { return ERROR; }
{id} { return ID; }
\= { yylval = ASSIGN; return ASSIGN; }
\== { yylval = EQ; return RELOP; }
\!= { yylval = NE; return RELOP; }
\< { yylval = LT; return RELOP; } 
\> { yylval = GT; return RELOP; }
\<= { yylval = LE; return RELOP; }
\>= { yylval = GE; return RELOP; }
\( { return LPAREN; }
\) { return RPAREN; }
\+ { yylval = PLUS; return ARTHOP; }
\- { yylval = MINUS; return ARTHOP; }
\* { yylval = MULT; return ARTHOP; }
\/ { yylval = DIV; return ARTHOP; }
{ws} {/* no action and no return */}
{other} { return ERROR; }
%%
