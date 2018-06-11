%{
	#include <stdio.h>
	int yyerror(char* msg);
	int yylex();
	int op;
%}

%token NUMBER 
%left '-' '+'
%left '*' '/'
%nonassoc UMINUS

%%

line : stmt ';' 		 		{ printf("%d\n", $1); op = 0; YYACCEPT; }
	 | '\n'							{ printf("-? "); YYACCEPT; }
	 |
	 ; 							

stmt : stmt expr '\n'		
		{
			switch(op)
			{
				case '+' : 
					$$ = $1 + $2; printf("> ");
					op = 0;
					break;

				default :
					if( $2 != 0)
					{
						$$ = $1 + $2; printf("> ");
					}
					else
					{
						$$ = $1; printf("> ");
					}
					break;
			}
		}
	 | stmt expr ';'  
		{ 
			switch(op)
			{
				case '+' : 
					$$ = $1 + $2; printf("%d\n", $$); YYACCEPT;
					op = 0;
					break;

				default :
					$$ = $1 + $2; printf("%d\n", $$); YYACCEPT;
					break;
			}
		}
	 | stmt '+' '\n'		{ op = '+'; printf("> "); }
	 | stmt '+' expr '\n'   { $$ = $1 + $3; printf("> "); }
	 | stmt '+' expr ';'	{ $$ = $1 + $3; printf("%d\n", $$); YYACCEPT; }
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
	 |							{ $$ = 0;}
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
