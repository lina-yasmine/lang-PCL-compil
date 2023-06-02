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
         printf("MC VAR reconnu\n");nbrC += strlen(yytext); 
         return mc_var;
      }
"CODE" { rechercher(yytext,"mot cle","","",1);
         printf("MC code reconnu\n");nbrC += strlen(yytext); return mc_code;
        }
"INTEGER" { rechercher(yytext,"mot cle","","",1);
            printf("MC int reconnu\n");nbrC += strlen(yytext); return mc_int;
        }
"IF"     {
    rechercher(yytext,"mot cle","","",1);
    printf("mc if reconnu\n");nbrC += strlen(yytext); return mc_if;}
"ELSE"   {
    rechercher(yytext,"mot cle","","",1);
    printf("mc if reconnu\n");nbrC += strlen(yytext); return mc_else;}
"FOR"    {
    rechercher(yytext,"mot cle","","",1);
    printf("mc FOR reconnu\n");nbrC += strlen(yytext); return mc_for;}
"WHILE"  {
    rechercher(yytext,"mot cle","","",1);
    printf("mc WHILE reconnu\n");nbrC += strlen(yytext); return mc_while;}
"FLOAT"  {
    rechercher(yytext,"mot cle","","",1);
    printf("mc float reconnu\n");nbrC += strlen(yytext); return mc_float;}
"CONST"  {
    rechercher(yytext,"mot cle","","",1);
    printf("mc const reconnu\n");nbrC += strlen(yytext); return mc_const;}
"STRUCT" {
    rechercher(yytext,"mot cle","","",1);
    printf("mc STRUCT reconnu\n");nbrC += strlen(yytext); return mc_struct;}
{Idf} {
 if (yyleng<9) { 	
                  rechercher(yytext,"IDF","","",0);
                  printf("idf %s reconnu\n",yytext);nbrC += strlen(yytext);
                  yylval.str=strdup(yytext);return idf;
               }
 else { printf ("<< Erreur lexicale ( IDF trop long ), ligne %d, colonne %d : %s >>\n",nbr,nbrC,yytext); nbrC += strlen(yytext);} 
    }
{entier} { 
    if ((atoi(yytext)>-32768)&&(atoi(yytext)<32767)) {
    removePar(yytext);
	sprintf(tmp,"%d",atoi(yytext)); 
    // rechercher(tmp,"variable","INTEGER",tmp);
    printf("entier reconnu %s \n",yytext);nbrC+=strlen(yytext);
    yylval.Tentier=atoi(yytext); return entier;}
	else { printf ("<< Erreur lexicale ( Depassement de valeur ), ligne %d, colonne %d : %s >>\n",nbr,nbrC,yytext);	nbrC=nbrC+strlen(yytext); }
        }
{reel} {
    if ((atof(yytext)>-32768)&&(atof(yytext)<32767)) {
    removePar(yytext);
	sprintf(tmp,"%f",atof(yytext));
    // rechercher(tmp,"variable","FLOAT",tmp);
    printf("reel reconnu %s \n",yytext);nbrC+=strlen(yytext);
    yylval.Treel=atof(yytext); return reel; }
    	else { printf ("<< Erreur lexicale ( Depassement de valeur ), ligne %d, colonne %d : %s >>\n",nbr,nbrC,yytext);	nbrC=nbrC+strlen(yytext); }
         }
{comment} {nbrC = 1;}
"{" {
    rechercher(yytext,"sep","","",2);
    printf("sep { reconnu\n");nbrC += strlen(yytext); return accouv;
    }
"}" {
    rechercher(yytext,"sep","","",2);
    printf("sep } reconnu\n");nbrC += strlen(yytext); return accfer;}
"(" {
    rechercher(yytext,"sep","","",2);
    printf("sep ( reconnu\n");nbrC += strlen(yytext); return parouv;}
")" {
    rechercher(yytext,"sep","","",2);
    printf("sep ) reconnu\n");nbrC += strlen(yytext); return parferm;}
";" {
    rechercher(yytext,"sep","","",2);
    printf("sep ; reconnu\n");nbrC += strlen(yytext); return pointvir;}
":" {
    rechercher(yytext,"sep","","",2);
    printf("sep : reconnu\n");nbrC += strlen(yytext); return deux_point;}
"," {
    rechercher(yytext,"sep","","",2);
    printf("sep , reconnu\n");nbrC += strlen(yytext); return vir;}
"." {
    rechercher(yytext,"sep","","",2);
    printf("point reconnu\n");nbrC += strlen(yytext); return point;}
"=" {
    rechercher(yytext,"sep","","",2);
    printf("sep egale reconnu\n");nbrC += strlen(yytext); return egale;}
"+" {
    rechercher(yytext,"sep","","",2);
    printf("plus reconnue \n");nbrC += strlen(yytext);return plus;}
"-" {
    rechercher(yytext,"sep","","",2);
    printf("moins reconnue \n"); nbrC += strlen(yytext); return moins; }
"*" {
    rechercher(yytext,"sep","","",2);
    printf("etoile reconnue \n"); nbrC += strlen(yytext); return etoile; }
"/" {
    rechercher(yytext,"sep","","",2);
    printf("div reconnue \n"); nbrC += strlen(yytext);return divi;}
"&&" {
    rechercher(yytext,"sep","","",2);
    printf("et logique reconnue \n"); nbrC += strlen(yytext);return et;}
"||" {
    rechercher(yytext,"sep","","",2);
    printf("ou logique reconnue \n"); nbrC += strlen(yytext);return ou;}
"!" {
    rechercher(yytext,"sep","","",2);
    printf("negation reconnue \n"); nbrC += strlen(yytext);return negation;}
">" {
    rechercher(yytext,"sep","","",2);
    printf("sup reconnue \n"); nbrC += strlen(yytext);return sup;}
"<" {
    rechercher(yytext,"sep","","",2);
    printf("inf reconnue \n"); nbrC += strlen(yytext);return inf;}
"==" {
    rechercher(yytext,"sep","","",2);
    printf("double egalité reconnue \n"); nbrC += strlen(yytext);return double_egale;}
"!=" {
    rechercher(yytext,"sep","","",2);
    printf("inégalité reconnue \n"); nbrC += strlen(yytext);return inegalite;}
">=" {
    rechercher(yytext,"sep","","",2);
    printf("sup ou egale reconnue \n"); nbrC += strlen(yytext);return sup_egal;}
"<=" {
    rechercher(yytext,"sep","","",2);
    printf("inf ou egale reconnue \n"); nbrC += strlen(yytext);return inf_egal;}
"[" {
    rechercher(yytext,"sep","","",2);
    printf("sep [ reconnu\n");nbrC += strlen(yytext); return crochet_ouv;}
"]" {
    rechercher(yytext,"sep","","",2);
    printf("sep ] reconnu\n");nbrC += strlen(yytext); return crochet_fer;}
{saut} {nbr++;nbrC = 1;}
[ \t] {nbrC += strlen(yytext);}
. {printf("erreur lexicale a la ligne %d et a la colonne %d entite <<%s>> \n",nbr,nbrC,yytext);return err;}
%%

