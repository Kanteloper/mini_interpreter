#ifndef __STACK_H
#define _STACK_H

#include "parseTree.h"
#include <stdbool.h>

typedef TreeNode* Data;

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
