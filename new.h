#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SIZE 100 
typedef struct elem {
    int state;
    char name[40];
    char type[40];
    char code[40];
    char val[40];
    
    struct elem* next;
} elem;

typedef struct uniteP{
	char* val;
	struct uniteP* svt;
}pile;
pile *tetePile;


// la table
elem* hashTable[SIZE];



// la fonction de hashage
unsigned int hash(char* name) {
    unsigned int hashValue = 0;
    unsigned int len = strlen(name);
    
    for (unsigned int i = 0; i < len; i++) {
        hashValue = hashValue * 31 + name[i];
    }
    
    return hashValue % SIZE;
}

void initialisation() {
    for (int i = 0; i < SIZE; i++) {
        hashTable[i] = NULL;
    }
}

// insertion
void inserer(char entite[], char code[], char type[], char val[]) {
    unsigned int index = hash(entite);
    
    elem* newEntry = (elem*)malloc(sizeof(elem));
    newEntry->state =1;
    strncpy(newEntry->name, entite, sizeof(newEntry->name));
    strncpy(newEntry->type, type, sizeof(newEntry->type));
    
    if (strcmp(code, "sep") == 0) {
        strncpy(newEntry->code, code, sizeof(newEntry->code));
        strncpy(newEntry->val, "", sizeof(newEntry->val));
    } else if (strcmp(code, "mot cle") == 0) {
        strncpy(newEntry->code, code, sizeof(newEntry->code));
        strncpy(newEntry->val, "", sizeof(newEntry->val));
    }
     else {
        strncpy(newEntry->code, code, sizeof(newEntry->code));
        strncpy(newEntry->val, val, sizeof(newEntry->val));
    }
    
    newEntry->next = NULL;
    
    // si la table est vide on insere le premier element
    if (hashTable[index] == NULL) {
        hashTable[index] = newEntry;
    } else {
        elem* current = hashTable[index];
                
        // Isertion a la fin
        current->next = newEntry;
    }
}


void rechercher(char entite[], char code[], char type[], char val[]) {
    unsigned int index = hash(entite);
    int found = 0;
    elem* current = hashTable[index];
    
    while (current != NULL) {
        if (strcmp(current->name, entite) == 0) {
            found = 1;
              if (strcmp(current->code, "mot cle") != 0 && strcmp(current->code, "sep") != 0 && strcmp(current->type,"") == 0)
                printf(" << Erreur semantique Double declaration %s \n",entite);
            break;
        }
        
        current = current->next;
    }
              
               if (!found)
        {
             inserer(entite,code,type,val);
            
        }

}


int doubleDeclaration(char* name) {
    unsigned int index = hash(name);
    elem* current = hashTable[index];
    
    // while (current != NULL) {
    //         if (strcmp(current->code, "mot cle") != 0 && strcmp(current->code, "sep") != 0 && strcmp(current->type,"") == 0)
    //         {
    //             printf("Erreur semantique Double declaration %s \n",name);
    //             return 0;
    //         }
    //     current = current->next;
    // }
    
    return -1;
}

void insererTYPE(char* name, char* type) {
    unsigned int index = hash(name);
    
    elem* current = hashTable[index];
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            // Entity found, update its type
            strncpy(current->type, type, sizeof(current->type));
            return;
        }
        current = current->next;
    }

}

// Update the code of an entity
void insererCODE(char* name, char* code) {
    unsigned int index = hash(name);
    elem* current = hashTable[index];
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            // Entity found, update its code
            strncpy(current->code, code, sizeof(current->code));
            return;
        }
        current = current->next;
    }
    
}

// fonction pour enlever les parantheses
void removePar (char entite[]) {
  if (entite[0]=='(') {
                  entite[0]=' ';
                  entite[strlen(entite)-1]=' ';
  }
}


void afficher(int choice)
{
  
    switch (choice)
    {
    case 0:
    {
        printf("\n\n\t\t\t/*************** Table des symboles des IDF & CST *************/\n\n");
        printf("_________________________________________________________________________________________\n");
        printf("\t|           Nom_Entite         |   Code_Entite    | Type_Entite | Val_Entite\n");
        printf("__________________________________________________________________________________________\n");
         for (int i = 0; i < SIZE; i++) {
        elem* temp = hashTable[i];
        while (temp != NULL)
        {
            if (strcmp(temp->code, "sep") != 0 && strcmp(temp->code, "mot cle") != 0)
            {
                printf("\t|          %10s           |%15s | %12s |%12s\n", temp->name, temp->code, temp->type, temp->val);
            }
            temp = temp->next;
        }  
        // printf("\n");
     }
        break;
    }




    case 1:
    {
        printf("\n\n\t\t\t/*************** Table des symboles des mots cle *************/\n\n");
        printf("_______________________________________________________\n");
        printf("\t| \t \t NomEntite | \t CodeEntite\n");
        printf("_______________________________________________________\n");
        for (int i = 0; i < SIZE; i++) {
        elem* temp = hashTable[i];
        while (temp != NULL)
        {
            if ((strcmp(temp->code, "mot cle") == 0))
            {
                printf("\t|%25s |\t%12s\n", temp->name, temp->code);
            }
            temp = temp->next;
        }
       
           }
        break;
     
    }
    case 2:
    {
        printf("\n\n\t\t\t/*************** Table des symboles des separateurs *************/\n\n");
        printf("__________________________________________________________\n");
        printf("\t|         NomEntite         |      CodeEntite      \t \n");
        printf("___________________________________________________________\n");
        for (int i = 0; i < SIZE; i++) {
        elem* temp = hashTable[i];
        while (temp != NULL)
        {
            if ((strcmp(temp->code, "sep") == 0))
            {
                printf("\t|         %10s         | %12s \t \n", temp->name, temp->code);
            }
            temp = temp->next;
        }
   
           }
        break ; 
         
    }
    }
}


// int recherche(char entite[]) {
//     unsigned int index = hash(entite);
//     int found = 0;
//     elem* current = hashTable[index];
    
//     while (current != NULL) {
//         if (strcmp(current->name, entite) == 0) {
//             found = 1;
//                 break;
//         }
        
//         current = current->next;
//     }
//     if (found==1) printf("fouuund--------------");
// return found;
// }

int nonDec (char* name)
{ 
    unsigned int index = hash(name);
    elem* current = hashTable[index];
    while (current != NULL) {
        if (strcmp(current->code, "mot cle") != 0 && strcmp(current->code, "sep") != 0) {
            if (strcmp(current->name,name)==0 && strcmp(current->type, "")==0) {
                printf(" IDF NON DECLARÉ ");
                return -1;
            }
        }
        current = current->next;
    }
    
    return 0;
}

int incomptabiliteType(int type1,int type2)
{
    if(type1!=type2)
    {
         printf("<< erreur semantique incompatibilite des types >>");
    }
    return type1;
}


void tailleFaux(int tailleTab)
{
    if(tailleTab<=0)
    {
        printf("erreur semantique la taille doit etre strictement positive"); 
    }
}


void divisionParZero(char* zero)
{
    if(strcmp(zero,"0")==0)
    {
       printf("erreur semantique divison par zero");
    }
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
