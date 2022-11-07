#pragma once

#define __alias(symbol)  __attribute__((__alias__(#symbol)))
#define __hot            __attribute__((__hot__))
#define __cold           __attribute__((__cold__))
#define __noreturn       __attribute__((__noreturn__))
#define __pure           __attribute__((__pure__))
#define __weak           __attribute__((__weak__))
#define __always_inline  __inline __attribute__ ((__always_inline__))
#define __no_inline      __attribute__((__noinline__))

