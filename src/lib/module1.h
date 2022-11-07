/* module1.h -- Constants declarations */
#define module1_MAX_BUF_LEN (4*1024)

#define module1_RED_MASK    0xff0000
#define module1_GREEN_MASK  0x00ff00
#define module1_BLUE_MASK   0x0000ff

#define module1_ERROR_FLAG    (1<<0)
#define module1_WARNING_FLAG  (1<<1)
#define module1_NOTICE_FLAG   (1<<2)


#include "../attributes.h"

/* module1.h -- Types declarations */

enum module1_Direction {
    module1_NORTH,
    module1_EAST,
    module1_SOUTH,
    module1_WEST
};

typedef struct module1_Node module1_Node;

extern int module1_counter;

extern module1_Node *module1_root;


/**
 * Initializes this module. Should be called in main() once for all.
 */
extern void module1_initialization(void);

/**
 * Releases internal data structures. Should be called in main()
 * before ending the program.
 */
extern void module1_termination(void);

/**
 * Add a node to the root three.
 * @param key Value to add to the tree.
 * @return Allocated node.
 */
extern module1_Node * module1_add(char * key);

/**
 * Releases node from memory.
 * @param n Node to release.
 */
extern void module1_free(module1_Node * n);
