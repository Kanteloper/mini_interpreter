#ifndef __TREE_NODE_H
#define __TREE_NODE_H

#include <stdarg.h>

#define MAX_SYM 100

typedef enum 
{ 
	typeINT, 
	typeDB, 
	typeVAR,  
	typeOpr,
} typeTag;

// node for identifier
typedef struct _id_node
{	
	int index; // index for symbol table array
} idNode;

// node for integer
typedef struct _int_node
{
	int val; // size of number 10
} intNode;

// node for double
typedef struct _doub_node
{
	double dval; // size of number 10
} doubNode;

// node for operator
typedef struct _opr_node
{
	int opr; // type of operator
	int nops; // number of operands
	struct _node_pack *op[1]; // nodePack structure array for several operands.
} oprNode;

typedef struct _node_pack
{
	typeTag type; // type of node 
	// union for node according to type
	union 
	{
		idNode idn;	
		intNode intn;
		doubNode dbn;
		oprNode oprn;

	};
} nodePack;

typedef struct _sym_node
{
	char* sym;
	nodePack* p;
} symNode;

nodePack* makeLeaf(typeTag type, void* value);
nodePack* makeNode(int opr, int num, ...);
double ex(nodePack* p);

#endif

