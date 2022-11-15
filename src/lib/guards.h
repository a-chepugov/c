#pragma once

#include <stdio.h>
#include <stdlib.h>

#define GUARD(condition, label) if((condition)) { goto label; }
#define NGUARD(condition, label) if((!condition)) { goto label; }
#define FUSE(condition, code, ...) if((condition)) { fprintf(stderr, " " __VA_ARGS__ ); exit(code); }
#define NFUSE(condition, code, ...) if(!(condition)) { fprintf(stderr, " " __VA_ARGS__ ); exit(code); }

#define FREE(p) { free(p); p = NULL; }
