%{
	#include "y.tab.h"
	#include "stack.h"
	#include "treeNode.h"

	#include <string.h>
	#include <stdio.h>
	#include <stdlib.h>

	void yyerror(char* );
	size_t num_len = 10;
	size_t var_len = 16;
	char* token;

	extern symNode* symTab[MAX_SYM];
	extern int idx;
%}

under_score [_]+
digit_first [0-9]+[a-zA-Z|0-9|_]+
id [a-zA-Z_][a-zA-Z0-9_]*
int [0-9]+
double ([0-9]*\.?[0-9]+)([eE][-+]?[0-9]+)?

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
"("			{ return *yytext; }							/* right parenthesis */
")"			{ return *yytext; }							/* left parenthesis */


{int}			{	/* integer */
					if(strlen(yytext) > 10) // only 10 size
					{
						token = (char*)malloc(sizeof(char) * 11);
						strncpy(token, &yytext[yyleng - num_len], num_len);
						yylval.val = atol(token);
						free(token);
					}
					else 
					{
						yylval.val = atoi(yytext); 
					}
					return INTEGER; 
				
				}	
{double}		{ /* double */
					if(strlen(yytext) > 10)
					{
						token = (char*)malloc(sizeof(char) * 11);
						strncpy(token, &yytext[yyleng - num_len], num_len);
						yylval.dval = atof(token);
						free(token);
					}
					else
					{
						yylval.dval = atof(yytext); 
					}
					return DOUBLE;
				}  
{digit_first}	yyerror("lexical error : Unknown character");  	
{under_score}	yyerror("lexical error : Unknown character");  
{id}			{
					symTab[idx] = (symNode*)malloc(sizeof(symNode));					
					if(strlen(yytext) > 16) // over 16 characters
					{
						symTab[idx]->sym = (char*)malloc(sizeof(char) * 17);
						strncpy(symTab[idx]->sym, yytext, var_len);
					}
					else
					{
						beDuplicated(symTab, yytext);
						symTab[idx]->sym = malloc(sizeof(char) * (strlen(yytext) + 1));
						strncpy(symTab[idx]->sym, yytext, strlen(yytext));
						printf("idx %d, save: %s\n", idx,  symTab[idx]->sym);
					}
					yylval.idx = idx;
					idx++;
					return VAR; 
				}
[ \t]			;													/* ignore whitespace */
[;\n]			{ return *yytext; }
.		   	    yyerror("lexical error : Unknown character"); 		/* lexical error */ 
%%
