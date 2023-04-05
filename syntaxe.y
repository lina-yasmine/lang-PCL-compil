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

S: idf accouv mc_var accouv DEC accfer mc_code accouv INST accfer accfer {printf("programme syntaxiquement correcte \n"); YYACCEPT;}
;

// les déclaration
DECLARATION:  DEC DECLARATION 
             |D_TAB DECLARATION
             |D_CST DECLARATION
             | ;

DEC : TYPE LISTEIDF pointvir DEC 
    | ;
D_TAB : TYPE idf crochet_ouv entier crochet_fer pointvir
      ;
D_CST  :  mc_const idf egale VAR pointvir
      ; 

STRUCT : mc_struct accouv LISTDEC accfer idf pointvir
       ;  

LISTDEC : TYPE idf pointvir LISTDEC
        | TYPE idf pointvir 
        ;

// les variables
VAR : entier
    | reel
    ;

INST : mc_if parouv parferm 
    | ;

TYPE : mc_int 
     | mc_float 
     | STRUCT 
     ; 

LISTEIDF: idf vir LISTEIDF 
        | idf
        ;

// opérateurs arithmétique sans la division , pour traiter le cas de division par 0 apart 
OPA : plus
    | moins
    | etoile
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
OPERATION_AR : VALEUR OPA OPERATION_AR | division |  VALEUR
        ; 
VALEUR :  VAR | idf 
       ;
 // la division 
division : VALEUR divi entier { if ($3==0) {printf("Erreur semantique, line %d, colonne %d : Division sur zéro \n\n", nb_ligne, nbrC);exit(-1);};}
         | VALEUR divi reel { if ($3==0.0) {printf("Erreur semantique, line %d, colonne %d : Division sur zéro \n\n", nb_ligne, nbrC);exit(-1);};}
         ; 
// les opérateurs 
OPERATEURS : OPL | OPC ;

 // boucle des opérations
OPERATIONS : CONDITION OPERATEURS OPERATIONS
               | CONDITION
;
 // les opérations de comparaision et logique
CONDITION : parouv EXP OPERATEURS EXP parferm
           | parouv negation EXP parferm ;

// les expressions
EXP : CONDITION| parouv OPERATION_AR parferm | OPERATION_AR; 

// les instructions
INSTRUCTION:  AFFECTATION INSTRUCTION
            | COND_IF INSTRUCTION 
            | BOUCLE_FOR INSTRUCTION
            | BOUCLE_WHILE INSTRUCTION
            | ;

AFFECTATION : idf egale EXP pointvir ;
COND_IF : mc_if accouv INSTRUCTION accfer mc_else accouv INSTRUCTION accfer;
// idk ida condition d'arret means a real condition or just an idf
BOUCLE_FOR : mc_for parouv idf deux_point entier deux_point idf parferm accouv INSTRUCTION accfer;  
BOUCLE_WHILE : mc_while CONDITION accouv INSTRUCTION accfer ; 
         

%%
int main()
{
    // initialisation();
    yyparse();
    // afficher();
    return 0;
} 
int yywrap(){ return 0;};   

int yyerror (char *msg ) { 
        printf ("Erreur syntaxique, ligne %d, colonne %d \n",nbr,nbrC); 
        return 1; }
