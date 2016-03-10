#!/bin/bash
set -e # Fail on error

ROOT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

cd "$ROOT_DIR"
mkdir -p build
cd build

cmake ..

# Use GCC:
# cmake -DCMAKE_C_COMPILER=/usr/bin/gcc -DCMAKE_CXX_COMPILER=/usr/bin/g++ ..

# Use GCC5:
# cmake -DCMAKE_C_COMPILER=/usr/bin/gcc-5 -DCMAKE_CXX_COMPILER=/usr/bin/g++-5 ..

# Use clang-3.7:
# cmake -DCMAKE_C_COMPILER=/usr/bin/clang-3.7 -DCMAKE_CXX_COMPILER=/usr/bin/clang++-3.7 ..

make

function test_failure
{
    echo ""
    ./loguru_test $1 && echo "Expected command to fail!" && exit 1
    echo ""
    echo ""
}


echo "---------------------------------------------------------"
echo "Testing failures..."
echo "---------------------------------------------------------"
test_failure "ABORT_F"
test_failure "ABORT_S"
test_failure "assert"
test_failure "LOG_F(FATAL)"
test_failure "LOG_S(FATAL)"
test_failure "CHECK_NOTNULL_F"
test_failure "CHECK_F"
test_failure "CHECK_EQ_F_int"
test_failure "CHECK_EQ_F_unsigned"
test_failure "CHECK_EQ_F_size_t"
test_failure "CHECK_EQ_F"
test_failure "CHECK_EQ_F_message"
test_failure "CHECK_EQ_F"
test_failure "CHECK_EQ_S"
test_failure "CHECK_LT_S"
test_failure "CHECK_LT_S_message"
test_failure "deep_abort"
test_failure "SIGSEGV"
test_failure "abort"
test_failure "error_context"
echo "---------------------------------------------------------"
echo "ALL TESTS PASSED!"
echo "---------------------------------------------------------"

./loguru_test $@

./loguru_test hang
