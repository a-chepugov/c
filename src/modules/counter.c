#include <stdlib.h>
#include "counter.h"
#include "../lib/log.h"

struct counter_t {
	int value;
};

counter_t * counter_new() {
	counter_t * c = (counter_t *) malloc(sizeof(counter_t));
	c->value = 5;
	return c;
}

void counter_free(counter_t ** c) {
	free(*c);
	*c = NULL;
}

int counter_get(counter_t * c) {
	return c->value;
}

int counter_inc(counter_t * c) {
	c->value++;
	return c->value;
}

