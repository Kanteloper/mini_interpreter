%{
	#include <stdio.h>
	#define debug(s)	printf(#s)
	int yyerror(char* msg);
	int yylex();
%}

%token NUMBER VAR
%token EQ NQ
%token LQ GQ 
%token IF THEN ELSE END WHILE DEF LOCAL PRINT

%%

stmt_list : 
		  stmt_list stmt					{ puts("stmt_list <== stmt"); }
		  | stmt			
		  ;



stmt : 
	 selec_stmt								{ puts("stmt <== selec" ); }
	 | iter_stmt							{ puts("stmt <== iter" ); }
	 | print_stmt							{ puts("stmt <== print" ); }
	 | expr_stmt							{ puts("stmt <== expr" ); }
	 ;



selec_stmt :
		   IF '('  ')' ELSE END				{ puts("selec <== IF" ); }
		   ;



iter_stmt : 
		  WHILE '(' ')' END					{ puts("iter <== WHILE" ); }
		  ;



print_stmt : 
		   PRINT ';'						{ puts("print <== PRINT" ); }
		   ;



expr_stmt : 
		  assign_expr						{ puts("expr <== assign" ); }
		  ;



assign_expr : 
			VAR '=' equal_expr					{ puts("assign <== var = rel"); }
			| equal_expr		 				{ puts("assign <== rel"); }
			;



equal_expr : 
		   equal_expr EQ rel_expr				{ debug(EQ!!); }
		   | equal_expr NQ rel_expr				{ debug(NQ!!); }
		   | rel_expr							{ debug(NO EQ); }
		   ;



rel_expr : 
		 rel_expr '>' addsub_expr				{ debug(GT!!); }
		 rel_expr '<' addsub_expr				{ debug(LT!!); }
		 rel_expr GQ addsub_expr				{ debug(GQ!!); }
		 rel_expr LQ addsub_expr				{ debug(LQ!!); }
		 | addsub_expr							{ debug(NO RELOP); }
		 ;



addsub_expr :
			addsub_expr '+' muldiv_expr			{ debug(PLUS!!); }
			|addsub_expr '-' muldiv_expr		{ debug(MINUS!!); }
			| muldiv_expr						{ debug(NO ADD SUB); }
			;



muldiv_expr :
			muldiv_expr '*' cast				{ debug(MULT!!); }
			| muldiv_expr '/' cast				{ debug(DIV!!); }
			| cast								{ debug(NO MULT DIV); }
			;



cast :
	 unary_expr									{ puts("cast <== unary"); }
	 | primary									{ debug(NO UNARY); }
	 ;




unary_op : 
		 '-'									
		 ;



unary_expr :
		   unary_op cast						{ puts("unary <== unary_op cast"); }
		   ;

primary :
		VAR
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
