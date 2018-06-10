%{
	#include <stdio.h>
	int yyerror(char* msg);
	int yylex();
%}

%token NUMBER ENTER
%left '-' '+'
%left '*' '/'
%nonassoc UMINUS

%%

line : stmt ';' 			{ printf("%d\n", $1); YYACCEPT; }
	 |
	 ;

stmt : expr  			 
	 | stmt expr            { $$ = $2; }
	 ;

expr : expr '+' expr		{ $$ = $1 + $3; } 
	 | expr '-' expr		{ $$ = $1 - $3; }
	 | expr '*' expr		{ $$ = $1 * $3; }
	 | expr '/' expr		
		{ 
			if($3 == 0)
			{
				yyerror("syntax error : divide by zero");
			}
			else
				$$ = $1 / $3; 
		}
	 | '-' expr %prec UMINUS	{ $$ = -$2; }
	 | '(' expr ')'				{ $$ = $2; }
	 | NUMBER
	 | ENTER					{ }
	 ;

%%

int yyerror(char* msg)
{
	fprintf(stderr, "%s\n", msg);
	return 0;
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
