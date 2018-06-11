%{
	#include "y.tab.h"
	extern int yylval;
%}

%%

[0-9]+		{ yylval = atoi(yytext); return NUMBER; }	/* integers */
[ \t]		;											/* ignore whitespace */
[+\n]			{ return *yytext; }
.			return yytext[0];							/* pass error handling to parser*/ 
%%
