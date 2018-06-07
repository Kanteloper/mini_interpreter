interpreter: lex.yy.c y.tab.c 
	gcc -o interpreter y.tab.c lex.yy.c -ly -ll

lex.yy.c : mini_c.l
	flex mini_c.l

y.tab.c : mini_c.y
	bison -d -y mini_c.y

table :
	bison -b y -v mini_c.y

clean : 
	rm lex.yy.c y.tab.c y.tab.h interpreter


