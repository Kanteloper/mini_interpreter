interpreter: lex.yy.c y.tab.c treeNode.c stack.c  
	gcc -o interpreter y.tab.c lex.yy.c treeNode.c stack.c -ll -ly

lex.yy.c : mini_c.l
	flex mini_c.l

y.tab.c : mini_c2.y
	bison -d -y mini_c2.y

table :
	bison -b y -v mini_c.y

clean : 
	rm lex.yy.c y.tab.c y.tab.h interpreter *.o


