#include <stdio.h>
#include <stdlib.h>

#include "treeNode.h"


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
			puts("type double");
			break;

		case typeVAR:
			puts("type var");
			break;

		default:
			break;
	}
}


