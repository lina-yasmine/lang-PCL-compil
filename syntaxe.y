%{

 #include<stdio.h>
 #include<stdlib.h>
 #include<string.h>

extern int nbr;
int nbrC=1;
int yylex();
int yyerror(char* msg);
//  void initialisation();
//  void afficher();

%}

%union {
        int Tentier;
        float Treel;
}

%token mc_int mc_float vir pointvir accfer accouv parferm parouv idf mc_if crochet_ouv crochet_fer
%token err mc_for mc_while mc_var mc_code mc_struct mc_const egale plus moins etoile divi
%token sup_egal inf_egal inegalite sup inf double_egale negation et ou mc_else deux_point
%token <Tentier> entier <Treel> reel

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
;

D_VAR : TYPE LISTEIDF 
    
      ;

D_TAB : TYPE idf crochet_ouv entier crochet_fer 
         
      ;
D_CST : mc_const idf egale VAR 
         
      ; 

// Définition de la structure

STRUCT : mc_struct accouv LISTDEC accfer idf pointvir
       ;  

LISTDEC : TYPE idf pointvir LISTDEC
        | TYPE idf pointvir 
        ;


// les variables
VAR : entier
    | reel
    ;

TYPE : mc_int 
     | mc_float 
     | STRUCT 
     ; 

LISTEIDF: idf vir LISTEIDF 
        | idf
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
    // initialisation();
    printf ("\n\n\t\t --------------------------- Debut de la compilation --------------------------- \n\n");
    yyparse();
    // afficher();
    return 0;
} 
int yywrap(){ return 0;};   

int yyerror (char *msg ) { 
        printf ("Erreur syntaxique, ligne %d, colonne %d \n",nbr,nbrC); 
        return 1; }