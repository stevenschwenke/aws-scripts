#!/bin/zsh

# Function to test the output of aws-set-profile.sh
function test_myscript() {
  local input=$1
  local expected_output=$2
  local description=$3

  local raw_actual_output=$(./aws-set-profile.sh "$input")
  local raw_expected_output="$expected_output"

  # Remove whitespaces from actual and expected outputs
  local actual_output=$(echo "$raw_actual_output" | sed 's/[[:space:]]//g')
  local expected_output=$(echo "$raw_expected_output" | sed 's/[[:space:]]//g')

  if [[ "$actual_output" == "$expected_output" ]]; then
    echo "PASS: $description"
  else
    echo "FAIL: $description"
    echo "Expected: $raw_expected_output"
    echo "Actual  : $raw_actual_output"
  fi
}

# Test cases
test_myscript "" "Please call this script source'd like this to make your changes permanent:
                  source ./aws-set-profile.sh
                  Or like this:
                  . ./aws-set-profile.sh
                  The environment was not changed." "Missing parameter"

# TODO Should work even without source
test_myscript "-h" "Please call this script source'd like this to make your changes permanent:
                    source ./aws-set-profile.sh
                    Or like this:
                    . ./aws-set-profile.sh
                    The environment was not changed." "Show help without source"

# TODO Should work even without source
test_myscript "-l" "Please call this script source'd like this to make your changes permanent:
                    source ./aws-set-profile.sh
                    Or like this:
                    . ./aws-set-profile.sh
                    The environment was not changed." "List profiles without source"

test_myscript "my_profile" "Please call this script source'd like this to make your changes permanent:
                    source ./aws-set-profile.sh
                    Or like this:
                    . ./aws-set-profile.sh
                    The environment was not changed." "Set profile without source"

# Add more test cases as needed
#test_myscript "input1" "expected_output1" "Test case 1 description"
