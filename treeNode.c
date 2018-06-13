#include <stdio.h>
#include "treeNode.h"


nodePack* makeLeaf(typeTag type, void* value)
{
	switch(type)
	{
		case typeINT:
			puts("type int");
			break;

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
