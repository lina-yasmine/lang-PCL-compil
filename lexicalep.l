%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include"syntaxe.tab.h"
#include "new.h"


extern YYSTYPE yylval;
int yylex();
int nbr = 1,i;
extern int nbrC;

char tmp[20];
%}

%option noyywrap
Idf [a-zA-Z]([a-z0-9]*) 
saut \r\n|\n 
comment (%%#.\n)
chiffre [0-9]
chiffrenonNUL [1-9]
entier    {chiffre}+|"("("-"){chiffre}+")"
reel 0|(0|{chiffrenonNUL}{chiffre}*)"\."{chiffre}+|"("[-+](0|{chiffrenonNUL}{chiffre}*)"."{chiffre}+")"


%%

"VAR" {  rechercher(yytext,"mot cle","","",1);
         printf("VAR \n");nbrC += strlen(yytext); 
         return mc_var;
      }
"CODE" { rechercher(yytext,"mot cle","","",1);
         printf("CODE \n");nbrC += strlen(yytext); return mc_code;
        }
"INTEGER" { rechercher(yytext,"mot cle","","",1);
            printf(" int ");nbrC += strlen(yytext); return mc_int;
        }
"IF"     {
    rechercher(yytext,"mot cle","","",1);
    printf(" IF ");nbrC += strlen(yytext); return mc_if;}
"ELSE"   {
    rechercher(yytext,"mot cle","","",1);
    printf(" ELSE ");nbrC += strlen(yytext); return mc_else;}
"FOR"    {
    rechercher(yytext,"mot cle","","",1);
    printf(" FOR ");nbrC += strlen(yytext); return mc_for;}
"WHILE"  {
    rechercher(yytext,"mot cle","","",1);
    printf(" WHILE ");nbrC += strlen(yytext); return mc_while;}
"FLOAT"  {
    rechercher(yytext,"mot cle","","",1);
    printf(" float ");nbrC += strlen(yytext); return mc_float;}
"CONST"  {
    rechercher(yytext,"mot cle","","",1);
    printf(" const ");nbrC += strlen(yytext); return mc_const;}
"STRUCT" {
    rechercher(yytext,"mot cle","","",1);
    printf(" STRUCT ");nbrC += strlen(yytext); return mc_struct;}
{Idf} {
 if (yyleng<9) { 	
                  rechercher(yytext,"IDF","","",0);
                  printf(" %s ",yytext);nbrC += strlen(yytext);
                  yylval.str=strdup(yytext);return idf;
               }
 else { printf ("\n << Erreur lexicale ( IDF trop long ), ligne %d, colonne %d : %s >>\n",nbr,nbrC,yytext); nbrC += strlen(yytext);} 
    }
{entier} { 
    if ((atoi(yytext)>-32768)&&(atoi(yytext)<32767)) {
    removePar(yytext);
	sprintf(tmp,"%d",atoi(yytext)); 
    // rechercher(tmp,"variable","INTEGER",tmp);
    printf("  %s ",yytext);nbrC+=strlen(yytext);
    yylval.Tentier=atoi(yytext); return entier;}
	else { printf ("\n << Erreur lexicale ( Depassement de valeur ), ligne %d, colonne %d : %s >>\n",nbr,nbrC,yytext);	nbrC=nbrC+strlen(yytext); }
        }
{reel} {
    if ((atof(yytext)>-32768)&&(atof(yytext)<32767)) {
    removePar(yytext);
	sprintf(tmp,"%f",atof(yytext));
    // rechercher(tmp,"variable","FLOAT",tmp);
    printf("  %s \n",yytext);nbrC+=strlen(yytext);
    yylval.Treel=atof(yytext); return reel; }
    	else { printf ("\n << Erreur lexicale ( Depassement de valeur ), ligne %d, colonne %d : %s >>\n",nbr,nbrC,yytext);	nbrC=nbrC+strlen(yytext); }
         }
{comment} {nbrC = 1;}
"{" {
    rechercher(yytext,"sep","","",2);
    printf(" { ");nbrC += strlen(yytext); return accouv;
    }
"}" {
    rechercher(yytext,"sep","","",2);
    printf(" } ");nbrC += strlen(yytext); return accfer;}
"(" {
    rechercher(yytext,"sep","","",2);
    printf(" ( ");nbrC += strlen(yytext); return parouv;}
")" {
    rechercher(yytext,"sep","","",2);
    printf(" ) ");nbrC += strlen(yytext); return parferm;}
";" {
    rechercher(yytext,"sep","","",2);
    printf(" ; ");nbrC += strlen(yytext); return pointvir;}
":" {
    rechercher(yytext,"sep","","",2);
    printf(" : ");nbrC += strlen(yytext); return deux_point;}
"," {
    rechercher(yytext,"sep","","",2);
    printf(" , ");nbrC += strlen(yytext); return vir;}
"." {
    rechercher(yytext,"sep","","",2);
    printf(" . ");nbrC += strlen(yytext); return point;}
"=" {
    rechercher(yytext,"sep","","",2);
    printf(" = ");nbrC += strlen(yytext); return egale;}
"+" {
    rechercher(yytext,"sep","","",2);
    printf(" + ");nbrC += strlen(yytext);return plus;}
"-" {
    rechercher(yytext,"sep","","",2);
    printf(" - "); nbrC += strlen(yytext); return moins; }
"*" {
    rechercher(yytext,"sep","","",2);
    printf(" * "); nbrC += strlen(yytext); return etoile; }
"/" {
    rechercher(yytext,"sep","","",2);
    printf(" / "); nbrC += strlen(yytext);return divi;}
"&&" {
    rechercher(yytext,"sep","","",2);
    printf("et logique  "); nbrC += strlen(yytext);return et;}
"||" {
    rechercher(yytext,"sep","","",2);
    printf("ou logique  "); nbrC += strlen(yytext);return ou;}
"!" {
    rechercher(yytext,"sep","","",2);
    printf("negation  "); nbrC += strlen(yytext);return negation;}
">" {
    rechercher(yytext,"sep","","",2);
    printf("sup  "); nbrC += strlen(yytext);return sup;}
"<" {
    rechercher(yytext,"sep","","",2);
    printf("inf  "); nbrC += strlen(yytext);return inf;}
"==" {
    rechercher(yytext,"sep","","",2);
    printf("double egalité  "); nbrC += strlen(yytext);return double_egale;}
"!=" {
    rechercher(yytext,"sep","","",2);
    printf("inégalité  "); nbrC += strlen(yytext);return inegalite;}
">=" {
    rechercher(yytext,"sep","","",2);
    printf("sup ou egale  "); nbrC += strlen(yytext);return sup_egal;}
"<=" {
    rechercher(yytext,"sep","","",2);
    printf("inf ou egale  "); nbrC += strlen(yytext);return inf_egal;}
"[" {
    rechercher(yytext,"sep","","",2);
    printf(" [");nbrC += strlen(yytext); return crochet_ouv;}
"]" {
    rechercher(yytext,"sep","","",2);
    printf("] ");nbrC += strlen(yytext); return crochet_fer;}
{saut} {nbr++;nbrC = 1;}
[ \t] {nbrC += strlen(yytext);}
. {printf("\n erreur lexicale a la ligne %d et a la colonne %d entite <<%s>> \n",nbr,nbrC,yytext);return err;}
%%

