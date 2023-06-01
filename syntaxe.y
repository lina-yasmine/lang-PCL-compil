%{
 #include<stdio.h>
 #include<stdlib.h>
 #include<string.h>
 #include <stdbool.h>

 int i,indx;
 char *x;
char *y = "";
char *z = "";
char* type="";
char* val="";
char buf[25];
char* TYPESTRUCT="";
extern int nbr;
int nbrC=1;
int yylex();
int yyerror(char* msg);
int nonDec (char* name);
void insererVAL(char* name , char* val);
void updateSTATE(char* name);
void afficher();
void initialisation();
int doubleDeclaration(char entite[]);
int recherche(char entite[]);
void doubleDec(int rech);
void insererTYPE(char entite[], char type[]);
void insererCODE(char* name);
void inserer(char entite[], char code[], char type[], char val[]);
char *GetType(char entite[]);
void tailleFaux(int tailleTab);
void nbrAFF(char* name);
int reaffectCst(char* name );
void divisionParZero(char* zero);
void divisionParZeroF(float zero);

void initPile();
void empiler(char*);
char* depiler();
int pileVide();
void afficherPile();

%}

%union {
        char* str;
        struct { char* type; int Tentier; float Treel; }NT;
}

%token <str>mc_int <str>mc_float vir pointvir accfer accouv parferm parouv <str>idf mc_if crochet_ouv crochet_fer
%token err mc_for mc_while mc_var mc_code <str>mc_struct mc_const egale plus moins etoile divi
%token sup_egal inf_egal inegalite sup inf double_egale negation et ou mc_else deux_point point
%token <NT>entier <NT>reel
/* %type <str> TYPE VAR */
%type <str> D_CST
%type <NT> VAR OPERATION_AR
// Les prioritées 
%left          et                
%left          ou         
%left     sup sup_egal double_egale  inegalite inf_egal inf             
%left     plus moins           
%left     etoile divi  

%start S
%%

S: idf accouv mc_var accouv LIST_DEC accfer mc_code accouv INSTRUCTION accfer accfer {
  updateSTATE(strdup($1));
  insererTYPE(strdup($1),"NomPROG");
  printf("programme syntaxiquement correcte \n");                                                        
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
  {                 
   while(!pileVide())
                    {
                      x=depiler();
                     insererTYPE(x,type);
                      if (doubleDeclaration(x)==1) 
                     printf ("<< Erreur semantique ( Double déclaration ), ligne %d, colonne %d : %s >>\n",nbr,nbrC,x);
                     }
                    type="";
                    x="";
 }
;

D_TAB : TYPE idf crochet_ouv entier crochet_fer 
{
 empiler(strdup($2)); 
 updateSTATE(strdup($2));
 tailleFaux($4.Tentier);
 } 

;

D_CST : mc_const idf egale VAR 
    { 
        empiler(strdup($2));
        updateSTATE(strdup($2));
        insererCODE(strdup($2));
        insererVAL(strdup($2),strdup(val));
        val = "";
        nbrAFF($2);
    }
      ; 

// Définition de la structure

STRUCT : mc_struct accouv LISTDEC accfer idf 
   {
        insererTYPE(strdup($5),"STRUCT");
        updateSTATE(strdup($5));

   
    }
       ;  
// declaration d'une variable de type structure
// rahi m3a TYPE 
// utilisation d'une variable struct dans la partie code
Code_STRUCT : idf point idf
{  
  // empiler(strdup($3));
  if (nonDec(strdup($3))==1) {
     printf ("<< Erreur semantique ( non  déclaration ), ligne %d, colonne %d : %s >>\n",nbr,nbrC,$3);
                       } 
  if (nonDec(strdup($1))==1) {
     printf ("<< Erreur semantique ( non  déclaration ), ligne %d, colonne %d : %s >>\n",nbr,nbrC,$1);
                       }                       
                    }
;

LISTDEC : TYPE idf pointvir LISTDEC  
 {        
        
   while(!pileVide())
                    {
                      x=depiler();
                      insererTYPE(x,type);
                      if (doubleDeclaration(strdup($2))==1) 
                       printf ("<< Erreur semantique ( Double déclaration ), ligne %d, colonne %d : %s >>\n",nbr,nbrC,x);
                      else updateSTATE(strdup($2));
                     }
                     
                    type="";
                    x="";
 }
        | TYPE idf pointvir   {   
      
   while(!pileVide())
                    {
                      x=depiler(); 
                      insererTYPE(x,type);
                      if (doubleDeclaration(strdup($2))==1) 
                        printf ("<< Erreur semantique ( Double déclaration ), ligne %d, colonne %d : %s >>\n",nbr,nbrC,x);
                         
                      else updateSTATE(strdup($2));
                     } 
                   
                    type="";
                    x="";
 }
      
        ;


// les variables
VAR : entier 
  {  
  

     $$.type="INTEGER";
     $$.Tentier=$1.Tentier;
     sprintf(buf, "%d", $1.Tentier);
     val=buf;
     empiler(buf);
     type="INTEGER";
     empiler($1.type);
    //  printf("IM STORING ____________type : %s \n", $$.type);
    //  printf("IM STORING ____________val : %s \n", buf);
     }

    | reel 
  {   
    
    $$.type="FLOAT";
    $$.Treel=$1.Treel;
    sprintf(buf, "%f", $1.Treel); 
    val=buf;
    empiler(buf);
    type="FLOAT";
    empiler($1.type);
    // printf("IM STORING ____________type : %s \n", $$.type);
    // printf("IM STORING ____________val : %s \n", buf);
   
    
    }

    ;

TYPE : mc_int 
    {type="INTEGER";}
     | mc_float 
     {type="FLOAT";}
     | mc_struct 
     
     // for now struct need to change it later OR NOT IDK WE'll see 
     ; 

LISTEIDF: idf vir LISTEIDF  
        {
          updateSTATE(strdup($1));
          empiler(strdup($1));} 
        | idf  
        {
          updateSTATE(strdup($1));
          empiler(strdup($1));}
        ;

// opérateurs arithmétique 
/* OPA : plus
    | moins
    | etoile
    | divi
; */

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
OPERATION_AR : VALEUR plus OPERATION_AR 
| VALEUR moins OPERATION_AR
| VALEUR etoile OPERATION_AR
| VALEUR divi OPERATION_AR { sprintf(buf, "%d", $3.Tentier); divisionParZero(buf); }
|  VALEUR
        ; 
        
VALEUR :  VAR | IDF | parouv OPERATION_AR parferm 
       ;
IDF : Code_STRUCT
    | idf { 
      // empiler(strdup($1));
      if (nonDec(strdup($1))==1) {
     printf ("<< Erreur semantique ( non  déclaration ), ligne %d, colonne %d : %s >>\n",nbr,nbrC,$1);
                       } 
                    }

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

AFFECTATION : IDF egale EXP pointvir 
{ 
  nbrAFF($2);
  x=depiler();
  if (nonDec(strdup(x))==0) 
   {
    // si incompatibilité des type on print erreur sinon on insere la valeur
      if (strcmp(GetType(strdup(x)),type)!=0)
                printf("    << Erreur semantique ( incompatibilité de type ), ligne %d, colonne %d : %s >>\n",nbr,nbrC,x);
      else if (reaffectCst(strdup(x))==0) insererVAL(x,val) ; else printf("   << Erreur semantique ( reaffectation d'une constante ), ligne %d, colonne %d : %s >>\n",nbr,nbrC,x);
 }
  val = "";
  type = "";
  
};
COND_IF: mc_if EXP accouv INSTRUCTION accfer ELSE;

ELSE: mc_else accouv INSTRUCTION accfer | ;
// idk ida condition d'arret means a real condition or just an idf
BOUCLE_FOR : mc_for parouv idf deux_point entier deux_point  entier deux_point idf parferm accouv INSTRUCTION accfer
{ if (nonDec(strdup($3))==1) {
	                                                                                                                   printf ("<< Erreur semantique ( non  déclaration ), ligne %d, colonne %d : %s >>\n",nbr,nbrC,$3);
                                                                                                                    }
																													 if (nonDec(strdup($9))==1) {
	                                                                                                                   printf ("<< Erreur semantique ( non  déclaration ), ligne %d, colonne %d : %s >>\n",nbr,nbrC,$9);
                                                                                                                    }
                                                                                                                    }	;
BOUCLE_WHILE : mc_while CONDITION accouv INSTRUCTION accfer ; 
         

%%
int main()
{
    initialisation();
    printf ("\n\n\t\t --------------------------- Debut de la compilation --------------------------- \n\n");
    yyparse();
    afficher();
    return 0;
} 
int yywrap(){ return 0;};   

int yyerror (char *msg ) { 
        printf ("Erreur syntaxique, ligne %d, nbrConne %d \n",nbr,nbrC); 
        return 1; }