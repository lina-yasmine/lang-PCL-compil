%{

 #include<stdio.h>
 #include<stdlib.h>
 #include<string.h>

 int yylex();
 int yyerror(char* msg);
//  void initialisation();
//  void afficher();

%}


%token mc_int mc_float vir pointvir accfer accouv parferm parouv idf mc_if 
%token err entier reel mc_var mc_code mc_struct mc_const egale

%start S
%%

S: idf accouv mc_var accouv DEC accfer mc_code accouv INST accfer accfer {printf("programme syntaxiquement correcte \n"); YYACCEPT;}
;

DEC : TYPE LISTEIDF pointvir DEC 
    | ;
INST : mc_if parouv parferm 
    | ;
TYPE : mc_int 
     | mc_float 
     ; 
LISTEIDF: idf vir LISTEIDF 
        | idf
        ;
%%
int main()
{
    // initialisation();
    yyparse();
    // afficher();
    return 0;
} 
int yywrap(){ return 0;};   