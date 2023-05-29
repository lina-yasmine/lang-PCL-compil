%{
 #include<stdio.h>
 #include<stdlib.h>
 #include<string.h>
 #include <stdbool.h>

 int i,indx;
 char *x;
 // elem* adr;
char* type="";
char* TYPESTRUCT="";
extern int nbr;
int nbrC=1;
int yylex();
int yyerror(char* msg);
void afficher();
void initialisation();
int doubleDeclaration(char entite[]);
int recherche(char entite[]);
void doubleDec(int rech);
void insererTYPE(char entite[], char type[]);
void insererCODE(char entite[]);
void inserer(char entite[], char code[], char type[], char val[]);


void initPile();
void empiler(char*);
char* depiler();
int pileVide();
void afficherPile();

%}

%union {
        int Tentier;
        float Treel;
        char* str;
}

%token <str>mc_int <str>mc_float vir pointvir accfer accouv parferm parouv <str>idf mc_if crochet_ouv crochet_fer
%token err mc_for mc_while mc_var mc_code <str>mc_struct mc_const egale plus moins etoile divi
%token sup_egal inf_egal inegalite sup inf double_egale negation et ou mc_else deux_point point
%token <Tentier>entier <Treel>reel
/* %type <str> TYPE VAR */

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
    | STRUCT
  
;

D_VAR : TYPE LISTEIDF 
  /* {                 
   while(!pileVide())
                    {
                      x=depiler();
                      if (doubleDeclaration(strdup($2))==0) 
                       {
                      insererTYPE(x,type);
                        }
                      else  printf ("<< Erreur semantique ( Double déclaration ), ligne %d, colonne %d : %s >>\n",nbr,nbrC,x);
                     }
                    type="";
                    x="";
 } */
;

D_TAB : TYPE idf crochet_ouv entier crochet_fer 
{empiler(strdup($2)); } 
;

D_CST : mc_const idf egale VAR 
    {
        empiler(strdup($2));
    }
      ; 

// Définition de la structure

STRUCT : mc_struct accouv LISTDEC accfer idf 
   {
        insererTYPE(strdup($5),"STRUCT");
   
    }
       ;  
// declaration d'une variable de type structure
// rahi m3a TYPE 
// utilisation d'une variable struct dans la partie code
Code_STRUCT : idf point idf;

LISTDEC : TYPE idf pointvir LISTDEC  
 {                 
   while(!pileVide())
                    {
                      x=depiler();
                      if (doubleDeclaration(strdup($2))==0) 
                       {
                      insererTYPE(x,type);
                        }
                      else  printf ("<< Erreur semantique ( Double déclaration ), ligne %d, colonne %d : %s >>\n",nbr,nbrC,x);
                     }
                    type="";
                    x="";
 }
        | TYPE idf pointvir   {                 
   while(!pileVide())
                    {
                      x=depiler();
                      if (doubleDeclaration(strdup($2))==0) 
                       {
                      printf ("<< Erreur semantique ( Double déclaration ), ligne %d, colonne %d : %s >>\n",nbr,nbrC,x);
                      
                        }
                      else   insererTYPE(x,type);
                     }
                    type="";
                    x="";
 }
      
        ;


// les variables
VAR : entier 
 /* {strcpy(type,"INTEGER"); } */
    | reel 
 /* {strcpy(type,"FLOAT");} */
    ;

TYPE : mc_int 
    {type="INTEGER";}
     | mc_float 
     {type="FLOAT";}
     | mc_struct 
     
     // for now struct need to change it later OR NOT IDK WE'll see 
     ; 

LISTEIDF: idf vir LISTEIDF  
        {empiler(strdup($1));} 
        | idf  
        {empiler(strdup($1));}
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
        
VALEUR :  VAR | IDF | parouv OPERATION_AR parferm 
       ;
IDF : Code_STRUCT
    | idf 

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

AFFECTATION : IDF egale EXP pointvir ;
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
    return 0;
} 
int yywrap(){ return 0;};   

int yyerror (char *msg ) { 
        printf ("Erreur syntaxique, ligne %d, nbrConne %d \n",nbr,nbrC); 
        return 1; }