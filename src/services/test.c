#include "../lib/guards.h"
#include "../lib/log.h"

void test(int exit_code) {
	CHECK(1 > 6, " sdfasdssdfs\n ");
	FUSE(1 > 6, exit_code);
}

