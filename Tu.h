#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct var_cst
{
    int state;
    char name[40];
    char code[40];
    char type[40];
    char val[40];
    struct var_cst* next;
} var_cst;


typedef struct MC_sep
{
    int state;
    char name[40];
    char type[30];
    struct MC_sep* next;
} MC_sep;

var_cst* tab1 = NULL;
MC_sep* tab2 = NULL;
MC_sep* tab3 = NULL;
char sav[20];
int Recherche_position(char entite[]) ;
void initialisation()
{
    tab1 = NULL;
    tab2 = NULL;
    tab3 = NULL;
}

void inserer(char entite[], char code[], char type[], char val[], int choice)
{
    switch (choice)
    {
    case 0:
    {
        var_cst* new_var_cst = (var_cst*)malloc(sizeof(var_cst));
        new_var_cst->state = 1;
        strcpy(new_var_cst->name, entite);
        strcpy(new_var_cst->code, code);
        strcpy(new_var_cst->type, type);
        strcpy(new_var_cst->val, val);
        new_var_cst->next = tab1;
        tab1 = new_var_cst;
        break;
    }
    case 1:
    {
        MC_sep* new_tab3 = (MC_sep*)malloc(sizeof(MC_sep));
        new_tab3->state = 1;
        strcpy(new_tab3->name, entite);
        strcpy(new_tab3->type, code);
        new_tab3->next = tab3;
        tab3 = new_tab3;
        break;
    }
    case 2:
    {
        MC_sep* new_tab2 = (MC_sep*)malloc(sizeof(MC_sep));
        new_tab2->state = 1;
        strcpy(new_tab2->name, entite);
        strcpy(new_tab2->type, code);
        new_tab2->next = tab2;
        tab2 = new_tab2;
        break;
    }
    }
}


void rechercher(char entite[], char code[], char type[], char val[], int choice)
{
    int found = 0;
    switch (choice)
    {
    case 0:
    {
        var_cst* temp = tab1;
        while (temp != NULL)
        {
            if (strcmp(entite, temp->name) == 0)
            {
                found = 1;
                break;
            }
            temp = temp->next;
        }
        if (!found)
        {
            var_cst* new_var_cst = (var_cst*)malloc(sizeof(var_cst));
            new_var_cst->state = 1;
            strcpy(new_var_cst->name, entite);
            strcpy(new_var_cst->code, code);
            strcpy(new_var_cst->type, type);
            strcpy(new_var_cst->val, val);
            new_var_cst->next = tab1;
            tab1 = new_var_cst;
        }
        break;
    }
    case 1:
    {
        MC_sep* temp = tab3;
        while (temp != NULL)
        {
            if (strcmp(entite, temp->name) == 0)
            {
                found = 1;
                break;
            }
            temp = temp->next;
        }
        if (!found)
        {
            MC_sep* new_tab3 = (MC_sep*)malloc(sizeof(MC_sep));
            new_tab3->state = 1;
            strcpy(new_tab3->name, entite);
            strcpy(new_tab3->type, code);
            new_tab3->next = tab3;
            tab3 = new_tab3;
        }
        break;
    }
    case 2:
    {
        MC_sep* temp = tab2;
        while (temp != NULL)
        {
            if (strcmp(entite, temp->name) == 0)
            {
                found = 1;
                break;
            }
            temp = temp->next;
        }
        if (!found)
        {
            MC_sep* new_tab2 = (MC_sep*)malloc(sizeof(MC_sep));
            new_tab2->state = 1;
            strcpy(new_tab2->name, entite);
            strcpy(new_tab2->type, code);
            new_tab2->next = tab2;
            tab2 = new_tab2;
        }
        break;
    }
    }
}

void afficher(int choice)
{
    switch (choice)
    {
    case 0:
    {
        var_cst* temp = tab1;
        printf("\n\n\t\t\t/*************** Table des symboles des IDF & CST *************/\n\n");
        printf("_________________________________________________________________________________________\n");
        printf("\t|           Nom_Entite         |   Code_Entite    | Type_Entite | Val_Entite\n");
        printf("__________________________________________________________________________________________\n");
        while (temp != NULL)
        {
            if (temp->state == 1)
            {
                printf("\t|          %10s           |%15s | %12s |%12s\n", temp->name, temp->code, temp->type, temp->val);
            }
            temp = temp->next;
        }
        printf("\n");
        break;
    }
    case 1:
    {
        MC_sep* temp = tab3;
        printf("\n\n\t\t\t/*************** Table des symboles des mots cle *************/\n\n");
        printf("_______________________________________________________\n");
        printf("\t| \t \t NomEntite | \t CodeEntite\n");
        printf("_______________________________________________________\n");
        while (temp != NULL)
        {
            if (temp->state == 1)
            {
                printf("\t|%25s |\t%12s\n", temp->name, temp->type);
            }
            temp = temp->next;
        }
        printf("\n");
        break;
    }
    case 2:
    {
        MC_sep* temp = tab2;
        printf("\n\n\t\t\t/*************** Table des symboles des separateurs *************/\n\n");
        printf("__________________________________________________________\n");
        printf("\t|         NomEntite         |      CodeEntite      \t \n");
        printf("___________________________________________________________\n");
        while (temp != NULL)
        {
            if (temp->state == 1)
            {
                printf("\t|         %10s         | %12s \t \n", temp->name, temp->type);
            }
            temp = temp->next;
        }
        printf("\n");
        break;
    }
    }
}

// int Recherche_position(char entite[])
// {
//     var_cst* temp = tab1;
//     int i = 0;
//     while (temp != NULL)
//     {
//         if (temp->state == 1 && strcmp(entite, temp->name) == 0)
//         {
//             return i;
//         }
//         temp = temp->next;
//         i++;
//     }

//     return -1;
// }

char* recherche_val(char entite[])
{
    var_cst* temp = tab1;
    int x = Recherche_position(entite);
    if (x == -1)
    {
        printf("Entite n'existe pas dans la TS\n");
        return "";
    }

    return temp->val;
}

float recheche_val(char entite[])
{
    var_cst* temp = tab1;
    int x = Recherche_position(entite);
    if (x == -1)
    {
        printf("Entite n'existe pas dans la TS\n");
        return -1;
    }

    return atof(temp->val);
}

// void modifier_val(char entite[], char val[])
// {
//     var_cst* temp = tab1;
//     int x = Recherche_position(entite);
//     if (x == -1)
//     {
//         printf("Entite n'existe pas dans la TS\n");
//     }
//     else
//     {
//         strcpy(temp->val, val);
//     }
// }


void modifier_val(char entite[], char val[])
{
    var_cst* temp = tab1;
    int x = Recherche_position(entite);
    if (x == -1)
    {
        printf("Entite n'existe pas dans la TS\n");
    }
    else
    {
        for (int i = 0; i < x; i++)
        {
            temp = temp->next;
        }
        strcpy(temp->val, val);
    }
}


void modifier_val2(char entite[], char entite2[])
{
    var_cst* temp1 = tab1;
    var_cst* temp2 = tab1;
    int x = Recherche_position(entite);
    int y = Recherche_position(entite2);

    if ((x == -1) || (y == -1))
    {
        printf("Entite n'existe pas dans la TS\n");
    }
    else
    {
        for (int i = 0; i < x; i++)
        {
            temp1 = temp1->next;
        }
        for (int i = 0; i < y; i++)
        {
            temp2 = temp2->next;
        }
        strcpy(temp1->val, temp2->val);
    }
}



void removePar (char entite[]) {

  if (entite[0]=='(') {
                  entite[0]=' ';
                  entite[strlen(entite)-1]=' ';
  }
}



// void insererTYPE(char entite[], char type[])
// {
//     int pos;
//     pos = Recherche_position(entite);

//     if (pos != -1)
//     {
//         while (tab1 != NULL)
//         {
//             if (strcmp(tab1->name, entite) == 0)
//             {
//                 strcpy(tab1->type, type);
//                 break;
//             }
//             tab1 = tab1->next;
//         }
//     }
// }

// void insererCODE(char entite[])
// {
//     int pos;
//     pos = Recherche_position(entite);

//     if (pos != -1)
//     {
     
//         while (tab1 != NULL)
//         {
//             if (strcmp(tab1->name, entite) == 0)
//             {
//                 strcpy(tab1->code, "IdfCst");
//                 break;
//             }
//             tab1 = tab1->next;
//         }
//     }
// }

int verifIDF(char entite[])
{
    var_cst* temp = tab1;
    while (temp != NULL)
    {
        if (temp->state == 1 && strcmp(entite, temp->name) == 0 && strcmp(temp->code, "IdfCst") == 0 && strcmp(temp->val, "") != 0)
        {
            return 1;
        }
        temp = temp->next;
    }

    printf("Entite n'existe pas dans la TS\n");
    return -1;
}


char *TypeEntite(char entite[])
{
    int pos = Recherche_position(entite);
    if (pos == -1)
    {
        printf("Entite n'existe pas dans la TS\n");
        return "";
    }

    var_cst* temp = tab1;
    for (int i = 0; i < pos; i++)
    {
        temp = temp->next;
    }

    return temp->type;
}

int doubleDeclaration(char entite[])
{
    int pos = Recherche_position(entite);
    // if (pos == -1)
    // {
    //     printf("Entite n'existe pas dans la TS\n");
    //     return -1;
    // }

     var_cst* temp = tab1;
    for (int i = 0; i < pos; i++)
    {
        temp = temp->next;
    }

    if (strcmp(temp->type, "") == 0)
        return 0;
    else
        return -1;
}


// void afficher(int choice)
// {
//     switch (choice)
//     {
//     case 0:
//     {
//         var_cst* temp = tab1;
//         printf("Table 1:\n");
//         while (temp != NULL)
//         {
//             printf("Name: %s\n", temp->name);
//             printf("Code: %s\n", temp->code);
//             printf("Type: %s\n", temp->type);
//             printf("Value: %s\n", temp->val);
//             printf("State: %d\n", temp->state);
//             printf("\n");
//             temp = temp->next;
//         }
//         break;
//     }
//     case 1:
//     {
//         MC_sep* temp = tab3;
//         printf("Table 3:\n");
//         while (temp != NULL)
//         {
//             printf("Name: %s\n", temp->name);
//             printf("Type: %s\n", temp->type);
//             printf("State: %d\n", temp->state);
//             printf("\n");
//             temp = temp->next;
//         }
//         break;
//     }
//     case 2:
//     {
//         MC_sep* temp = tab2;
//         printf("Table 2:\n");
//         while (temp != NULL)
//         {
//             printf("Name: %s\n", temp->name);
//             printf("Type: %s\n", temp->type);
//             printf("State: %d\n", temp->state);
//             printf("\n");
//             temp = temp->next;
//         }
//         break;
//     }
//     }
// }


// Function to search for the position of an entity in the linked list
int Recherche_position(char entite[]) {
         var_cst* current = tab1; // start from the head of the linked list
    int pos = -1; // initialize position to -1 (not found)

    while (current != NULL) {
        pos++; // increment position for each iteration
        if (strcmp(current->name, entite) == 0) {
            return pos; // return position if entity is found
        }
        current = current->next; // move to the next entity
    }

    return -1; // return -1 if entity is not found
}

// Function to insert/update the type of an entity
void insererTYPE(char entite[], char type[]) {
    int pos;
    pos = Recherche_position(entite);

    if (pos != -1) {
         var_cst* current = tab1;
// start from the head of the linked list

        while (current != NULL) {
            if (strcmp(current->name, entite) == 0) {
                strcpy(current->type, type); // update the entity type
                break;
            }
            current = current->next; // move to the next entity
        }
    }
}

// Function to update the code of an entity
void insererCODE(char entite[]) {
    int pos;
    pos = Recherche_position(entite);

    if (pos != -1) {
// start from the head of the linked list
         var_cst* current = tab1;
        while (current != NULL) {
            if (strcmp(current->name, entite) == 0) {
                strcpy(current->code, "IdfCst"); // update the entity code
                break;
            }
            current = current->next; // move to the next entity
        }
    }
}