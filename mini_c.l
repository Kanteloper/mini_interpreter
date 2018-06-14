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
	int input_flag = 0;
	char* token;

	extern symNode* symTab[MAX_SYM];
	extern int idx;
	extern int input_flag;
%}

under_score [_]+
digit_first [0-9]+[a-zA-Z|0-9|_]+
id [a-zA-Z_][a-zA-Z0-9_]*
int [0-9]+
double ([0-9]*\.?[0-9]+)([eE][-+]?[0-9]+)?

%%

"if"		{ input_flag = 1; return IF; }
"then"		{ input_flag = 1; return THEN; }
"else"		{ input_flag = 1; return ELSE; }
"end"		{ input_flag = 1; return END; }
"while"		{ input_flag = 1; return WHILE; }
"def"		{ input_flag = 1; return DEF; }
"local"		{ input_flag = 1; return LOCAL; }
"print"		{ input_flag = 1; return PRINT; }

"="			{ input_flag = 1; return *yytext; }							/* assign */
">"			{ input_flag = 1; return *yytext; }							/* relop > */
"<"			{ input_flag = 1; return *yytext; }							/* relop < */
"<="		{ input_flag = 1; return LQ; }								/* relop <= */
">="		{ input_flag = 1; return GQ; }								/* relop >= */
"=="		{ input_flag = 1; return EQ; }								/* eqlop == */
"!="		{ input_flag = 1; return NQ; }								/* eqlop != */
"+"			{ input_flag = 1; return *yytext; }							/* plus */
"-"			{ input_flag = 1; return *yytext; }							/* minus */
"*"			{ input_flag = 1; return *yytext; }							/* multi */
"/"			{ input_flag = 1; return *yytext; }							/* div */
"("			{ input_flag = 1; return *yytext; }							/* right parenthesis */
")"			{ input_flag = 1; return *yytext; }							/* left parenthesis */
"\n"		{  /* enter */ 
				if(input_flag == 0) 
				{
					printf("-? ");
				}
				else
					printf("> ");
				
			}	

{int}		{	 /* integer */
				input_flag = 1;
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
{double}	{  /* double */
				input_flag = 1;

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

{id}		{
				input_flag = 1;
				symTab[idx] = (symNode*)malloc(sizeof(symNode));					
				if(strlen(yytext) > 16) // over 16 characters
				{
					if(!beDuplicated(symTab, yytext)) // not duplicated
					{
						symTab[idx]->sym = (char*)malloc(sizeof(char) * 17);
						strncpy(symTab[idx]->sym, yytext, var_len);
						yylval.idx = idx;
						idx++;
					}
					else // duplicated 
					{
						// search	
						yylval.idx = searchSym(symTab, yytext);
					}
				}
				else
				{	
					if(!beDuplicated(symTab, yytext)) // not duplicated
					{
						
						symTab[idx]->sym = malloc(sizeof(char) * (strlen(yytext) + 1));
						strncpy(symTab[idx]->sym, yytext, strlen(yytext));
						yylval.idx = idx;
						idx++;
					}
					else // duplicated 
					{
						// search
						yylval.idx = searchSym(symTab, yytext);
					}
				}
				return VAR; 
			}
[ \t]			;													/* ignore whitespace */
[;]			{ input_flag = 1; return *yytext; }
.		   	    yyerror("lexical error : Unknown character"); 		/* lexical error */ 
%%
