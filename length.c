#include <stdio.h>
#include <stdlib.h>

int length(char *str) {
  int c = 0;
  while (str[c] != 0) c++;
  return c;
}

int main(int argc, char *argv[]) {
  printf("%d\n", length(argv[1]));
  return 0;
}
