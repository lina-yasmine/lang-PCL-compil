#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SIZE 100

typedef struct element {
    int state;
    char name[20];
    char code[20];
    char type[20];
    char val[40];
    int nbrAff;
    struct element *next;
} element;

typedef struct sep {
    int state;
    char name[40];
    char type[25];
    struct sep *next;
} sep;

typedef struct mot_cle {
    int state;
    char name[40];
    char type[25];
    struct mot_cle *next;
} mot_cle;

typedef struct uniteP{
	char* val;
	struct uniteP* svt;
}pile;

pile *tetePile;

element* table[SIZE];
sep* sep_table[SIZE];
mot_cle* mot_cle_table[SIZE];

// Hash function
unsigned int hashage(char* name) {
    unsigned int hashValue = 0;
    unsigned int len = strlen(name);
    
    for (unsigned int i = 0; i < len; i++) {
        hashValue = hashValue * 31 + name[i];
    }
    
    return hashValue % SIZE;
}

void initialisation() {
    for (int i = 0; i < SIZE; i++) {
        table[i] = NULL;
        sep_table[i] = NULL;
        mot_cle_table[i] = NULL;
    }
}

// Step 3: Insert lexical entities into symbol tables
void inserer(char entite[], char code[], char type[], char val[], int y) {
    int hash = hashage(entite);

    switch (y) {
        case 0: // Insert into the IDF and CONST table
        {
            if (table[hash] == NULL) {
                element* newElement = (element *)malloc(sizeof(element));
                
                newElement->state = 0;
                strcpy(newElement->name, entite);
                strcpy(newElement->code, code);
                strcpy(newElement->type, type);
                strcpy(newElement->val, val);
                newElement->nbrAff=0;
                newElement->next = NULL;
                table[hash] = newElement;

            } else {
                // we have a collision
                element* elmC = table[hash];
                while (elmC->next != NULL) {
                    elmC = elmC->next;
                }
                element* newElement = (element *)malloc(sizeof(element));
               
                newElement->state = 0;
                strcpy(newElement->name, entite);
                strcpy(newElement->code, code);
                strcpy(newElement->type, type);
                strcpy(newElement->val, val);
                newElement->nbrAff=0;
                newElement->next = NULL;
                elmC->next = newElement;

            }
        }
        break;

        case 1: // Insert into the mot_cle table
        {
            if (mot_cle_table[hash] == NULL) {
                mot_cle* newmot_cle = (mot_cle *)malloc(sizeof(mot_cle));
               
                newmot_cle->state = 1;
                strcpy(newmot_cle->name, entite);
                strcpy(newmot_cle->type, code);
                newmot_cle->next = NULL;
                mot_cle_table[hash] = newmot_cle;

            } else {
                mot_cle* currmot_cle = mot_cle_table[hash];
                while (currmot_cle->next != NULL) {
                    currmot_cle = currmot_cle->next;
                }
                mot_cle* newmot_cle = (mot_cle *)malloc(sizeof(mot_cle));

                newmot_cle->state = 1;
                strcpy(newmot_cle->name, entite);
                strcpy(newmot_cle->type, code);
                newmot_cle->next = NULL;
                currmot_cle->next = newmot_cle;

            }
        }
        break;

        case 2: // Insert into the sep table
        {
            if (sep_table[hash] == NULL) {
                sep* newsep = (sep *)malloc(sizeof(sep));
               
                newsep->state = 1;
                strcpy(newsep->name, entite);
                strcpy(newsep->type, code);
                newsep->next = NULL;
                sep_table[hash] = newsep;

            } else {
                sep* currsep = sep_table[hash];
                while (currsep->next != NULL) {
                    currsep = currsep->next;
                }
                sep* newsep = (sep *)malloc(sizeof(sep));
               
                newsep->state = 1;
                strcpy(newsep->name, entite);
                strcpy(newsep->type, code);
                newsep->next = NULL;
                currsep->next = newsep;
            }
        }
        break;
    }
}
void rechercher(char entite[], char code[], char type[], char val[], int y) {
    int hash = hashage(entite);
    int trouve = 0;

    switch (y) {
        case 0: // Check if the entry in IDF and CONST tables is free
        {
            if (table[hash] == NULL) {
                inserer(entite, code, type, val, 0);
            } else {
                // Check if the entry at the hash index in IDF and CONST tables has the same entity
                element* elmC = table[hash];
                while (elmC != NULL) {
                    if (strcmp(elmC->name, entite) == 0) {
                        trouve = 1;
                        break;
                    }
                    elmC = elmC->next;
                }
                if (trouve == 0) {
                    inserer(entite, code, type, val, 0);
                }
            }
        }
        break;

        case 1: // Check if the entry in the mot_cle table is free
        {
            if (mot_cle_table[hash] == NULL) {
                inserer(entite, code, type, val, 1);
            } else {
                // Check if the entry at the hash index in the mot_cle table has the same entity
                mot_cle* currmot_cle = mot_cle_table[hash];
                while (currmot_cle != NULL) {
                    if (strcmp(currmot_cle->name, entite) == 0) {
                        trouve = 1;
                        break;
                    }
                    currmot_cle = currmot_cle->next;
                }
                if (trouve == 0) {
                    inserer(entite, code, type, val, 1);
                }
            }
        }
        break;

        case 2: // Check if the entry in the sep table is free
        {
            if (sep_table[hash] == NULL) {
                inserer(entite, code, type, val, 2);
            } else {
                // Check if the entry at the hash index in the sep table has the same entity
                sep* currsep = sep_table[hash];
                while (currsep != NULL) {
                    if (strcmp(currsep->name, entite) == 0) {
                        trouve = 1;
                        break;
                    }
                    currsep = currsep->next;
                }
                if (trouve == 0) {
                    inserer(entite, code, type, val, 2);
                }
            }
        }
        break;
    }
}

void afficher() {

    printf("\n\n\t/***************\tTable des symboles des IDF & CST\t*************/\n\n");
    printf("____________________________________________________________________\n");
    printf("\t Nom_Entite |  Code_Entite   |  Type_Entite | Val_Entite\n");
    printf("____________________________________________________________________\n");

    for (int i = 0; i < SIZE; i++) {
        element* elmC = table[i];
        while (elmC != NULL) {
            if (elmC->state == 1) {
                if (strcmp(elmC->type, "FLOAT") != 0 && strcmp(elmC->type, "INTEGER") != 0) {
                    printf(" %18s |%15s | %12s |              |  \n", elmC->name, elmC->code, elmC->type);
                } else {
                    printf(" %18s |%15s | %12s | %12s |\n", elmC->name, elmC->code, elmC->type, elmC->val);
                }
            }
            elmC = elmC->next;
        }
    }

    printf("\n\n\t/***************\tTable des symboles des mots cle\t*************/\n\n");
    printf("___________________________________________________________\n");
    printf("\t\t NomEntite             |  CodeEntite       | \n");
    printf("___________________________________________________________\n");

    // Traverse the mot_cle table
    for (int i = 0; i < SIZE; i++) {
        mot_cle* currmot_cle = mot_cle_table[i];
        while (currmot_cle != NULL) {
            if (currmot_cle->state == 1) {
                printf("%27s            |    %12s   | \n", currmot_cle->name, currmot_cle->type);
            }
            currmot_cle = currmot_cle->next;
        }
    }

    printf("\n\n\t/***************\tTable des symboles des separateurs\t*************/\n\n");
    printf("_____________________________________\n");
    printf("\t| NomEntite |  CodeEntite | \n");
    printf("_____________________________________\n");

    // Traverse the sep table
    for (int i = 0; i < SIZE; i++) {
        sep* currsep = sep_table[i];
        while (currsep != NULL) {
            if (currsep->state == 1) {
               
                        printf("\t|%10s |%12s | \n", currsep->name, currsep->type);
                   
            }
            currsep = currsep->next;
        }
    }
}

// fonction pour enlever les parantheses
void removePar (char entite[]) {
  if (entite[0]=='(') {
                  entite[0]=' ';
                  entite[strlen(entite)-1]=' ';
  }
}

void insererTYPE(char entite[], char type[])
{
    int hash = hashage(entite);
    int trouve = 0;
    if (table[hash] != NULL) {
        element* elmC = table[hash];
        while (elmC != NULL && trouve == 0) {
            if (strcmp(elmC->name, entite) == 0) {
                trouve = 1;
                strcpy(elmC->type, type);
            }    
        }
    }

}

char *GetType(char entite[])
{
    int hash = hashage(entite);
    if (table[hash] != NULL) {
        element* elmC = table[hash];
        while (elmC != NULL) {
            if (strcmp(elmC->name, entite) == 0) {
                return elmC->type;
            }    
        }
    }
    return "";
}

char *get_val(char entite[])
{
    int hash = hashage(entite);
    if (table[hash] != NULL) {
        element* elmC = table[hash];
        while (elmC != NULL) {
            if (strcmp(elmC->name, entite) == 0) {
                return elmC->val;
            }    
        }
    }
    return "";
}




// la pile c'est pour empiler et depiler les elements f syntaxique
void initPile()
{
	tetePile=NULL;
}

void empiler(char *x)
{
	pile *e=(pile*)malloc(sizeof(pile));
	e->val=strdup(x);
	e->svt=tetePile;
	tetePile=e;	
}

char* depiler()
{
	char *x;
	pile *e;
	if(tetePile!=NULL)
	{
		x=strdup((tetePile)->val);
		e=tetePile;
		tetePile=(tetePile)->svt;
		free(e);
		return x;		
	}
	else
	{
		return NULL;
	}	
}

int pileVide()
{
	if(tetePile==NULL) return 1;
	return 0;	
}

void afficherPile()
{
 	pile* t=tetePile;
	while(t!=NULL)
	{
		printf("%s\n",t->val);
		t=t->svt;
	}   
}

int nonDec (char* name)
{ 
       unsigned int index = hashage(name);
    element* current = table[index];
    
    while (current != NULL) {
          if (strcmp(current->name, name) == 0) {
                if (current->state == 0)
                {
                    // variable non déclarée
                    return 1;
                }
                else
                {
                    // variable déclarée
                    return 0;
                }     
            }  
        current = current->next;
    }
    
    return -1;
   
}

int doubleDeclaration(char* name) {
      int hash = hashage(name);
        element* elmC = table[hash];
        while (elmC != NULL) {
        if (strcmp(elmC->name, name) == 0 && elmC->state == 1) {
            // double declaration
            // printf("Erreur: %s est deja declaree-------------------\n", name);
            return 0;
            }    
        }
    
    return 0;
}

// Update the state to 1 ki ndeclariw une variable
void updateSTATE(char* name) {
    unsigned int index = hashage(name);
    element* current = table[index];
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            // Entity found, update its state
            current->state=1;
            return;
        }
        current = current->next;
    }
    
}

// Update the code of an entity
void insererCODE(char* name) {
    unsigned int index = hashage(name);
    element* current = table[index];
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            // Entity found, update its code
            strncpy(current->code,"CONST", sizeof(current->code));
            return;
        }
        current = current->next;
    }
    
}

// Update la valeur
void insererVAL(char* name , char* val) {
    unsigned int index = hashage(name);
    element* current = table[index];
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            strncpy(current->val, val , sizeof(current->val));
            return;
        }
        current = current->next;
    }
    
}

void tailleFaux(int tailleTab)
{
    if(tailleTab<=0)
    {
        printf("\n\n << erreur semantique la taille d'un tableau doit etre strictement positive >>\n\n "); 
    }
}


void divisionParZero(char* zero)
{
    if(strcmp(zero,"0")==0 || strcmp(zero,"0.0")==0 )
    {
       printf("\n\n    << erreur semantique divison par zero >> \n\n");
    }
}

int incomptabiliteType(int type1,int type2)
{
    if(type1!=type2)
    {
        return 1;
    }
    return 0;
}

void nbrAFF(char* name) {
    unsigned int index = hashage(name);
    element* current = table[index];
    
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            current->nbrAff++;
        }
        current = current->next;
    }
    
}

int reaffectCst(char* name )
{

   unsigned int index = hashage(name);
    element* current = table[index];
    while (current != NULL) {
        if (strcmp(current->name, name) == 0 && strcmp(current->code,"CONST")==0) {
            if (current->nbrAff>1)
            {
                return 1;
                printf("\n\n<< erreur semantique reaffectation d'une constante >> \n\n");
            }
        }
        current = current->next;
    }
  return 0;
}

