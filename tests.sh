#!/bin/bash

# colores
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# contador
tests_passed=0

# funciones
test_output() {
  output=$($1)
  expected=$2
  if [[ "$output" == "$expected" ]]
  then
    echo -e "[  ${GREEN}OK${NC}  ]: $1 → $2 ${GREEN}✓${NC}"
    tests_passed=$((tests_passed + 1))
  else
    echo -e "[ ${RED}Fail${NC} ]: Esperaba '$expected' pero se obtuvo '$output' ${RED}✗${NC}"
  fi
}

contains() {
  (grep "$1" $2) > /dev/null
  exit_code=$?
  if [[ "$exit_code" -eq 0 ]]
  then
    echo -e "[  ${GREEN}OK${NC}  ]: $2 contiene $1 ${GREEN}✓${NC}"
    tests_passed=$((tests_passed + 1))
  else
    echo -e "[ ${RED}Fail${NC} ]: $2 no contiene $1 ${RED}✗${NC}"
  fi
}
test_output_spim() {
  output=$(echo $1 | $2)
  expected=$3
  if [[ "$output" == "$expected" ]]
  then
    echo -e "[  ${GREEN}OK${NC}  ]: echo $1 | $2 → $3 ${GREEN}✓${NC}"
    tests_passed=$((tests_passed + 1))
  else
    echo -e "[ ${RED}Fail${NC} ]: Esperaba '$expected' pero se obtuvo '$output' ${RED}✗${NC}"
  fi
}
test_output_redirect() {
  output=$($1 < $2)
  expected=$3
  if [[ "$output" == "$expected" ]]
  then
    echo -e "[  ${GREEN}OK${NC}  ]: $1 < $2 → $3 ${GREEN}✓${NC}"
    tests_passed=$((tests_passed + 1))
  else
    echo -e "[ ${RED}Fail${NC} ]: Esperaba '$expected' pero se obtuvo '$output' ${RED}✗${NC}"
  fi
}

# 1_sum
test_output "spim -q -f sum.s 1 1" "2"
test_output "spim -q -f sum.s 1 -1" "0"
test_output "spim -q -f sum.s 9999 1" "10000"
test_output "spim -q -f sum.s 1234 3210" "4444"
test_output "spim -q -f sum.s 7 -2" "5"
contains "main:" "sum.s"
contains "atoi:" "sum.s"
contains "sum:" "sum.s"
contains "jal atoi" "sum.s"
contains "jal sum" "sum.s"
# 2_length
test_output "spim -q -f length.s hola" "4"
test_output "spim -q -f length.s Milne" "5"
test_output "spim -q -f length.s internationalization" "20"
test_output "spim -q -f length.s 123" "3"
test_output "spim -q -f length.s 1" "1"
test_output "spim -q -f length.s cuatro" "6"
test_output "spim -q -f length.s seis" "4"
contains "main:" "length.s"
contains "length:" "length.s"
contains "jal length" "length.s"
# 3_palindrome
test_output "spim -q -f palindrome.s hola" "no es palindromo"
test_output "spim -q -f palindrome.s aBba" "no es palindromo"
test_output "spim -q -f palindrome.s abba" "es palindromo"
test_output "spim -q -f palindrome.s ayala" "no es palindromo"
test_output "spim -q -f palindrome.s alala" "es palindromo"
test_output "spim -q -f palindrome.s reconocer" "es palindromo"
contains "main:" "palindrome.s"
contains "length:" "palindrome.s"
contains "is_palindrome:" "palindrome.s"
contains "addi \$sp, \$sp" "palindrome.s"
# resultado final
echo "--------------  Resultado  --------------"
if [[ $tests_passed -eq 30 ]]
then
  echo -e "Todos los tests pasaron ${GREEN}✓${NC}"
else
  echo "Resultado: $tests_passed/30 tests OK."
fi

exit 0
