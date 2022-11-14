#include "../lib/guards.h"
#include "../lib/log.h"
#include "example.h"

void test(int exit_code) {
	CHECK(1 > 6, ": invalid condition\n");
	FUSE(1 > 6, exit_code);
}

