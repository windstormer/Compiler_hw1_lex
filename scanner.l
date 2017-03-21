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
chars ('.*')

%x COMMENT

%%
<COMMENT>"#pragma source off" {
	sourceoff = 1;
}

<COMMENT>"#pragma token off" {
	tokenoff = 1;
}

.*\n {
		strcpy(lastsentence,yytext);
		if(tokenoff==0) {
			yyless(0);
			BEGIN COMMENT;
		}else
		{
			lineCount++;
			fprintf(of,"%d:%s", lineCount,lastsentence);
		}
}

<COMMENT>\n {

	if(sourceoff==0)
	{
		lineCount++;
		fprintf(of,"%d:%s", lineCount,lastsentence);
		BEGIN 0;
	}
}

<COMMENT>\/\/.* {
strcpy(lastsentence,yytext);
	strcat(lastsentence,"\n");

}

<COMMENT>{strings} {
	strncpy(tempstring,yytext+1,strlen(yytext)-2);
	fprintf(of,"#string:%s",tempstring);
	fprintf(of,"\n");
}

<COMMENT>{chars} {
	fprintf(of,"#char:%s",yytext);
	fprintf(of,"\n");
}

<COMMENT>{key} { 
	fprintf(of,"#key:");
	fprintf(of,"%s",yytext);
	fprintf(of,"\n");
}
<COMMENT>{type} { 
	fprintf(of,"#key:");
	fprintf(of,"%s",yytext);
	fprintf(of,"\n");
}
<COMMENT>[-+]?[0-9]+\.?[0-9]+([eE][-+]?[0-9]+) {
	fprintf(of,"#sci:");
	fprintf(of,"%s",yytext);
	fprintf(of,"\n");
}

<COMMENT>[-+]?[0-9]+\.?[0-9]+ {
	fprintf(of,"#double:");
	fprintf(of,"%s",yytext);
	fprintf(of,"\n");
}

<COMMENT>[-+]?[0-9]+ {
	fprintf(of,"#integer:");
	fprintf(of,"%s",yytext);
	fprintf(of,"\n");
}

<COMMENT>{double_operator} {
	fprintf(of,"#op:");
	fprintf(of,"%s",yytext);
	fprintf(of,"\n");
}

<COMMENT>{single_operator} {
	fprintf(of,"#op:");
	fprintf(of,"%s",yytext);
	fprintf(of,"\n");
}

<COMMENT>{punctuation} {
	fprintf(of,"#punc:");
	fprintf(of,"%s",yytext);
	fprintf(of,"\n");
}

<COMMENT>" "

<COMMENT>[a-zA-Z]+ {
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
	return 1;
}
