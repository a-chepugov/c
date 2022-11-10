#pragma once

// Откладывает подстановку macro дла подстановки элементов __VA_ARGS__
#define DEFER(macro, ...) macro(__VA_ARGS__)
#define ID(...) __VA_ARGS__
#define EMPTY()

#define DO_PRAGMA(x) _Pragma (#x)
#define MESSAGE(...) DO_PRAGMA( message(DEFER(STR, __VA_ARGS__ ) ) )
#define TODO(...) DO_PRAGMA( message("TODO @ "__FILE__ ":" DEFER(STR,__LINE__) " ::\t " DEFER(STR,  __VA_ARGS__ ) ) )

#define STR(...) #__VA_ARGS__

#define CAT(x, y) x ## y

#define FOREVER for(;;)

#define HEAD(first, ...) first
#define TAIL(first, ...) __VA_ARGS__

