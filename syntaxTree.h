#ifndef __PARSE_TREE_H
#define __PARSE_TREE_H
#include "stdbool.h"


typedef struct _bTreeNode {
	char* data;
	int tok;
	struct _bTreeNode* left;
	struct _bTreeNode* right;
} TreeNode;

TreeNode* createNode();
void setData(TreeNode* tn, char* data, int tok);
void preOrderTraverse(TreeNode* tn);
bool isSymbol(char* data, char** symt, int size);
void MakeRigtSubtree(TreeNode* main, TreeNode* sub);
void MakeLeftSubtree(TreeNode* main, TreeNode* sub);
#endif
