%option yylineno

%{
	#include <stdio.h>
	#include <string.h>
int	lineCount=0;
char lastsentence[3000];
char tempstring[3000];
int token = 1;
int source = 1;



%}

key "printf"|"scanf"|"for"|"while"|"do"|"if"|"else"|"switch"|"break"|"continue"|"true"|"false"|"case"|"return"|"void"|"null"|"const"|"default"
type "int"|"double"|"short"|"float"|"char"|"bool"|"unsigned double"|"unsigned int"|"unsigned short"|"unsigned float"|"unsigned char"|"struct"|"unsigned"
double_operator (\+\+|--|<<|>>|==|<=|>=|!=|\|\||\&\&)
single_operator (\+|-|<|>|\*|\/|!|\||\&|\%|=)
punctuation (:|;|,|\.|\[|\]|\(|\)|\{|\})
strings (\".*\")
chars ('.'|'\\n'|'\\t')

Quote "

%x COMMENT
%x STATE

%%

.*\n {
	if(strcmp(yytext,"#pragma token on\n")==0) {
		token = 1;
	}
	if(strcmp(yytext,"#pragma source on\n")==0)	{
		source = 1;
	}
		strcpy(lastsentence,yytext);

			if(token==1) {
			yyless(0);
			BEGIN STATE;
			}else
			{

				lineCount++;
				 if(source==1)
				 	fprintf(stdout,"%d:%s", lineCount,lastsentence);
			}
		
}
<STATE>"#pragma source off" {
	source = 0;
}
<STATE>"#pragma source on" {
	strcpy(lastsentence,yytext);
	strcat(lastsentence,"\n");
	source = 1;
}

<STATE>"#pragma token off" {
	token = 0;
}
<STATE>"#pragma token on" {
	token = 1;
}

<STATE>\n {
	if(source==1)
	{
		lineCount++;
		fprintf(stdout,"%d:%s", lineCount,lastsentence);
		BEGIN 0;
	}else
	{
		lineCount++;
		if(token==0)
			BEGIN 0;
	}
}
<STATE>\/\*.*\*\/\n {
	lineCount++;
	strcpy(lastsentence,yytext);
	fprintf(stdout,"%d:%s", lineCount,lastsentence);
}
<STATE>\/\*.*\n {
	lineCount++;
	strcpy(lastsentence,yytext);
	fprintf(stdout,"%d:%s", lineCount,lastsentence);
	BEGIN COMMENT;
}
<COMMENT>.*\*\/\n {
	lineCount++;
	strcpy(lastsentence,yytext);
	fprintf(stdout,"%d:%s", lineCount,lastsentence);
	BEGIN 0;
}
<COMMENT>.*\n {
	lineCount++;
	strcpy(lastsentence,yytext);
	fprintf(stdout,"%d:%s", lineCount,lastsentence);
}

<STATE>\/\/.* {
	strcpy(lastsentence,yytext);
	strcat(lastsentence,"\n");
}


<STATE>{strings} {
	strncpy(tempstring,yytext+1,strlen(yytext)-2);
	fprintf(stdout,"#string:%s",tempstring);
	fprintf(stdout,"\n");
}

<STATE>{chars} {
	fprintf(stdout,"#char:%s",yytext);
	fprintf(stdout,"\n");
}

<STATE>{key} { 
	fprintf(stdout,"#key:");
	fprintf(stdout,"%s",yytext);
	fprintf(stdout,"\n");
}
<STATE>{type} { 
	fprintf(stdout,"#key:");
	fprintf(stdout,"%s",yytext);
	fprintf(stdout,"\n");
}

<STATE>{double_operator} {
	fprintf(stdout,"#op:");
	fprintf(stdout,"%s",yytext);
	fprintf(stdout,"\n");
}

<STATE>{single_operator} {
	fprintf(stdout,"#op:");
	fprintf(stdout,"%s",yytext);
	fprintf(stdout,"\n");
}

<STATE>{punctuation} {
	fprintf(stdout,"#punc:");
	fprintf(stdout,"%s",yytext);
	fprintf(stdout,"\n");
}

<STATE>" "|"\t"

<STATE>[a-zA-Z_][a-zA-Z_0-9]* {
	fprintf(stdout,"#id:");
	fprintf(stdout,"%s",yytext);
	fprintf(stdout,"\n");
}

<STATE>[0-9]+[a-zA-Z_]+ {
	fprintf(stderr, "#Error at line %d: %s\n",yylineno,yytext);
	exit(1);
}
<STATE>[-+]?([0-9]*\.?[0-9]+|[0-9]+\.[0-9]*)([eE][-+]?([0-9]*\.[0-9]+|[0-9]+\.[0-9]*)) {
	fprintf(stderr, "#Error at line %d: %s\n",yylineno,yytext);
	exit(1);
}

<STATE>[-+]?([0-9]*\.?[0-9]+|[0-9]+\.[0-9]*)([eE][-+]?[0-9]+) {
	fprintf(stdout,"#sci:");
	fprintf(stdout,"%s",yytext);
	fprintf(stdout,"\n");
}

<STATE>[-+]?[0-9]*\.[0-9]+|[-+]?[0-9]+\.[0-9]* {
	fprintf(stdout,"#double:");
	fprintf(stdout,"%s",yytext);
	fprintf(stdout,"\n");
}
<STATE>0[0-9]+|0[xX][0-9a-fA-F]+ {
	fprintf(stderr, "#Error at line %d: %s\n",yylineno,yytext);
	exit(1);
}

<STATE>[-+]?[1-9][0-9]*|0 {
	fprintf(stdout,"#integer:");
	fprintf(stdout,"%s",yytext);
	fprintf(stdout,"\n");
}

<STATE>. {
	fprintf(stderr, "#Error at line %d: %s\n",yylineno,yytext);
	exit(1);
}


%%

int main(void) {

	yylex();
	return 0;
}

int yywrap() {
	return 1;
}
