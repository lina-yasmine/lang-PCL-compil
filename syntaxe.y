%{

 #include<stdio.h>
 #include<stdlib.h>
 #include<string.h>
 #include <stdbool.h>


extern int nbr;
int nbrC=1;
int yylex();
int yyerror(char* msg);
void afficher();
void initialisation();
int doubleDeclaration(char entite[]);
void insererTYPE(char entite[], char type[]);
void insererCODE(char entite[]);

int i=0,n,j=0,e=0,m;
char vars[20][9];
char types[20][9];
char buf[25];
char cstype[10];
// char *type;
// int a=0;

%}

%union {
        int Tentier;
        float Treel;
        char* str;
}

%token <str>mc_int <str>mc_float vir pointvir accfer accouv parferm parouv <str>idf mc_if crochet_ouv crochet_fer
%token err mc_for mc_while mc_var mc_code <str>mc_struct mc_const egale plus moins etoile divi
%token sup_egal inf_egal inegalite sup inf double_egale negation et ou mc_else deux_point
%token <Tentier>entier <Treel>reel
%type <str> TYPE VAR
// Les prioritées 
%left          et                
%left          ou         
%left     sup sup_egal double_egale  inegalite inf_egal inf             
%left     plus moins           
%left     etoile divi  

%start S
%%

S: idf accouv mc_var accouv LIST_DEC accfer mc_code accouv INSTRUCTION accfer accfer {printf("programme syntaxiquement correcte \n");                                                        
printf ("\n\n\t\t --------------------------- Fin de la compilation --------------------------- \n\n");YYACCEPT;}
;

// les déclaration

LIST_DEC : DEC pointvir LIST_DEC 
         | DEC pointvir 
         ;

DEC : D_VAR 
    | D_CST 
    | D_TAB  
    | STRUCT // not sure if this is the right place for this
;

D_VAR : TYPE LISTEIDF   {for(n=0;n<i;n++) {
                            if (doubleDeclaration(vars[n])==0) insererTYPE(vars[n],$1);
                            else  printf ("<< Erreur semantique ( Double déclaration ), ligne %d, colonne %d : %s >>\n",nbr,nbrC,vars[n]);
                          }
                          i=0;}
                          
;

D_TAB : TYPE idf crochet_ouv entier crochet_fer  {for(n=0;n<i;n++) {
                            if (doubleDeclaration(vars[n])==0) insererTYPE(vars[n],$1);
                            else  printf ("<< Erreur semantique ( Double declaration ), ligne %d, colonne %d : %s >>\n",nbr,nbrC,vars[n]);
                          }
                          i=0;}
      ;
D_CST : mc_const idf egale VAR { if (doubleDeclaration($2)==0) { insererTYPE($2,cstype);
                                                         insererCODE($2);
                                                         }
                        else printf ("<< Erreur semantique ( Double declaration ), ligne %d, colonne %d : %s >>\n",nbr,nbrC,$2);
                        }
         
      ; 

// Définition de la structure

STRUCT : mc_struct accouv LISTDEC accfer idf pointvir
       ;  

LISTDEC : TYPE idf pointvir LISTDEC  {for(n=0;n<i;n++) {
                            if (doubleDeclaration(vars[n])==0) insererTYPE(vars[n],$1);
                            else  printf ("<< Erreur semantique ( Double declaration ), ligne %d, colonne %d : %s >>\n",nbr,nbrC,vars[n]);
                          }
                          i=0;}
        | TYPE idf pointvir  {for(n=0;n<i;n++) {
                            if (doubleDeclaration(vars[n])==0) insererTYPE(vars[n],$1);
                            else  printf ("<< Erreur semantique ( Double déclaration ), ligne %d, colonne %d : %s >>\n",nbr,nbrC,vars[n]);
                          }
                          i=0;}
        ;


// les variables
VAR : entier  {strcpy(cstype,"INTEGER"); printf(buf,"%d",$1);  $$=buf;}
    | reel  {strcpy(cstype,"FLOAT"); sprintf(buf,"%f",$1);  $$=buf;}
    ;

TYPE : mc_int {$$="INTEGER";}
     | mc_float {$$="FLOAT";}
     | mc_struct {$$="STRUCT";} // for now struct need to change it later
     ; 

LISTEIDF: idf vir LISTEIDF  { strcpy(vars[i],$1); i++; } 
        | idf   { strcpy(vars[i],$1); i++; }
        ;

// opérateurs arithmétique 
OPA : plus
    | moins
    | etoile
    | divi
;

//opérateurs logique
OPL : et
    | ou
    | negation
;
//opérateurs de comparaision
OPC : sup
    | sup_egal
    | inegalite
    | double_egale
    | inf_egal
    | inf
;

 // les opérations arithmétique
OPERATION_AR : VALEUR OPA OPERATION_AR |  VALEUR
        ; 
        
VALEUR :  VAR | idf | parouv OPERATION_AR parferm
       ;


// les opérateurs 
OPERATEURS : OPL | OPC ;

 /* // boucle des opérations
OPERATIONS : OPERATEURS CONDITION
           | 
; */

 // les opérations de comparaision et logique
CONDITION : parouv EXP OPERATEURS EXP parferm 
           | parouv negation EXP parferm ;

// les expressions
EXP : CONDITION | OPERATION_AR; 

// les instructions
INSTRUCTION:  AFFECTATION INSTRUCTION
            | COND_IF INSTRUCTION 
            | BOUCLE_FOR INSTRUCTION
            | BOUCLE_WHILE INSTRUCTION
            | ;

AFFECTATION : idf egale EXP pointvir ;
COND_IF: mc_if EXP accouv INSTRUCTION accfer ELSE;

ELSE: mc_else accouv INSTRUCTION accfer | ;
// idk ida condition d'arret means a real condition or just an idf
BOUCLE_FOR : mc_for parouv idf deux_point entier deux_point  entier deux_point idf parferm accouv INSTRUCTION accfer;
BOUCLE_WHILE : mc_while CONDITION accouv INSTRUCTION accfer ; 
         

%%
int main()
{
    initialisation();
    printf ("\n\n\t\t --------------------------- Debut de la compilation --------------------------- \n\n");
    yyparse();
    afficher(0);
    afficher(1);
    afficher(2);
  
        /* for(i=1;i<j;i++) {
    for(n=1;n<j;n++) {
printf("hereeeeeee %c \n" ,vars[i][j]);}} */


    return 0;
} 
int yywrap(){ return 0;};   

int yyerror (char *msg ) { 
        printf ("Erreur syntaxique, ligne %d, nbrConne %d \n",nbr,nbrC); 
        return 1; }