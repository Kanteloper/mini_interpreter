%{
	#include <stdio.h>
	#include "stack.h"
	#include "treeNode.h"

	#define MAX_STK 100

	int yyerror(char* msg);
	int yylex();
	int idx = 0;
 
	symNode* symTab[MAX_SYM]; // symbol table
	Stack pstack; // parse stack

%}

%union
{
	double dval;
	long val;
	int idx;
}

%token VAR DOUBLE INTEGER
%token EQ NQ
%token LQ GQ 
%token IF THEN ELSE END WHILE DEF LOCAL PRINT

%%

program : stmt_list ';' 					
			{ 
				puts("YYACCEPT");
				execute(pop(&pstack));
				idx = 0; 
				YYACCEPT;
			}
		| '\n'								{ printf("-? "); YYACCEPT;}
		;
		 
		 

stmt_list : 
		  stmt_list stmt					{ puts("stmt_list <== stmt_list stmt"); }
		  | stmt_list stmt '\n'				
			{ 
				puts("stmt_list <== stmt_list stmt newLine");
				printf("> ");
			}
		  | stmt '\n'						{ puts("stmt_list <== stmt newLine"); printf("> "); }
		  | stmt							{ puts("stmt_list <== stmt"); }			
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
			addsub_expr '+' muldiv_expr			
				{
					puts("addsub <== addsub + muldiv");
					nodePack* s2 = pop(&pstack);
					nodePack* s1 = pop(&pstack);
					push(&pstack, makeNode('+', 2, s1, s2));
				}
			|addsub_expr '-' muldiv_expr		
				{ 
					puts("addsub <== addsub - muldiv");
					nodePack* s2 = pop(&pstack);
					nodePack* s1 = pop(&pstack);
					push(&pstack, makeNode('-', 2, s1, s2));
				}
			| muldiv_expr						{ puts("addsub <== muldiv"); }
			;



muldiv_expr :
			muldiv_expr '*' cast				
				{
					puts("muldiv <== muldiv * cast");
					nodePack* s2 = pop(&pstack);
					nodePack* s1 = pop(&pstack);
					push(&pstack, makeNode('*', 2, s1, s2));
				}
			| muldiv_expr '/' cast				
				{ 
					puts("muldiv <== muldiv / cast");
					nodePack* s2 = pop(&pstack);
					nodePack* s1 = pop(&pstack);
					if(s2->dbn.dval == 0.0 || s2->intn.val == 0)
					{
						yyerror("divide by zero");
						YYACCEPT;
					}
					else 
					{
						push(&pstack, makeNode('/', 2, s1, s2));
					}
				}
			| cast								{ puts("muldiv <== cast"); }
			;



cast :
	  unary_expr									{ puts("cast <== unary"); }
	 | primary										{ puts("cast <== primary"); }
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
				makeLeaf(typeVAR, &yylval.idx);
				push(&pstack, makeLeaf(typeVAR, &yylval.dval));
				
			}
		| INTEGER								
			{ 
				puts("primary <== INTEGER"); 
				makeLeaf(typeINT, &yylval.val);
				push(&pstack, makeLeaf(typeINT, &yylval.dval));
			}
		| DOUBLE								
			{ 
				puts("primary <== DOUBLE"); 
				makeLeaf(typeDB, &yylval.val);
				push(&pstack, makeLeaf(typeDB, &yylval.dval));
			}
		;


%%

int yyerror(char* msg)
{
	fprintf(stderr, "%s\n", msg);
	return -1;
}

int main() {

	stackInit(&pstack);	
	printf("-? ");
	while(!feof(stdin)) {
		yyparse();
	}
	return 0;
}

