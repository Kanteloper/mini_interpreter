%{
	#include <stdio.h>
	int yyerror(char* msg);
	int yylex();
%}

%token NUMBER 

%%

line : stmt					{ printf("%d\n", $1); YYACCEPT; }
	 |
	 ;

stmt : expr 			 
	 ;

expr : expr '+' expr		{ $$ = $1 + $3; } 
	 | expr '-' expr		{ $$ = $1 + $3; }
	 | NUMBER
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
