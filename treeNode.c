#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <stdbool.h>

#include "treeNode.h"
#include "y.tab.h"
#include "stack.h"

extern symNode* symTab[MAX_SYM];
int div_flag = 0;
int error_flag = 0;

nodePack* makeLeaf(typeTag type, void* value)
{
	nodePack* p;
	switch(type)
	{
		case typeINT:
			if((p = malloc(sizeof(nodePack))) == NULL)
			{
				perror("int Node out of Memory\n");
				exit(0);
			}
			p->type = type;
			p->intn.val = *(long *)value;
			return p;

		case typeDB:
			if((p = malloc(sizeof(nodePack))) == NULL)
			{
				perror("double Node out of Memory\n");
				exit(0);
			}
			p->type = type;
			p->dbn.dval = *(double *)value;
			return p;

		case typeVAR:
			if((p = malloc(sizeof(nodePack))) == NULL)
			{
				perror("var Node out of Memory\n");
				exit(0);
			}
			p->type = type;
			p->idn.index = *(int *)value;
			break;

		default:
			break;
	}
}

nodePack* makeNode(int opr, int num, ...)
{
	va_list ap;
	nodePack* p;

	// allocate memory for opr node and extend structure array op
	if((p = malloc(sizeof(nodePack) + (num - 1) * sizeof(nodePack*))) == NULL)
	{
		perror("opr node out of memory\n");
		exit(0);
	}

	p->type = typeOpr;
	p->oprn.opr = opr;
	p->oprn.nops = num;
	// variable arguments
	va_start(ap, num);
	for(int i = 0; i < num; i++)
	{
		p->oprn.op[i] = va_arg(ap, nodePack*); 
	}
	va_end(ap);

	return p;
}

double ex(nodePack* p)
{
	double divzero;
	if(!p)	return 0.0;
	switch(p->type)
	{
		case typeINT :	return (double) p->intn.val;
		case typeDB	 :	return p->dbn.dval;
		case typeVAR : 
				if(symTab[p->idn.index]->val != 0.0) // var has value
				{
					return symTab[p->idn.index]->val;
				}
				else // var does not have value
				{
					error_flag = 1;
					return 0.0;
				}

		case typeOpr :

			switch(p->oprn.opr)
			{
				case UMINUS : return -ex(p->oprn.op[0]);
				case '=' :  return symTab[p->oprn.op[0]->idn.index]->val = ex(p->oprn.op[1]); 
				case '+' :	return ex(p->oprn.op[0]) + ex(p->oprn.op[1]);
				case '-' :  return ex(p->oprn.op[0]) - ex(p->oprn.op[1]);
				case '*' :  return ex(p->oprn.op[0]) * ex(p->oprn.op[1]);
				case '/' : 
						divzero = ex(p->oprn.op[1]);			
						if(divzero != 0.0)
						{
							return ex(p->oprn.op[0]) / ex(p->oprn.op[1]);
						}
						else 
						{
							div_flag = 1;
							return 0.0;
						}
				case '>' :	return ex(p->oprn.op[0]) > ex(p->oprn.op[1]);
				case '<' :	return ex(p->oprn.op[0]) < ex(p->oprn.op[1]);
				case  GQ :	return ex(p->oprn.op[0]) >= ex(p->oprn.op[1]);
				case  LQ :	return ex(p->oprn.op[0]) <= ex(p->oprn.op[1]);
				case  EQ :	return ex(p->oprn.op[0]) == ex(p->oprn.op[1]);
				case  NQ :	return ex(p->oprn.op[0]) != ex(p->oprn.op[1]);
				case PRINT : return ex(p->oprn.op[0]);
				case WHILE : 
						puts("while");
						while(ex(p->oprn.op[0])) 
						{
							 ex(p->oprn.op[1]);  
						}
						return 0.0;
				case IF : 
						if(ex(p->oprn.op[0]))
						{
							puts("if");
							 return ex(p->oprn.op[1]);
						}
						else if(p->oprn.nops > 2)
						{
							 puts("if");
							 return ex(p->oprn.op[2]);
						}
			}
			break;
	}
}

bool beDuplicated(symNode** sym, char* arg, int num)
{
	for(int i = 0; i < num; i ++)
	{
		if(strcmp(sym[i]->sym, arg) == 0)
		{
			return true;
		}
	}
	return false;
}

int searchSym(symNode** sym, char* arg)
{
	int idx = 0;
	while(sym[idx]->sym != NULL)
	{
		if(strcmp(sym[idx]->sym, arg) == 0)
		{
			return idx;
		}
		idx++;
	}
}


