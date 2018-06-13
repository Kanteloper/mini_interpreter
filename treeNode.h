#ifndef __TREE_NODE_H
#define __TREE_NODE_H


typedef enum { typeINT, typeDB, typeVAR } typeTag;

// node for identifier
typedef struct _id_node
{	
	char* entry; // size of characters 16
} idNode;

// node for integer
typedef struct _int_node
{
	int val; // size of number 10
} intNode;

// node for double
typedef struct _doub_node
{
	double val; // size of number 10
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

nodePack* makeLeaf(typeTag type, void* value);


#endif

