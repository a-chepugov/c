#pragma once

#include <stdio.h>
#include "helpers.h"

#define LOG_TYPED(type, ...) fprintf(stderr, type " " __TIME__ " | "  __FILE__ ":" DEFER(STR, __LINE__ ) " > " __VA_ARGS__)
#define LOG_INFO(...) LOG_TYPED("[INFO ]", __VA_ARGS__)
#define LOG_WARN(...) LOG_TYPED("[WARN ]", __VA_ARGS__)
#define LOG_ERR(...) LOG_TYPED("[ERROR]", __VA_ARGS__)

#ifdef NDEBUG
#define DBG(...)
#else
#define DBG(...) LOG_TYPED("[-DBG-]", __VA_ARGS__)
#endif

#define CHECK(condition, ...) if(!(condition)) { fprintf(stderr, #condition " " __VA_ARGS__); }

