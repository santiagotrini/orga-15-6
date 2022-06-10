.data
si: .asciiz "es palindromo\n"
no: .asciiz "no es palindromo\n"

.text
main:
  li $v0, 10
  syscall
