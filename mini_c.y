%{
	#include <stdio.h>
	int yyerror(char* msg);
	int yylex();
%}

%token NUMBER 

%%
stmt : expr'\n'					{ printf("%d\n", $1); }
	 ;

expr : expr '+' NUMBER		{ $$ = $1 + $3; } 
	 | expr '-' NUMBER		{ $$ = $1 + $3; }
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
	//while(!feof(stdin)) {
	//	printf(">");
		yyparse();
	//}
	return 0;
}
