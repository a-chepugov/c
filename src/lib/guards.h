#pragma once

#include <stdio.h>

#define GUARD(condition, label) if((!condition)) { goto label; }
#define FUSE(condition, code, ...) if(!(condition)) { fprintf(stderr, "" __VA_ARGS__ ); exit(code); }
