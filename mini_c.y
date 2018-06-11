%{
	#include <stdio.h>
	int yyerror(char* msg);
	int yylex();
%}

%token NUMBER 
%left '-' '+'
%left '*' '/'
%nonassoc UMINUS

%%

line : stmt ';' '\n'		 		{ printf("%d\n", $1); YYACCEPT; }
	 | line stmt					{ $$ = $2; printf(">"); }
	 | stmt
	 | '\n'							{ printf("-?"); YYACCEPT; }
	 ; 							

stmt : stmt expr '\n' 			{ $$ = $2; printf(">"); } 
	 | expr
	 ;

expr : expr '+' expr		{ $$ = $1 + $3; } 
	 | expr '-' expr		{ $$ = $1 - $3; }
	 | expr '*' expr		{ $$ = $1 * $3; }
	 | expr '/' expr		
		{ 
			if($3 == 0)
			{
				yyerror("syntax error : divide by zero");
				YYACCEPT;
			}
			else
				$$ = $1 / $3; 
		}
	 | '-' expr %prec UMINUS	{ $$ = -$2; }
	 | '(' expr ')'				{ $$ = $2; }
	 | NUMBER
	 |
	 ;

%%

int yyerror(char* msg)
{
	fprintf(stderr, "%s\n", msg);
	return -1;
}

int main() {

	// feof(any stream) : tests the end-of-file indicator for the stream
	//			pointed to by stream, returning nonzero if it is set.
	printf("-?");
	while(!feof(stdin)) {
		yyparse();
	}
	return 0;
}
