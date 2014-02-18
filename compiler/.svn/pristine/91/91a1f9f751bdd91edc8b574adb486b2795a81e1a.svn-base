#include <stdio.h>
#include <stdlib.h>

struct Block {
  int i;
  int* ia;
  char* s;
  char** sa;
  char c;
  char* ca;
  struct Block *blk_ptr;
  struct Block **blk_ptr_arr;
};

void initialize(struct Block *b) {
  b->ia = malloc(1000 * sizeof(int));
  b->sa = malloc(1000 * sizeof(char*));
  b->ca = malloc(1000 * sizeof(char));
  b->blk_ptr = 0;
  b->blk_ptr_arr = 0;
}

int main(int argc, char **argv) {
  int i;
  struct Block *d;
  for (i = 0; i < 1000 * 1000; i++) {
    d = malloc(sizeof(struct Block));
    initialize(d);
    printf("%d\n", i);
  }
  printf("success\n");
  return 0;
}
