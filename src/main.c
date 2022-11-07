
/**
 * Our sample program.
 * @copyright 2008 by icosaedro.it di Umberto Salsi
 * @license as you wish
 * @author Umberto Salsi <salsi@icosaedro.it>
 * @version 2008-04-23
 * @file
 */

/* Include standard headers: */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "lib/NS.h"

/* Include modules header we directly invoke here: */
#include "services/module1.h"

int main(int argc, char **argv)
{
	for (int i; i < argc; i++) {
		printf("%d - %s", i, argv[i]);
	}

	NS(module1, initialization)();
	NS(module1, termination)();
	printf("HELLO\n");

	return 0;
}
