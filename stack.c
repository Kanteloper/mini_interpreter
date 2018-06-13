#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "stack.h"
#include "treeNode.h"

/*
 * function_name - stackInit
 * type - void
 * param - {@stack : ls}
 * detail - allocate memory to pointer array for stack and initiate top index
 */
void stackInit(Stack* ls) {
	ls->head = NULL;
}

/*
 * function_name - isEmpty
 * type - bool
 * param - {@stack : ls}
 * detail - check that stack is empty
 */
bool isEmpty(Stack* ls) {
	if(ls->head == NULL) { // if empty
		return true;
	}
	else
		return false;
}

/*
 * function_name - push
 * type - void
 * param - {@stack : ls}, {@data : nodePack*}
 * detail - push data to a stack
 */
void push(Stack* ls, Data data) {

	Node* newNode = (Node*)malloc(sizeof(Node));

	newNode-> data = data;
	newNode->next = ls->head;

	ls->head = newNode;
} 

/*
 * function_name - pop
 * type - char*
 * param - {@ls : Stack}
 * detail - pop data from a stack
 */
Data pop(Stack* ls) {
	Data rdata;
	Node* rnode;
	if(isEmpty(ls)) {
		return NULL;
	}

	rdata = ls->head->data;
	rnode = ls->head;
	
	ls->head = ls->head->next;
	free(rnode);
	return rdata;
}

/*
 * function_name - peek
 * type - TreeNode*
 * param - {@ls : Stack}
 * detail - check what data is in the top
 */
Data peek(Stack* ls) {
	if(isEmpty(ls)) {
		puts("Stack Memory Error! - peek");
		exit(-1);
	}

	return ls->head->data;
}

/*
 * function_name - printStack
 * type - void
 * param - {@stack : Stack}
 * detail - print all data in a stack
 */
void printStack(Stack* stack) {
	while(!isEmpty(stack)) {
		printf("stack : %d\n", pop(stack)->type);
	}
}
