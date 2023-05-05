#!/usr/bin/env zsh

# Call this script like this:
# run_test "description of test" "source" "script-file" "input" "expected output"

function run_test() {
  description="$1"
  run_with_source="$2"
  script_file="$3"
  input="$4"
  expected_output="$5"

  if [[ "$run_with_source" == "source" ]]; then
    raw_actual_output=$(source ./$script_file "$input")
  else
    raw_actual_output=$(./$script_file "$input")
  fi

  raw_expected_output="$expected_output"

  # Remove whitespaces from actual and expected outputs
  actual_output=$(echo "$raw_actual_output" | sed 's/[[:space:]]//g')
  expected_output=$(echo "$raw_expected_output" | sed 's/[[:space:]]//g')

  if [[ "$actual_output" == "$expected_output" ]]; then
    echo "PASS: $description"
  else
    echo "FAIL: $description"
    echo "Expected: $raw_expected_output"
    echo "Actual  : $raw_actual_output"
  fi
}
