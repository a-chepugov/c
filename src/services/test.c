#include "../lib/guards.h"

void test(int exit_code) {
	ALERT(1 > 6, " sdfasdssdfs\n ");
	FUSE(1 > 6, exit_code);
}

