#ifndef __TREE_NODE_H
#define __TREE_NODE_H

#define MAX_SYM 100

typedef enum { typeINT, typeDB, typeVAR } typeTag;

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

typedef struct _node_pack
{
	typeTag type; // type of node
	union // union for node according to type
	{
		idNode idn;
		intNode intn;
		doubNode dbn;
	};
} nodePack;

typedef struct _sym_node
{
	char* sym;
	nodePack* p;
} symNode;

nodePack* makeLeaf(typeTag type, void* value);


#endif

