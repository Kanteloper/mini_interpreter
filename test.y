%{
	#include <stdio.h>
	#include "treeNode.h"
	int yyerror(char* msg);
	int yylex();
	extern char* yytext;
%}

%union 
{
	double dval;
	int val;
}

%token <dval> DOUBLE;
%token <int> INTEGER;
%token VAR
%token EQ NQ
%token LQ GQ 
%token IF THEN ELSE END WHILE DEF LOCAL PRINT
%token INT DOUB

%%

program : stmt_list ';'						{ puts("YYACCEPT"); YYACCEPT;}
		| '\n'								{ printf("-? "); YYACCEPT;}
		;
		 
		 

stmt_list : 
		  stmt_list stmt					{ puts("stmt_list <== stmt_list stmt"); }
		  | stmt '\n'						{ puts("stmt_list <== stmt"); printf("> "); }			
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
		   equal_expr EQ rel_expr				{ puts("equal <== eq == rel");}
		   | equal_expr NQ rel_expr				{ puts("equal <== eq != rel"); }
		   | rel_expr							{ puts("equal <== rel"); }
		   ;



rel_expr : 
		 rel_expr '>' addsub_expr				{ puts("rel <== rel > addsub"); }
		 rel_expr '<' addsub_expr				{ puts("rel <== rel < addsub"); }
		 rel_expr GQ addsub_expr				{ puts("rel <== rel >= addsub");}
		 rel_expr LQ addsub_expr				{ puts("rel <== rel <= addsub"); }
		 | addsub_expr							{ puts("rel <== addsub"); }
		 ;



addsub_expr :
			addsub_expr '+' muldiv_expr			{ puts("addsub <== addsub + muldiv"); }
			|addsub_expr '-' muldiv_expr		{ puts("addsub <== addsub - muldiv"); }
			| muldiv_expr						{ puts("addsub <== muldiv"); }
			;



muldiv_expr :
			muldiv_expr '*' cast				{ puts("muldiv <== muldiv * cast"); }
			| muldiv_expr '/' cast				{ puts("muldiv <== muldiv / cast"); }
			| cast								{ puts("muldiv <== cast"); }
			;



cast :
	 unary_expr									{ puts("cast <== unary"); }
	 | primary									{ puts("cast <== primary"); }
	 ;




unary_op : 
		 '-'									
		 ;




unary_expr :
		   unary_op cast						{ puts("unary <== unary_op cast"); }
		   ;




primary :
		VAR '(' stmt_list ')'					{ puts("primary <== ( stmt list )"); }
		| VAR '(' ')'							{ puts("primary <== var ()");}
		| '(' expr_stmt ')'						{ puts("primary <== ( expr )"); }
		| VAR									
			{ 
				puts("primary <== VAR"); 
			}
		| INTEGER								{ puts("primary <== INTEGER"); }
		| DOUBLE								
			{ 
				puts("primary <== DOUBLE"); 
				printf("%.2f\n", $1);
					
			}
		;




type_spec : 
		  INT 
		  | DOUB
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
