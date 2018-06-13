#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

#include "treeNode.h"
#include "stack.h"

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
			p->intn.val = *(int *)value;
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

int execute(nodePack* p)
{
	if(!p)
	{
		puts("w");
		return 0;
	}
	switch(p->type)
	{
		case typeINT : return p->intn.val;
		case typeDB  : return p->dbn.dval;
		case typeOpr :
			switch(p->oprn.opr)
			{
				case '+' :	
					// check type is same
					if(p->oprn.op[0]->type != p->oprn.op[1]->type)
					{
						puts("type differ");
					}
					else{
						printf("1: %d, 2: %d\n", execute(p->oprn.op[0]), execute(p->oprn.op[1]));
						puts("type same");
					}
			}
			
			break;
			
	}
}


