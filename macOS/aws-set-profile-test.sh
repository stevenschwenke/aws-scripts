#!/bin/zsh

# Function to test the output of your script
function test_myscript() {
  local input=$1
  local expected_output=$2
  local description=$3

  local actual_output=$(./aws-set-profile.sh "$input")

  if [[ "$actual_output" == "$expected_output" ]]; then
    echo "PASS: $description"
  else
    echo "FAIL: $description"
    echo "Expected: $expected_output"
    echo "Actual  : $actual_output"
  fi
}

# Test cases
test_myscript "" "Please call this script source'd like this to make your changes permanent:
                  source ./aws-set-profile.sh
                  Or like this:
                  . ./aws-set-profile.sh
                  The environment was not changed." "Missing Input"

# Add more test cases as needed

