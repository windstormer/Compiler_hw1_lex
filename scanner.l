%{
	#include <stdio.h>
	#include <string.h>
		FILE *of;
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
		fprintf(of,"%d:%s", lineCount,lastsentence);
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
	fprintf(of,"#string:%s",tempstring);
	fprintf(of,"\n");
}

{key} { 
	fprintf(of,"#key:");
	fprintf(of,"%s",yytext);
	fprintf(of,"\n");
}
{type} { 
	fprintf(of,"#key:");
	fprintf(of,"%s",yytext);
	fprintf(of,"\n");
}
[-+]?[0-9]+\.?[0-9]+([eE][-+]?[0-9]+) {
	fprintf(of,"#sci:");
	fprintf(of,"%s",yytext);
	fprintf(of,"\n");
}

[-+]?[0-9]+\.?[0-9]+ {
	fprintf(of,"#double:");
	fprintf(of,"%s",yytext);
	fprintf(of,"\n");
}

[-+]?[0-9]+ {
	fprintf(of,"#integer:");
	fprintf(of,"%s",yytext);
	fprintf(of,"\n");
}

{double_operator} {
	fprintf(of,"#op:");
	fprintf(of,"%s",yytext);
	fprintf(of,"\n");
}

{single_operator} {
	fprintf(of,"#op:");
	fprintf(of,"%s",yytext);
	fprintf(of,"\n");
}

{punctuation} {
	fprintf(of,"#punc:");
	fprintf(of,"%s",yytext);
	fprintf(of,"\n");
}

" "

[a-zA-Z]+ {
	fprintf(of,"#id:");
	fprintf(of,"%s",yytext);
	fprintf(of,"\n");
}

%%

int main(void) {

	of = fopen("./scanner.out","w");
	yylex();
	return 0;
}

int yywrap() {
	if(sourceoff==0)
	{
		lineCount++;
		fprintf(of,"%d:%s", lineCount,lastsentence);	
	}
	return 1;
}
