#pragma once

typedef struct counter_t counter_t;

counter_t * counter_new();
void counter_free(counter_t **);
int counter_get();
int counter_inc(counter_t *);

