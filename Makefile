interpreter: lex.yy.c y.tab.c 
	gcc -o interpreter y.tab.c lex.yy.c -ly -ll 

lex.yy.c : mini_c.l
	flex mini_c.l

y.tab.c : test.y
	bison -d -y test.y

table :
	bison -b y -v test.y

clean : 
	rm lex.yy.c y.tab.c y.tab.h interpreter


