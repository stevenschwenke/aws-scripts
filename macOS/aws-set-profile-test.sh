#!/bin/zsh

# Call this script like this:
# ./aws-set-profile-test.sh "[your_profile_1]\n[your_profile_2]\n[your_profile_3]"

ACTUAL_PROFILES=$1

# Function to test the output of aws-set-profile.sh
function test_myscript() {
  local run_with_source=$1
  local input=$2
  local expected_output=$3
  local description=$4

  local raw_actual_output
  if [[ "$run_with_source" == "source" ]]; then
    raw_actual_output=$(source ./aws-set-profile.sh "$input")
  else
    raw_actual_output=$(./aws-set-profile.sh "$input")
  fi

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
test_myscript "nosource" \
              "" \
              "Please call this script source'd like this to make your changes permanent:
                  source ./aws-set-profile.sh
                  Or like this:
                  . ./aws-set-profile.sh
                  The environment was not changed." \
                  "Missing parameter (without source)"

test_myscript "source" \
              "" \
              "Profile name is missing. Please provide a profile name as an argument." \
                  "Missing parameter (with source)"

# TODO Should work even without source
test_myscript "nosource" \
              "-h" \
              "Please call this script source'd like this to make your changes permanent:
                    source ./aws-set-profile.sh
                    Or like this:
                    . ./aws-set-profile.sh
                    The environment was not changed." \
              "Show help (without source)"

test_myscript "source" \
              "-h" \
              "This will help you set an AWS profile.

               -l   list all your profiles
               -h   display help
               name set a profile with a name" \
              "Show help (with source)"

# TODO Should work even without source
test_myscript "nosource" \
              "-l" \
              "Please call this script source'd like this to make your changes permanent:
                    source ./aws-set-profile.sh
                    Or like this:
                    . ./aws-set-profile.sh
                    The environment was not changed." \
              "List profiles (without source)"

test_myscript "source" \
              "-l" \
              "Your AWS profiles:

              $ACTUAL_PROFILES" \
              "List profiles (with source)"

test_myscript "nosource" \
              "my_profile" \
              "Please call this script source'd like this to make your changes permanent:
                    source ./aws-set-profile.sh
                    Or like this:
                    . ./aws-set-profile.sh
                    The environment was not changed." \
              "Set profile (without source)"

test_myscript "source" \
              "my_profile" \
              "Setting profile with name my_profile:

               Executing 'env | grep AWS_PROFILE':
               AWS_PROFILE=my_profile

               You may also call 'aws sts get-caller-identity' to show your AWS account ID." \
              "Set profile (with source)"

# Add more test cases as needed
#test_myscript "input1" "expected_output1" "Test case 1 description"
