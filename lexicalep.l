%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include"syntaxe.tab.h"
//#include"TS.h"

int yylex();
int nbr = 1;
int nbrC = 1;
%}

Idf ^[a-zA-Z][a-zA-Z0-9]{0,7}$
saut \r\n|\n 
comment (%%#.\n)
chiffre [0-9]
entier {chiffre}+
reel {chiffre}+"."{chiffre}*

%%

"VAR" {printf("MC VAR reconnu\n");nbrC += strlen(yytext); return mc_var;}
"CODE" {printf("MC code reconnu\n");nbrC += strlen(yytext); return mc_code;}
"INT" {printf("MC int reconnu\n");nbrC += strlen(yytext); return mc_int;}
"if" {printf("mc if reconnu\n");nbrC += strlen(yytext); return mc_if;}
"FLOAT" {printf("mc float reconnu\n");nbrC += strlen(yytext); return mc_float;}
"CONST" {printf("mc const reconnu\n");nbrC += strlen(yytext); return mc_const;}
"STRUCT" {printf("mc STRUCT reconnu\n");nbrC += strlen(yytext); return mc_struct;}
{Idf} {printf("idf reconnu\n");nbrC += strlen(yytext); return idf;}
{entier} {printf("entier reconnu %s \n",yytext);nbrC+=strlen(yytext);return entier;}
{reel} {printf("reel reconnu %s \n",yytext);nbrC+=strlen(yytext);return reel;}
{comment} {nbrC = 1;}
"{" {printf("sep { reconnu\n");nbrC += strlen(yytext); return accouv;}
"}" {printf("sep } reconnu\n");nbrC += strlen(yytext); return accfer;}
"(" {printf("sep ( reconnu\n");nbrC += strlen(yytext); return parouv;}
")" {printf("sep ) reconnu\n");nbrC += strlen(yytext); return parferm;}
";" {printf("sep ; reconnu\n");nbrC += strlen(yytext); return pointvir;}
"," {printf("sep vir reconnu\n");nbrC += strlen(yytext); return vir;}
"=" {printf("sep egale reconnu\n");nbrC += strlen(yytext); return egale;}
{saut} {nbr++;nbrC = 1;}
[ \t] {printf("tabulation reconnu\n");nbrC += strlen(yytext);}
. {printf("erreur lexicale a la ligne %d et a la colonne %d \n",nbr,nbrC);return err;}
%%

