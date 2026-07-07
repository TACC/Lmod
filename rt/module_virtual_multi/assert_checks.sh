#!/bin/bash
# Issue #818 red assertions — expected behavior for multi-virtual layouts.
# runLmod writes a header file (odd NUM) and output file (even NUM) per step.

ASSERT_FAILURES=()

fail() {
  ASSERT_FAILURES+=("$*")
}

assert_stderr_contains() {
  local step=$1
  local pattern=$2
  local file="_stderr.$step"
  if ! grep -q "$pattern" "$file"; then
    fail "step $step should contain: $pattern"
  fi
}

assert_stderr_not_contains() {
  local step=$1
  local pattern=$2
  local file="_stderr.$step"
  if grep -q "$pattern" "$file"; then
    fail "step $step should not contain: $pattern"
  fi
}

# 004=avail test1 006=load 008=list 010=show 012=load test1 fail
# 016=avail test2 018=load test2 020=list test2 024=load test3

assert_test1_list() {
  assert_stderr_contains "008" "test1/24.5.0"
  assert_stderr_not_contains "008" "test1/.test1"
  assert_stderr_not_contains "008" "(H)"
}

assert_test1_show_version() {
  assert_stderr_contains "010" 'whatis("Version: 24.5.0")'
  assert_stderr_not_contains "010" 'whatis("Version: .test1")'
}

assert_test1_no_default_load() {
  assert_stderr_contains "012" "unknown"
  assert_stderr_contains "012" "test1"
}

assert_test2_avail() {
  assert_stderr_contains "016" "test2/22.2.1"
  assert_stderr_contains "016" "test2/24.6.0"
  assert_stderr_not_contains "016" "test2/21.1.1"
  assert_stderr_not_contains "016" "test2/23.1.0"
  assert_stderr_not_contains "016" "test2/24.5.0"
  assert_stderr_contains "016" "(D)"
}

assert_test2_default_list() {
  assert_stderr_contains "020" "test2/24.6.0"
  assert_stderr_not_contains "020" "test2/.base"
  assert_stderr_not_contains "020" "(H)"
}

assert_test3_relative_load() {
  assert_stderr_not_contains "024" 'unknown: ".base"'
}

run_all_asserts() {
  assert_test1_list
  assert_test1_show_version
  assert_test1_no_default_load
  assert_test2_avail
  assert_test2_default_list
  assert_test3_relative_load
  if [ ${#ASSERT_FAILURES[@]} -gt 0 ]; then
    echo "ASSERT FAILURES (${#ASSERT_FAILURES[@]}):" >&2
    for msg in "${ASSERT_FAILURES[@]}"; do
      echo "  - $msg" >&2
    done
    exit 1
  fi
}
