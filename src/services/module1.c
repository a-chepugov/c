/* module1.c -- See module1.h for copyright and info */
#include "../lib/NS.h"

#define NAMESPACE module1


/* Import system headers and application specific headers: */
#include <malloc.h>
#include <string.h>

/* Including my own header for checking by compiler: */
#define module1_IMPORT
#include "module1.h"
#include <stdio.h>

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
static int spare_nodes_amount = 10;

/* Private functions: */
static module1_Node * alloc_Node(void){
	return malloc(sizeof(module1_Node));
}
static void free_Node(module1_Node * p){
	free(p);
}

/* Implementation of the public functions: */


__always_inline void module1_initialization() { 
	spare_nodes = malloc(sizeof(module1_Node) * spare_nodes_amount);
	printf("init\n");
}


void NSD(termination) (void){  }

module1_Node * module1_add(char * key){ 
	module1_Node * q = alloc_Node();
	q->key = key;
	return q;
}
void module1_free(module1_Node * n) { 
	free_Node(n);
	printf("free\n");
}

void module1_destructor() {  
	free_Node(spare_nodes);
}

