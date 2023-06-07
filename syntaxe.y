%{
 #include<stdio.h>
 #include<stdlib.h>
 #include<string.h>
 #include <stdbool.h>
 #include "var_stack.h"
 #include "state_stack.h"
 #include "quad.h"

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
int divisionParZero(char* zero);

char *get_val(char entite[]);

void initPile();
void empiler(char*);
char* depiler();
int pileVide();
void afficherPile();

void quadr(char opr[],char op1[],char op2[],char res[]);
void ajour_quad(int num_quad, int colon_quad, char val []);
void afficher_qdr();
void sauvegarder_qdr();
void copy_propagation();
void generate_code();
void optimiser_qdr();
void propagateExpression();
void propagateCopy();
void eliminateRedundancy();
void simplifyAlgebra();
void eliminateDeadCode();
 int Fin_if = 0, deb_else = 0, Fin, BorneSup, counter = 1, counter2 = 1;
    int qc = 0;
    char tmp[20], tmp2[20], tmp3[20], tmp4[20], tabName[20];
    int tmp_int;
    int state = 0;
    int isNewline = 0;

    char Types[100][20];
    int variables_counter = 0, variables_counter2 = 0;
    char sauvType[25], sauvType2[25];
    float savedVal;

    int isempty();
    int isfull();
    char* peek();
    char* pop();
    char push(char *data); 

%}

%union {
        char* str;
        int Tentier;
        float Treel;
      
}

%token <str>mc_int <str>mc_float vir pointvir accfer accouv parferm parouv <str>idf mc_if crochet_ouv crochet_fer
%token err mc_for mc_while mc_var mc_code <str>mc_struct mc_const egale plus moins etoile divi
%token sup_egal inf_egal inegalite sup inf double_egale negation et ou mc_else deux_point point
%token <Tentier>entier <Treel>reel
/* %type <str> TYPE VAR */
%type <str> D_CST
%type <Treel> VAR IDF
%type<Treel> EXP1 EXP2 VALEUR 
%type<Tentier> EXP_B COND COND1 COND2 COND3;


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

D_VAR : TYPE LISTEIDF    {                 
                            while(!pileVide())
                             {
                                x=depiler();
                                insererTYPE(x,type);
                                if (doubleDeclaration(x)==1) printf ("\n\n<< Erreur semantique ( Double déclaration ), ligne %d, colonne %d : %s >>\n\n",nbr,nbrC,x);
                             }
                           type="";
                           x="";

                          }
;

D_TAB : TYPE idf crochet_ouv entier crochet_fer {
  
                                                   empiler(strdup($2)); 
                                                   updateSTATE(strdup($2));
                                                   tailleFaux($4);

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

STRUCT : mc_struct accouv LISTDEC accfer idf {
                                                insererTYPE(strdup($5),"STRUCT");
                                                updateSTATE(strdup($5));
                                             }
;  

// declaration d'une variable de type structure
// rahi m3a TYPE 
// utilisation d'une variable struct dans la partie code
Code_STRUCT : idf point idf
                             { 
                               z =strdup($3);
                               push(strdup($3));
                               nbrAFF($3);
                               // empiler(strdup($3));
                               if (nonDec(strdup($3))==1) { printf ("\n\n << Erreur semantique ( non  déclaration ), ligne %d, colonne %d : %s >>\n\n",nbr,nbrC,$3); } 
                               if (nonDec(strdup($1))==1) { printf ("\n\n << Erreur semantique ( non  déclaration ), ligne %d, colonne %d : %s >>\n\n",nbr,nbrC,$1); }                       
                             }
;

LISTDEC : TYPE idf pointvir LISTDEC  {        
                                        while(!pileVide())
                                                         {
                                                           x=depiler();
                                                           insererTYPE(x,type);
                                                           if (doubleDeclaration(strdup($2))==1) printf ("\n\n << Erreur semantique ( Double déclaration ), ligne %d, colonne %d : %s >>\n\n",nbr,nbrC,x);
                                                           else updateSTATE(strdup($2));
                                                          }
                                                          
                                                         type="";
                                                         x="";
                                      }
| TYPE idf pointvir                   {   
                                        while(!pileVide())
                                                         {
                                                          x=depiler(); 
                                                          insererTYPE(x,type);
                                                          if (doubleDeclaration(strdup($2))==1) printf ("\n\n << Erreur semantique ( Double déclaration ), ligne %d, colonne %d : %s >>\n\n",nbr,nbrC,x);
                                                          else updateSTATE(strdup($2));
                                                         } 
                                                       
                                                        type="";
                                                        x="";
                                       }
;


// les variables
VAR : entier  {  
                 $$=$1;
                 sprintf(buf, "%d", $1);
                 val=buf;
                 push(buf);
                 empiler(buf);
                 type="INTEGER";
                 empiler(z );
                 z ="";

              }
            
| reel       {    
                $$=$1;
                sprintf(buf, "%f", $1); 
                val=buf;
                empiler(buf);
                push(buf);
                type="FLOAT";
                empiler(z );
                z ="";
              
             }

;

TYPE : mc_int 
    {type="INTEGER";}
     | mc_float 
     {type="FLOAT";}
     | mc_struct  
     ; 

LISTEIDF: idf vir LISTEIDF   {
          updateSTATE(strdup($1));
          empiler(strdup($1));} 
        | idf   {
          updateSTATE(strdup($1));
          empiler(strdup($1));}
        ;



EXP1: EXP1 plus EXP2 {
        $$ = $1 + $3;
        strcpy(tmp2, pop());
        strcpy(tmp, pop());
        sprintf(tmp4, "temp_var%d", counter);
        counter++;
        quadr("+", tmp, tmp2, tmp4);
        push(tmp4); 


    }
    | EXP1 moins EXP2 {
        $$ = $1 - $3;
        strcpy(tmp2, pop());
        strcpy(tmp, pop());
        sprintf(tmp4, "temp_var%d", counter);
        counter++;
        quadr("-", tmp, tmp2, tmp4);
        push(tmp4); 


    }
    | EXP2
;
EXP2: EXP2 etoile VALEUR {
        $$ = $1 * $3;
        strcpy(tmp2, pop());
        strcpy(tmp, pop());
        sprintf(tmp4, "temp_var%d", counter);
        counter++;
        quadr("*", tmp, tmp2, tmp4);
        push(tmp4); 
    }
    | EXP2 divi VALEUR {
       if ($3==0){ printf("\n\n    << erreur semantique divison par zero >> \n\n"); }
       else if ($3==0.0){ printf("\n\n    << erreur semantique divison par zero >> \n\n"); }
        else {
            $$ = $1 / $3;
            strcpy(tmp2, pop());
            strcpy(tmp, pop());
            sprintf(tmp4, "temp_var%d", counter);
            counter++;
            quadr("/", tmp, tmp2, tmp4);
            push(tmp4);
            }
    }
    | VALEUR    
;

VALEUR :  VAR | IDF | parouv EXP1 parferm 
       ;

IDF : Code_STRUCT
    | idf { 
                                     z =strdup($1);
           // nbrAFF($1);
           // empiler(strdup($1));
           push(strdup($1));
            if (nonDec(strdup($1))==1) { printf ("\n\n << Erreur semantique ( non  déclaration ), ligne %d, colonne %d : %s >>\n\n",nbr,nbrC,$1); } 
             else { 
                    if (strcmp(GetType($1),"FLOAT")==0)
                     { 
                      $$ = atof(get_val($1));
                      push($1);
                     }
                      else if (strcmp(GetType($1),"INTEGER")==0)
                       {
                         $$ = atoi(get_val($1));
                         push($1);
                       }
                   }
        //    printf("valeur de $$ : %f ----- ",$$);
           }


 // les opérations de comparaision et logique
CONDITION : parouv COND parferm ;


EXP_B : EXP1 sup EXP1 {
        pop(); pop();
        if ($1 > $3){
            $$ = 1;
            strcpy(tmp, "true");
        }
        else{
            $$ = 0;
            strcpy(tmp, "false");
        }
        push(tmp);
        sprintf(tmp4, "%f", $1); 
        sprintf(tmp3, "%f", $3); 
        quadr(">", tmp4, tmp3, tmp);
     }
     | EXP1 inf EXP1 {
        pop(); pop();
        if ($1 < $3){
            $$ = 1;
            strcpy(tmp, "true");
        }
        else{
            $$ = 0;
            strcpy(tmp, "false");
        }
        // push(tmp);
        sprintf(tmp4, "%f", $1); 
        sprintf(tmp3, "%f", $3); 
        quadr("<", tmp4, tmp3, tmp);
     }
     | EXP1 sup_egal EXP1 {
        pop(); pop();
        if ($1 >= $3){
            $$ = 1;
            strcpy(tmp, "true");
        }
        else{
            $$ = 0;
            strcpy(tmp, "false");
        }
        // push(tmp);
        sprintf(tmp4, "%f", $1); 
        sprintf(tmp3, "%f", $3); 
        quadr(">=", tmp4, tmp3, tmp);
     }
     | EXP1 inf_egal EXP1 {
        pop(); pop();
        if ($1 <= $3){
            $$ = 1;
            strcpy(tmp, "true");
        }
        else{
            $$ = 0;
            strcpy(tmp, "false");
        }
        // push(tmp);
        sprintf(tmp4, "%f", $1); 
        sprintf(tmp3, "%f", $3); 
        quadr("<=", tmp4, tmp3, tmp);
     }
     | EXP1 double_egale EXP1 {
        pop(); pop();
        if ($1 == $3){
            $$ = 1;
            strcpy(tmp, "true");
        }
        else{
            $$ = 0;
            strcpy(tmp, "false");
        }
        // push(tmp);
        sprintf(tmp4, "%f", $1); 
        sprintf(tmp3, "%f", $3); 
        quadr("==", tmp4, tmp3, tmp);
     }
     | EXP1 inegalite EXP1 {
        pop(); pop();
        if ($1 != $3){
            $$ = 1;
            strcpy(tmp, "true");
        }
        else{
            $$ = 0;
            strcpy(tmp, "false");
        }
        // push(tmp);
        sprintf(tmp4, "%f", $1); 
        sprintf(tmp3, "%f", $3); 
        quadr("!=", tmp4, tmp3, tmp);
     }
     | entier {
        if ($1 != 0){
            $$ = 1;
            strcpy(tmp, "true");
        }
        else{
            $$ = 0;
            strcpy(tmp, "false");
        }
        // push(tmp);
     }
     | reel {
        if ($1 != 0){
            $$ = 1;
            strcpy(tmp, "true");
        }
        else{
            $$ = 0;
            strcpy(tmp, "false");
        }
        // push(tmp);
     }
     | idf {
         if (!nonDec($1)){
            if (get_val($1) != 0){
                $$ = 1;
                strcpy(tmp, "true");
            }
            else{
                $$ = 0;
                strcpy(tmp, "false");
            }
            // push(tmp);
         }
         else {
             printf("Semantic Error, line %d, column %d, entite '%s' Not Declared\n", nbr, nbrC, $1);
         }
        //  if (nonDec(strdup($1))==1) { printf ("\n\n << Erreur semantique ( non  déclaration ), ligne %d, colonne %d : %s >>\n\n",nbr,nbrC,$1); } 
        //      else { 
        //             if (strcmp(GetType($1),"FLOAT")==0)
        //              { 
        //               $$ = atof(get_val($1));
        //               push($1);
        //              }
        //               else if (strcmp(GetType($1),"INTEGER")==0)
        //                {
        //                  $$ = atoi(get_val($1));
        //                  push($1);
        //                }
        //            }
     }
   
;

COND: COND ou COND1 {
        pop(); pop();
        if (($1 == 1) || ($3 == 1)){
            $$ = 1;
            strcpy(tmp, "true");
        }
        else{
            $$ = 0;
            strcpy(tmp, "false");
        }
        push(tmp);
    }
    | COND1
;
COND1: COND1 et COND2 {
        pop(); pop();
        if (($1 == 1) && ($3 == 1)){
            $$ = 1;
            strcpy(tmp, "true");
        }
        else{
            $$ = 0;
            strcpy(tmp, "false");
        }
        push(tmp);
     }
     | COND2
;

COND2: negation COND3 {
        pop();
        if ($2 == 1){
            $$ = 0;
            strcpy(tmp, "false");
        }
        else{
            $$ = 1;
            strcpy(tmp, "true");
        }
        push(tmp);
     }
     | COND3     
;

COND3: EXP_B { strcpy(sauvType, "NULL"); }
;


// les instructions
INSTRUCTION:  AFFECTATION INSTRUCTION
            | COND_IF INSTRUCTION 
            | BOUCLE_FOR INSTRUCTION
            | BOUCLE_WHILE INSTRUCTION
            | ;

AFFECTATION : IDF egale EXP1 pointvir 
                                       { 
                                         nbrAFF($2);
                                         x=depiler();
                                           //  si incompatibilité des type on print erreur sinon on insere la valeur
                                         if (nonDec(strdup(x))==0) 
                                         {
                                             if (strcmp(GetType(strdup(x)),type)!=0) printf("\n\n    << Erreur semantique ( incompatibilité de type ), ligne %d, colonne %d : %s >>\n\n",nbr,nbrC,x);
                                             else if (reaffectCst(strdup(x))==0) { insererVAL(x,val) ;}
                                                  else printf("\n\n   << Erreur semantique ( reaffectation d'une constante ), ligne %d, colonne %d : %s >>\n\n",nbr,nbrC,x);
                                         }
                                         sprintf(tmp3, "%f", $3);
                                         val=pop();
                                         type=pop(); 
                                        //  printf("\n\n type : %s \n\n",type);
                                         if (reaffectCst(strdup(type))==0) insererVAL(type,tmp3);
                                         quadr("=", tmp3, "Empty", type);
                                         push(val);
                                         val = "";
                                         type = "";
                                         
                                       }
;
COND_IF: mc_if CONDITION accouv INSTRUCTION accfer ELSE;


ELSE: mc_else accouv INSTRUCTION accfer | ;


BOUCLE_FOR : mc_for parouv idf deux_point entier deux_point  entier deux_point idf parferm accouv INSTRUCTION accfer
            { 
              if (nonDec(strdup($3))==1) { printf ("\n\n << Erreur semantique ( non  déclaration ), ligne %d, colonne %d : %s >>\n\n",nbr,nbrC,$3); }
              if (nonDec(strdup($9))==1) { printf ("\n\n << Erreur semantique ( non  déclaration ), ligne %d, colonne %d : %s >>\n\n",nbr,nbrC,$9); }
            }	
;
BOUCLE_WHILE : mc_while CONDITION accouv INSTRUCTION accfer ; 
         

%%
int main()
{
    initialisation();
    printf ("\n\n\t\t --------------------------- Debut de la compilation --------------------------- \n\n");
    yyparse();
    afficher();
    afficher_qdr(); 
    sauvegarder_qdr("quadruplets.txt");
    generate_code();  // gneration code machin
    propagateExpression(); // propagateExpression
    eliminateDeadCode(); // eliminateDeadCode
    eliminateRedundancy(); // eliminateRedundancy
    simplifyAlgebra();
    propagateCopy();
    printf(" |\t--------------------------------------------------------\n |");
    printf("\n |--------- Quadruplets apres l'optimisation\n");
    afficher_qdr();
    sauvegarder_qdr("quadruplets optimse.txt");

    return 0;
} 
int yywrap(){ return 0;};   

int yyerror (char *msg ) { 
        printf ("\n\n Erreur syntaxique, ligne %d, nbrConne %d \n\n",nbr,nbrC); 
        return 1; }