#!/bin/zsh

# Call this script like this:
# ./script-tester.sh "description of test" "source" "SCRIPT-FILE" "input" "expected output"

# Function to test the output of aws-set-profile.sh

description="$1"
echo $description
run_with_source="$2"
echo $run_with_source
script_file="$3"
echo $script_file
input="$4"
echo $input
expected_output="$5"
echo $expected_output

raw_actual_output=""

raw_actual_output
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

