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
test_output "spim -q -f sum.s 1234 1234" "2468"
test_output "spim -q -f sum.s 1 -2" "-1"
test_output "spim -q -f sum.s 9999 -1" "9998"
test_output "spim -q -f sum.s 12 12" "24"
test_output "spim -q -f sum.s 40 -4" "36"
contains "main:" "sum.s"
contains "atoi:" "sum.s"
contains "sum:" "sum.s"
contains "jal atoi" "sum.s"
contains "jal sum" "sum.s"
sum_tests=$tests_passed
# 2_length
test_output "spim -q -f length.s hola" "4"
test_output "spim -q -f length.s Milne" "5"
test_output "spim -q -f length.s internationalization" "20"
test_output "spim -q -f length.s 123" "3"
test_output "spim -q -f length.s 123456789" "9"
test_output "spim -q -f length.s 1" "1"
test_output "spim -q -f length.s cuatro" "6"
test_output "spim -q -f length.s cinco" "5"
test_output "spim -q -f length.s seis" "4"
test_output "spim -q -f length.s 0" "1"
test_output "spim -q -f length.s 1000000" "7"
test_output "spim -q -f length.s 1234567890" "10"
contains "main:" "length.s"
contains "length:" "length.s"
contains "jal length" "length.s"
length_tests=$(( $tests_passed - $sum_tests ))
# 3_palindrome
test_output "spim -q -f palindrome.s hola" "no es palindromo"
test_output "spim -q -f palindrome.s aBba" "no es palindromo"
test_output "spim -q -f palindrome.s abba" "es palindromo"
test_output "spim -q -f palindrome.s asdsa" "es palindromo"
test_output "spim -q -f palindrome.s neuquen" "es palindromo"
test_output "spim -q -f palindrome.s ayala" "no es palindromo"
test_output "spim -q -f palindrome.s asd" "no es palindromo"
test_output "spim -q -f palindrome.s cosa" "no es palindromo"
test_output "spim -q -f palindrome.s menem" "es palindromo"
test_output "spim -q -f palindrome.s abello" "no es palindromo"
test_output "spim -q -f palindrome.s profe" "no es palindromo"
test_output "spim -q -f palindrome.s alala" "es palindromo"
test_output "spim -q -f palindrome.s 123454321" "es palindromo"
test_output "spim -q -f palindrome.s reconocer" "es palindromo"
contains "main:" "palindrome.s"
contains "length:" "palindrome.s"
contains "is_palindrome:" "palindrome.s"
contains "jal length" "palindrome.s"
contains "jal is_palindrome" "palindrome.s"
contains "addi \$sp, \$sp" "palindrome.s"
palindrome_tests=$(( $tests_passed - $sum_tests - $length_tests ))
# resultado final
echo
echo "--------------  Resultado  --------------"
if [[ $tests_passed -eq 50 ]]
then
  echo -e "Todos los tests pasaron ${GREEN}✓${NC}"
else
  echo -e "sum: $sum_tests ${GREEN}✓${NC}"
  echo -e "length: $length_tests ${GREEN}✓${NC}"
  echo -e "palindrome: $palindrome_tests ${GREEN}✓${NC}"
  echo
  echo "Total: $tests_passed/50 tests OK."
fi

exit 0
