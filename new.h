#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SIZE 100 // Size of the hash table

// Structure for the symbol table entry
typedef struct SymbolTableEntry {
    int state;
    char name[40];
    char type[40];
    union {
        char code[40];
        char val[40];
    };
    struct SymbolTableEntry* next;
} SymbolTableEntry;

// Hash table
SymbolTableEntry* hashTable[SIZE];

// Hash function
unsigned int hash(char* name) {
    unsigned int hashValue = 0;
    unsigned int len = strlen(name);
    
    for (unsigned int i = 0; i < len; i++) {
        hashValue = hashValue * 31 + name[i];
    }
    
    return hashValue % SIZE;
}

// Initialize the symbol table hash table
void initialisation() {
    for (int i = 0; i < SIZE; i++) {
        hashTable[i] = NULL;
    }
}

// Insert an entry into the symbol table
void inserer(char entite[], char code[], char type[], char val[]) {
    unsigned int index = hash(entite);
    
    // Create a new entry for the hash table
    SymbolTableEntry* newEntry = (SymbolTableEntry*)malloc(sizeof(SymbolTableEntry));
    newEntry->state =1;
    strncpy(newEntry->name, entite, sizeof(newEntry->name));
    strncpy(newEntry->type, type, sizeof(newEntry->type));
    
    if (strcmp(code, "sep") == 0) {
        strncpy(newEntry->type, code, sizeof(newEntry->code));
        strncpy(newEntry->val, "", sizeof(newEntry->val));
    } else if (strcmp(code, "mot cle") == 0) {
        strncpy(newEntry->type, code, sizeof(newEntry->code));
        strncpy(newEntry->val, "", sizeof(newEntry->val));
    }
     else {
        strncpy(newEntry->code, "", sizeof(newEntry->code));
        strncpy(newEntry->val, val, sizeof(newEntry->val));
    }
    
    newEntry->next = NULL;
    
    // If the bucket is empty, inserer the entry as the first element
    if (hashTable[index] == NULL) {
        hashTable[index] = newEntry;
    } else {
        // Traverse the linked list in the bucket
        SymbolTableEntry* current = hashTable[index];
        
        // Check if the entry already exists
        while (current->next != NULL) {
            if (strcmp(current->name, newEntry->name) == 0) {
                // Entry already exists, update its information
                current->state = newEntry->state;
                strncpy(current->type, newEntry->type, sizeof(newEntry->type));
                strncpy(current->code, newEntry->code, sizeof(newEntry->code));
                strncpy(current->val, newEntry->val, sizeof(newEntry->val));
                free(newEntry);
                return;
            }
            
            current = current->next;
        }
        
        // Insert the new entry at the end of the linked list
        current->next = newEntry;
    }
}

// Search for an entry in the symbol table
void rechercher(char entite[], char code[], char type[], char val[]) {
    unsigned int index = hash(entite);
    int found = 0;
    // Traverse the linked list in the bucket
    SymbolTableEntry* current = hashTable[index];
    
    // Search for the entry
    while (current != NULL) {
        if (strcmp(current->name, entite) == 0) {
            found = 1;
                break;
        }
        
        current = current->next;
    }
               if (!found)
        {
            inserer(entite,code,type,val);
  
        }

}





// // Check for double declaration of an entity
// int doubleDeclaration(char* name) {
//     unsigned int index = hash(name);
    
//     SymbolTableEntry* current = hashTable[index];
//     while (current != NULL) {
//         if (strcmp(current->name, name) == 0) {
//             // Entity found, check for double declaration
//             SymbolTableEntry* temp = current->next;
//             while (temp != NULL) {
//                 if (strcmp(current->type, "sep") != 0 && strcmp(current->type, "mot cle") != 0 && strcmp(temp->name, name) == 0) {
//                     // Double declaration found
//                     return 0;
//                 }
//                 temp = temp->next;
//             }
//             break;
//         }
//         current = current->next;
//     }
    
//     // No double declaration found
//     return -1;
// }

// Check for double declaration of an entity (excluding keywords and separators)
int doubleDeclaration(char* name) {
    unsigned int index = hash(name);
    
    SymbolTableEntry* current = hashTable[index];
    while (current != NULL) {
        if (strcmp(current->type, "mot cle") != 0 && strcmp(current->type, "sep") != 0) {
            if (strcmp(current->name, name) == 0) {
                // Entity found, double declaration
                return -1;
            }
        }
        current = current->next;
    }
    
    // No double declaration found
    return 0;
}


// Insert or update the type of an entity
void insererTYPE(char* name, char* type) {
    unsigned int index = hash(name);
    
    SymbolTableEntry* current = hashTable[index];
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            // Entity found, update its type
            strncpy(current->type, type, sizeof(current->type));
            return;
        }
        current = current->next;
    }
    
    // // Entity not found, insert a new entry with the given type
    // SymbolTableEntry* newEntry = (SymbolTableEntry*)malloc(sizeof(SymbolTableEntry));
    // newEntry->state = 1;
    // strncpy(newEntry->name, name, sizeof(newEntry->name));
    // strncpy(newEntry->type, type, sizeof(newEntry->type));
    // newEntry->next = hashTable[index];
    // hashTable[index] = newEntry;
}

// Update the code of an entity
void insererCODE(char* name, char* code) {
    unsigned int index = hash(name);
    
    SymbolTableEntry* current = hashTable[index];
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            // Entity found, update its code
            strncpy(current->type, code, sizeof(current->type));
            return;
        }
        current = current->next;
    }
    
    // // Entity not found, insert a new entry with the given code
    // SymbolTableEntry* newEntry = (SymbolTableEntry*)malloc(sizeof(SymbolTableEntry));
    // newEntry->state = 1; 
    // strncpy(newEntry->name, name, sizeof(newEntry->name));
    // strncpy(newEntry->code, code, sizeof(newEntry->code));
    // newEntry->next = hashTable[index];
    // hashTable[index] = newEntry;
}

void removePar (char entite[]) {

  if (entite[0]=='(') {
                  entite[0]=' ';
                  entite[strlen(entite)-1]=' ';
  }
}

// // Display entities in categories: keywords, separators, and identifiers
// void afficher1() {
//     printf("Keywords:\n");
//     for (int i = 0; i < SIZE; i++) {
//         SymbolTableEntry* current = hashTable[i];
//         while (current != NULL) {
//             if (strcmp(current->code, "mot cle") == 0) {
//                 printf("State: %d, Name: %s, Type: %s\n", current->state, current->name, current->type);
//             }
//             current = current->next;
//         }
//     }

//     printf("\nSeparators:\n");
//     for (int i = 0; i < SIZE; i++) {
//         SymbolTableEntry* current = hashTable[i];
//         while (current != NULL) {
//             if (strcmp(current->code, "sep") == 0) {
//                 printf("State: %d, Name: %s, Type: %s\n", current->state, current->name, current->type);
//             }
//             current = current->next;
//         }
//     }

//     printf("\nIdentifiers:\n");
//     for (int i = 0; i < SIZE; i++) {
//         SymbolTableEntry* current = hashTable[i];
//         while (current != NULL) {
//             if (strcmp(current->code, "sep")!=0 && (current->code, "mot cle")!=0){
//                 printf("State: %d, Name: %s, Type: %s, Code: %s, Value: %s\n", current->state, current->name, current->type, current->code, current->val);
//             }
//             current = current->next;
//         }
//     }
// }


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
        SymbolTableEntry* temp = hashTable[i];
        while (temp != NULL)
        {
            if (strcmp(temp->type, "sep") != 0 && strcmp(temp->type, "mot cle") != 0)
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
        printf("\t| \t \t NomEntite | \t TypeEntite\n");
        printf("_______________________________________________________\n");
        for (int i = 0; i < SIZE; i++) {
        SymbolTableEntry* temp = hashTable[i];
        while (temp != NULL)
        {
            if ((strcmp(temp->type, "mot cle") == 0))
            {
                printf("\t|%25s |\t%12s\n", temp->name, temp->type);
            }
            temp = temp->next;
        }
        // printf("\n");
           }
        break;
     
    }
    case 2:
    {
        printf("\n\n\t\t\t/*************** Table des symboles des separateurs *************/\n\n");
        printf("__________________________________________________________\n");
        printf("\t|         NomEntite         |      TypeEntite      \t \n");
        printf("___________________________________________________________\n");
        for (int i = 0; i < SIZE; i++) {
        SymbolTableEntry* temp = hashTable[i];
        while (temp != NULL)
        {
            if ((strcmp(temp->type, "sep") == 0))
            {
                printf("\t|         %10s         | %12s \t \n", temp->name, temp->type);
            }
            temp = temp->next;
        }
        // printf("\n");
           }
        break;
        
    }
    }
}