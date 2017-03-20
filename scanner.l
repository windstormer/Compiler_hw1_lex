%{
	#include <stdio.h>

int	lineCount=0;
%}

key "printf"|"scanf"|"for"|"while"|"do"|"if"|"else"|"switch"|"break"|"continue"|"true"|"false"|"case"|"return"|"void"|"null"|"const"|"default"
type "int"|"double"|"short"|"float"|"char"|"bool"|"unsigned double"|"unsigned int"|"unsigned short"|"unsigned float"|"unsigned char"|"struct"
double_operator (\+\+|--|<<|>>|==|===|<=|>=|!=|\|\||\&\&)
single_operator (\+|-|<|>|\*|\/|!|\||\&|\%|=)
punctuation (:|;|,|\.|\[|\]|\(|\)|\{|\})
strings (\".*\")

%%
\/\/.* {
	ECHO;
}
{strings} {
	printf("#string:");
	ECHO;
	printf("\n");
}

{key} { 
	printf("#key:");
	ECHO;
	printf("\n");
}
{type} { 
	printf("#key:");
	ECHO;
	printf("\n");
}
[-+]?[0-9]+\.?[0-9]+([eE][-+]?[0-9]+) {
	printf("#Scientific notation:");
	ECHO;
	printf("\n");
}

[-+]?[0-9]+\.?[0-9]+ {
	printf("#double:");
	ECHO;
	printf("\n");
}

[-+]?[0-9]+ {
	printf("#integer:");
	ECHO;
	printf("\n");
}

{double_operator} {
	printf("#op:");
	ECHO;
	printf("\n");
}

{single_operator} {
	printf("#op:");
	ECHO;
	printf("\n");
}

{punctuation} {
	printf("#punc:");
	ECHO;
	printf("\n");
}

" "

[a-zA-Z]+ {
	printf("#id:");
	ECHO;
	printf("\n");
}

%%

int main(void) {
  yylex();
  return 0;
}

int yywrap() {
  return 1;
}
