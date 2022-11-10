#pragma once

#include <stdio.h>

#define LOG_TYPED(type, message, ...) fprintf(stderr, type " %s | %s:%d> " message "\n", __TIME__, __FILE__, __LINE__, "" __VA_ARGS__)
#define LOG_INFO(...) LOG_TYPED("[INFO ]", __VA_ARGS__)
#define LOG_WARN(...) LOG_TYPED("[WARN ]", __VA_ARGS__)
#define LOG_ERR(...) LOG_TYPED("[ERROR]", __VA_ARGS__)

#ifdef NDEBUG
#define DBG(...)
#else
#define DBG(...) LOG_TYPED("[-DBG-]", __VA_ARGS__)
#endif

#define ALERT(condition, ...) if(!(condition)) { fprintf(stderr, #condition "" __VA_ARGS__); }

