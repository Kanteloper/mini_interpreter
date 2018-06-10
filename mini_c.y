%{
	#include <stdio.h>
	int yyerror(char* msg);
	int yylex();
%}

%token NUMBER ENTER

%%

line : stmt					{ printf("%d\n", $1); YYACCEPT; }
	 |
	 ;

stmt : expr 			 
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
	 | '-' expr				{ $$ = -$2; }
	 | '(' expr ')'			{ $$ = $2; }
	 | NUMBER
	 | ENTER				{ YYACCEPT; }
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
	while(!feof(stdin)) {
		printf("-?");
		yyparse();
	}
	return 0;
}
