#!/usr/bin/env zsh

# Description: Executes a given script file.
# Usage:       ./script-tester.sh DESCRIPTION RUN_WITH_SOURCE SCRIPT_FILE INPUT EXPECTED_OUTPUT
# Dependencies: none
#
# Example:
# source script-tester.sh
# run_test "Missing parameter (without source)" \
#              "nosource" \
#              "aws-set-profile.sh" \
#              "" \
#              "Profile name is missing. Please provide a profile name as an argument."

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
