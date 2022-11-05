/* module1.c -- See module1.h for copyright and info */

/* Import system headers and application specific headers: */
#include <malloc.h>
#include <string.h>

/* Including my own header for checking by compiler: */
#define module1_IMPORT
#include "module1.h"

/* Private macros and constants: */

/* Private types: */

/* Actual declaration of the private opaque struct: */
struct module1_Node
{
	struct module1_Node *left, *right;
	char * key;
};

/* Private global variables: */
static module1_Node * spare_nodes = NULL;
static int allocated_total_size = 0;

/* Private functions: */
static module1_Node * alloc_Node(void){  }
static void free_Node(module1_Node * p){  }

/* Implementation of the public functions: */
void module1_initialization(void){  }
void module1_termination(void){  }
module1_Node * module1_add(char * key){ 
	module1_Node * q = malloc(sizeof(module1_Node));
	return q;

}
void module1_free(module1_Node * n) { 

}
