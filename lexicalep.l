%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include"syntaxe.tab.h"
//#include"TS.h"

int yylex();
extern int nbr = 1;
extern int nbrC = 1;
%}

Idf [a-zA-Z]([a-z0-9]){0,7}
saut \r\n|\n 
comment (%%#.\n)
chiffre [0-9]
chiffrenonNUL [1-9]
entier    {chiffre}+|"("("-"){chiffre}+")"
reel 0|(0|{chiffrenonNUL}{chiffre}*)"\."{chiffre}+|"("[-+](0|{chiffrenonNUL}{chiffre}*)"."{chiffre}+")"


%%

"VAR" {printf("MC VAR reconnu\n");nbrC += strlen(yytext); return mc_var;}
"CODE" {printf("MC code reconnu\n");nbrC += strlen(yytext); return mc_code;}
"INT" {printf("MC int reconnu\n");nbrC += strlen(yytext); return mc_int;}
"IF" {printf("mc if reconnu\n");nbrC += strlen(yytext); return mc_if;}
"ELSE" {printf("mc if reconnu\n");nbrC += strlen(yytext); return mc_else;}
"FOR" {printf("mc FOR reconnu\n");nbrC += strlen(yytext); return mc_for;}
"WHILE" {printf("mc WHILE reconnu\n");nbrC += strlen(yytext); return mc_while;}
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
":" {printf("sep : reconnu\n");nbrC += strlen(yytext); return deux_point;}
"," {printf("sep , reconnu\n");nbrC += strlen(yytext); return vir;}
"=" {printf("sep egale reconnu\n");nbrC += strlen(yytext); return egale;}
"+" {printf("plus reconnue \n");nbrC += strlen(yytext);return plus ;}
"-" {printf("moins reconnue \n"); nbrC += strlen(yytext); return moins ; }
"*" {printf("etoile reconnue \n"); nbrC += strlen(yytext); return etoile ; }
"/" {printf("div reconnue \n"); nbrC += strlen(yytext);return divi ;}
"&&" {printf("et logique reconnue \n"); nbrC += strlen(yytext);return et ;}
"||" {printf("ou logique reconnue \n"); nbrC += strlen(yytext);return ou ;}
"!" {printf("negation reconnue \n"); nbrC += strlen(yytext);return negation ;}
">" {printf("sup reconnue \n"); nbrC += strlen(yytext);return sup ;}
"<" {printf("inf reconnue \n"); nbrC += strlen(yytext);return inf ;}
"==" {printf("double egalité reconnue \n"); nbrC += strlen(yytext);return double_egale;}
"!=" {printf("inégalité reconnue \n"); nbrC += strlen(yytext);return inegalite;}
">=" {printf("sup ou egale reconnue \n"); nbrC += strlen(yytext);return sup_egal;}
"<=" {printf("inf ou egale reconnue \n"); nbrC += strlen(yytext);return inf_egal;}
"[" {printf("sep [ reconnu\n");nbrC += strlen(yytext); return crochet_ouv;}
"]" {printf("sep ] reconnu\n");nbrC += strlen(yytext); return crochet_fer;}
{saut} {nbr++;nbrC = 1;}
[ \t] {printf("tabulation reconnu\n");nbrC += strlen(yytext);}
. {printf("erreur lexicale a la ligne %d et a la colonne %d \n",nbr,nbrC);return err;}
%%

