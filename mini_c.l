%{
	#include "y.tab.h"
	extern int yylval;
%}

%%

[0-9]+		{ yylval = atoi(yytext); return NUMBER; }	/* integers */
[ \t]		;									/* ignore whitespace */
\n |										/* logical EOF */	
.			return yytext[0];
%%
