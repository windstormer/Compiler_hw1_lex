%{
	#include <stdio.h>
	#include <string.h>

int	lineCount=0;
char lastsentence[3000];
char tempstring[3000];
int tokenoff = 0;
int sourceoff = 0;

%}

key "printf"|"scanf"|"for"|"while"|"do"|"if"|"else"|"switch"|"break"|"continue"|"true"|"false"|"case"|"return"|"void"|"null"|"const"|"default"
type "int"|"double"|"short"|"float"|"char"|"bool"|"unsigned double"|"unsigned int"|"unsigned short"|"unsigned float"|"unsigned char"|"struct"
double_operator (\+\+|--|<<|>>|==|===|<=|>=|!=|\|\||\&\&)
single_operator (\+|-|<|>|\*|\/|!|\||\&|\%|=)
punctuation (:|;|,|\.|\[|\]|\(|\)|\{|\})
strings (\".*\")

%x COMMENT

%%
"#pragma source off" {
	sourceoff = 1;
}

"#pragma token off" {
	tokenoff = 1;
}

<COMMENT>.*\n {
		lineCount++;
		printf("%d:%s", lineCount,lastsentence);
		strcpy(lastsentence,yytext);
		if(tokenoff==0) {
			yyless(0);
			BEGIN 0;
		}
}

\n {
	if(sourceoff==0)BEGIN COMMENT;
}

\/\/.* {
strcpy(lastsentence,yytext);
	strcat(lastsentence,"\n");

}

{strings} {
	strncpy(tempstring,yytext+1,strlen(yytext)-2);
	printf("#string:%s",tempstring);
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
	printf("#sci:");
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
	if(sourceoff==0)
	{
		lineCount++;
		printf("%d:%s", lineCount,lastsentence);	
	}
	return 1;
}
