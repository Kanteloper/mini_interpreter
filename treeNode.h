#ifdef __TREE_NODE_H
#define __TREE_NODE_H

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

// union for node
typedef union 
{
	idNode idn;
	intNode intn;
	doubNode dbn;
} N;





#endif

