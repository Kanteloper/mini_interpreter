#ifndef __STACK_H
#define _STACK_H

#include <stdbool.h>
#include "treeNode.h"

typedef nodePack* Data;

typedef struct _node {
	Data data; 
	struct _node* next;
} Node;

typedef struct _listStack {
	Node* head; // top
} ListStack;

typedef ListStack Stack;

void stackInit(Stack* ls);
bool isEmpty(Stack* ls);
void push(Stack* ls, Data data);
Data pop(Stack* ls);
Data peek(Stack* ls);
void printStack(Stack* stack); 

#endif
