#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include "parseTree.h"
#include "token.h"

/*
 * func_name : createTree
 * type : TreeNode*
 * param : -
 * detail : initiate tree node structure
 */
TreeNode* createNode() {
	TreeNode* nd = (TreeNode*)malloc(sizeof(TreeNode));
	nd->tok = 0;
	nd->left = NULL;
	nd->right = NULL;
	return nd;
}

/*
 * func_name : setData
 * type : void
 * param : {@tn : TreeNode*} - binaryTree node
 *		   {@data : char*} - data for saving
 * detail : save data to tree node
 */
void setData(TreeNode* tn, char* data, int tok) {
	tn->data = data;
	tn->tok = tok;
}

/*
 * func_name : preOrderTraverse
 * type : void
 * detail : output parse tree by xml format
 */
void preOrderTraverse(TreeNode* tn) {
	
	if(tn == NULL) return;

	switch(tn->tok) {
		
		case PLUS:
			puts("<plus>");
			preOrderTraverse(tn->left);
			preOrderTraverse(tn->right);
			puts("</plus>");
			break;

		case MINUS:
			if(tn->left != NULL) { // binary minus
				puts("<minus>");
				preOrderTraverse(tn->left);
				preOrderTraverse(tn->right);
				puts("</minus>");
			}
			else { // unary minus
				puts("<uminus>");
				preOrderTraverse(tn->left);
				preOrderTraverse(tn->right);
				puts("</uminus>");
			}
			break;

		case MULT :

				puts("<mult>");
				preOrderTraverse(tn->left);
				preOrderTraverse(tn->right);
				puts("</mult>");
				break;

		case DIV :
				puts("<div>");
				preOrderTraverse(tn->left);
				preOrderTraverse(tn->right);
				puts("</div>");
				break;

		case ASSIGN :
				puts("<assign>");
				preOrderTraverse(tn->left);
				preOrderTraverse(tn->right);
				puts("</assign>");
				break;
	
		case ID :
				printf("<id>%s</id>\n", tn->data);
				preOrderTraverse(tn->left);
				preOrderTraverse(tn->right);
				break;

		case FLOAT :
				printf("<float>%s</float>\n", tn->data);
				preOrderTraverse(tn->left);
				preOrderTraverse(tn->right);
				break;

		case INT :
				printf("<int>%s</int>\n", tn->data);
				preOrderTraverse(tn->left);
				preOrderTraverse(tn->right);
				break;
	}
}


/*
 * func_name : MakeRigtSubtree
 * type : void
 * param : {@main : TreeNode*}
 *		   {@sub : TreeNode*}
 * detail : make right subtree 
 */
void MakeRigtSubtree(TreeNode* main, TreeNode* sub) {
	if(main->right != NULL) {
		free(main->right);
	}
	main->right = sub;
}

/*
 * func_name : MakeLeftSubtree
 * type : void
 * param : {@main : TreeNode*}
 *		   {@sub : TreeNode*}
 * detail : make left subtree 
 */
void MakeLeftSubtree(TreeNode* main, TreeNode* sub) {
	if(main->left != NULL) {
		free(main->left);
	}
	main->left = sub;
}


