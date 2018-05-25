%{
	#include "token.h"
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
{int} { return INT;}
{double} { return DOUBLE; }
{digit_first} { return ERROR; } 
{under_score} { return ERROR; }
{id} { return ID; }
\= { return ASSIGN; }
\== { return RELOP; }
\!= { return RELOP; }
\< { return RELOP; } 
\> { return RELOP; }
\<= { return RELOP; }
\>= { return RELOP; }
\( { return LPAREN; }
\) { return RPAREN; }
\+ { return PLUS; }
\- { return MINUS; }
\* { return MULT; }
\/ { return DIV; }
{ws} {/* no action and no return */}
{other} { return ERROR; }
%%
