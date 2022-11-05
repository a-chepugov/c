
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

/* Include modules header we directly invoke here: */
#include "module1.h"

int main(int argc, char **argv)
{
    /* Initialize modules: */
    module1_initialization();

    /* Perform our job. */

    /* Properly terminate the modules, if required: */
    module1_termination();

    return 0;
}
