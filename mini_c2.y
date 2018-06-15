%{
	#include <stdio.h>
	#include "stack.h"
	#include "treeNode.h"

	#define MAX_STK 100

	int yyerror(char* msg);
	int yylex();
	int cast_flag = 0;
	int idx = 0;
	extern int error_flag;
	extern int div_flag;
	extern int input_flag;
 
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
%token UMINUS

%%

program : stmt_list ';' 					
			{
			
				input_flag = 0;
				if( cast_flag != 0 ) // print int
				{
					long result = (long)ex(pop(&pstack)); 
					if(error_flag != 0)
					{
						yyerror("syntax error : variable is not defined");	
						error_flag = 0;
						YYACCEPT;
					}

					if(div_flag != 0)
					{
						yyerror("syntax error: divide by zero");	
						div_flag = 0;
						YYACCEPT;
					}
	
					printf("%ld\n", result);
					YYACCEPT;
				}
				else // print double 
				{
					double result = ex(pop(&pstack));	
					if(error_flag != 0)
					{
						yyerror("syntax error : variable is not defined");	
						error_flag = 0;
						YYACCEPT;
					}
					printf("%.2f\n", result);
					YYACCEPT;
				}

			}
		|
		;
		 
		 

stmt_list : 
		  stmt_list stmt					 
		  | stmt										
		  ;



stmt : 
	 selec_stmt								
		{
			input_flag = 0;
			ex(pop(&pstack));
			YYACCEPT;
		}
	 | iter_stmt							
		{
			input_flag = 0;
			ex(pop(&pstack));
			YYACCEPT;
		}
	 | print_stmt							
	 | expr_stmt							
	 ;



selec_stmt :
		   IF '(' expr_stmt ')' stmt_list ';' ELSE stmt_list ';' END  
			{
				nodePack* s7 = pop(&pstack);
				nodePack* s5 = pop(&pstack);
				nodePack* s3 = pop(&pstack);
				push(&pstack, makeNode(IF, 3, s3, s5, s7));
			}
		   ;



iter_stmt : 
		  WHILE '(' expr_stmt ')' stmt_list ';' END				
			{
				nodePack* s5 = pop(&pstack);
				nodePack* s3 = pop(&pstack);
				push(&pstack, makeNode(WHILE, 2, s3, s5));
			}
			|
		  ;



print_stmt : 
		   PRINT expr_stmt						
			{
				nodePack* s2 = pop(&pstack);
				push(&pstack, makeNode(PRINT, 1, s2));
			}
		   ;



expr_stmt : 
		  assign_expr						
		  ;



assign_expr : 
			equal_expr '=' equal_expr					
				{	
					nodePack* s3 = pop(&pstack);
					nodePack* s1 = pop(&pstack);
					push(&pstack, makeNode('=', 2, s1, s3));
				}
			| equal_expr		 			
			;



equal_expr : 
		   equal_expr EQ rel_expr				
			{ 
				cast_flag = 1;
				nodePack* s3 = pop(&pstack);
				nodePack* s1 = pop(&pstack);
				push(&pstack, makeNode(EQ, 2, s1, s3));

			}
		   | equal_expr NQ rel_expr				
			{
				cast_flag = 1;
				nodePack* s3 = pop(&pstack);
				nodePack* s1 = pop(&pstack);
				push(&pstack, makeNode(NQ, 2, s1, s3));
			}
		   | rel_expr							
		   ;



rel_expr : 
		 rel_expr '>' addsub_expr 				
			{ 
				cast_flag = 1;
				nodePack* s3 = pop(&pstack);
				nodePack* s1 = pop(&pstack);
				push(&pstack, makeNode('>', 2, s1, s3));
			}
		  |rel_expr '<' addsub_expr				
			{
				cast_flag = 1;
				nodePack* s3 = pop(&pstack);
				nodePack* s1 = pop(&pstack);
				push(&pstack, makeNode('<', 2, s1, s3));

		    }
		 |rel_expr GQ addsub_expr				
			{ 
				cast_flag = 1;
				nodePack* s3 = pop(&pstack);
				nodePack* s1 = pop(&pstack);
				push(&pstack, makeNode(GQ, 2, s1, s3));
			}
		 |rel_expr LQ addsub_expr				
			{ 
				cast_flag = 1;
				nodePack* s3 = pop(&pstack);
				nodePack* s1 = pop(&pstack);
				push(&pstack, makeNode(LQ, 2, s1, s3));
			}
		 | addsub_expr							
		 ;



addsub_expr :
			addsub_expr '+' muldiv_expr			
				{
					nodePack* s3 = pop(&pstack);
					nodePack* s1 = pop(&pstack);
					push(&pstack, makeNode('+', 2, s1, s3));
				}
			|addsub_expr '-' muldiv_expr		
				{ 
					nodePack* s3 = pop(&pstack);
					nodePack* s1 = pop(&pstack);
					push(&pstack, makeNode('-', 2, s1, s3));
				}
			| muldiv_expr						
			;



muldiv_expr :
			muldiv_expr '*' cast				
				{
					nodePack* s3 = pop(&pstack);
					nodePack* s1 = pop(&pstack);
					push(&pstack, makeNode('*', 2, s1, s3));
				}
			| muldiv_expr '/' cast				
				{ 
					nodePack* s3 = pop(&pstack);
					nodePack* s1 = pop(&pstack);
					if(s3->dbn.dval == 0.0 || s3->intn.val == 0)
					{
						yyerror("divide by zero");
						YYACCEPT;
					}
					else 
					{
						push(&pstack, makeNode('/', 2, s1, s3));
					}
				}
			| cast							
			;



cast :
	  unary_expr									
		{ 
			nodePack* s1 = pop(&pstack);
			push(&pstack, makeNode(UMINUS, 1, s1));
		}
	 | primary									
	 ;




unary_op : 
		 '-'									
		 ;




unary_expr :
		   unary_op cast						
		   ;




primary :
		VAR '(' stmt_list ')'					
		| VAR '(' ')'							
		| '(' expr_stmt ')'					
		| VAR									
			{ 
				push(&pstack, makeLeaf(typeVAR, &yylval.idx));
				
			}
		| INTEGER								
			{ 
				cast_flag = 1;
				push(&pstack, makeLeaf(typeINT, &yylval.val));
			}
		| DOUBLE								
			{ 
				cast_flag = 0;
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

	printf("-? ");
	while(!feof(stdin)) {
	stackInit(&pstack);	
		yyparse();
	}
	return 0;
}

