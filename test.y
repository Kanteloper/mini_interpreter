%{
	#include <stdio.h>
	#define debug(s)	printf(#s)
	int yyerror(char* msg);
	int yylex();
%}

%token NUMBER VAR
%token IF THEN ELSE END WHILE DEF LOCAL PRINT

%%

stmt : selec_stmt			{ debug(IF!!); }
	 | iter_stmt			{ debug(WHILE!!); }
	 | print_stmt			{ debug(PRINT!!); }
	 | expr_stmt			{ debug(EXPR!!); }
	 ;

selec_stmt : 
		   IF '('  ')' ELSE END
		   ;

iter_stmt : 
		  WHILE '(' ')' END
		  ;

print_stmt : 
		   PRINT ';'

expr_stmt : assign_expr 
		  ;

assign_expr : VAR '='
			;


%%

int yyerror(char* msg)
{
	fprintf(stderr, "%s\n", msg);
	return -1;
}

int main() {

	printf("-? ");
	while(!feof(stdin)) {
		yyparse();
	}
	return 0;
}
