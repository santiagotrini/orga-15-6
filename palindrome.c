#include <stdio.h>
#include <stdlib.h>

int length(char *str) {
  int c = 0;
  while (str[c] != 0) c++;
  return c;
}

int is_palindrome(char *str) {
  int l = length(str);
  int result = 1;
  for (int i = 0; i < l/2; i++) {
    if (str[i] != str[l-i-1]) { result = 0; break; }
  }
  return result;
}

int main(int argc, char *argv[]) {
  printf("%s\n", is_palindrome(argv[1]) ? "es palindromo" : "no es palindromo");
  return 0;
}
