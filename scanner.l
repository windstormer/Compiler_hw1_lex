%option yylineno

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
chars ('.*')

%x COMMENT

%%


.*\n {
		strcpy(lastsentence,yytext);
		if(tokenoff==0) {
			yyless(0);
			BEGIN COMMENT;
		}else
		{
			lineCount++;
			fprintf(stdout,"%d:%s", lineCount,lastsentence);
		}
}
<COMMENT>"#pragma source off" {
	sourceoff = 1;
}

<COMMENT>"#pragma token off" {
	tokenoff = 1;
}

<COMMENT>\n {

	if(sourceoff==0)
	{
		lineCount++;
		fprintf(stdout,"%d:%s", lineCount,lastsentence);
		BEGIN 0;
	}
}

<COMMENT>\/\/.* {
strcpy(lastsentence,yytext);
	strcat(lastsentence,"\n");

}

<COMMENT>{strings} {
	strncpy(tempstring,yytext+1,strlen(yytext)-2);
	fprintf(stdout,"#string:%s",tempstring);
	fprintf(stdout,"\n");
}

<COMMENT>{chars} {
	fprintf(stdout,"#char:%s",yytext);
	fprintf(stdout,"\n");
}

<COMMENT>{key} { 
	fprintf(stdout,"#key:");
	fprintf(stdout,"%s",yytext);
	fprintf(stdout,"\n");
}
<COMMENT>{type} { 
	fprintf(stdout,"#key:");
	fprintf(stdout,"%s",yytext);
	fprintf(stdout,"\n");
}

<COMMENT>{double_operator} {
	fprintf(stdout,"#op:");
	fprintf(stdout,"%s",yytext);
	fprintf(stdout,"\n");
}

<COMMENT>{single_operator} {
	fprintf(stdout,"#op:");
	fprintf(stdout,"%s",yytext);
	fprintf(stdout,"\n");
}

<COMMENT>{punctuation} {
	fprintf(stdout,"#punc:");
	fprintf(stdout,"%s",yytext);
	fprintf(stdout,"\n");
}

<COMMENT>" "

<COMMENT>[a-zA-Z_][a-zA-Z_0-9]* {
	fprintf(stdout,"#id:");
	fprintf(stdout,"%s",yytext);
	fprintf(stdout,"\n");
}

<COMMENT>[0-9]+[a-zA-Z_]+ {
	fprintf(stderr, "#Error at line %d: %s\n",yylineno,yytext);
	exit(1);
}

<COMMENT>[-+]?[0-9]+\.?[0-9]+([eE][-+]?[0-9]+) {
	fprintf(stdout,"#sci:");
	fprintf(stdout,"%s",yytext);
	fprintf(stdout,"\n");
}

<COMMENT>[-+]?[0-9]+\.[0-9]+ {
	fprintf(stdout,"#double:");
	fprintf(stdout,"%s",yytext);
	fprintf(stdout,"\n");
}

<COMMENT>[-+]?[1-9][0-9]*|0 {
	fprintf(stdout,"#integer:");
	fprintf(stdout,"%s",yytext);
	fprintf(stdout,"\n");
}


%%

int main(void) {

	yylex();
	return 0;
}

int yywrap() {
	return 1;
}
