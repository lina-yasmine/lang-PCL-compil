%{

 #include<stdio.h>
 #include<stdlib.h>
 #include<string.h>

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
OPER_AR : VALEUR OPA OPER_AR | division |  VALEUR
        ; 
VALEUR :  VAR | idf 
       ;
 // la division 
division : VALEUR divi entier { if ($3==0) {printf("Erreur semantique, line %d, colonne %d : Division sur zéro \n\n", nb_ligne, nb_col);exit(-1);};}
         | VALEUR divi reel { if ($3==0.0) {printf("Erreur semantique, line %d, colonne %d : Division sur zéro \n\n", nb_ligne, nb_col);exit(-1);};}
         ; 
// les opérateurs 
OPERATEURS : OPL | OPC ;

 // boucle des opérations
OPERATIONS : OPERATION OPERATEURS OPERATIONS
               | OPERATION
;
 // les opérations de comparaision et logique
OPERATION : parouv EXP OPERATEURS EXP parferm
           | parouv negation EXP parferm ;

// j'ai pas encore fait expression normalment fiha les conditions
EXP : ;
         

%%
int main()
{
    // initialisation();
    yyparse();
    // afficher();
    return 0;
} 
int yywrap(){ return 0;};   