#!/bin/zsh

# Call this script like this:
# ./aws-set-profile-test.sh "[your_profile_1]\n[your_profile_2]\n[your_profile_3]"

ACTUAL_PROFILES=$1

# Function to test the output of aws-set-profile.sh
function test_myscript() {
  local description=$1
  local run_with_source=$2
  local input=$3
  local expected_output=$4

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
test_myscript "Missing parameter (without source)" \
              "nosource" \
              "" \
              "Please call this script source'd like this to make your changes permanent:
                  source ./aws-set-profile.sh
                  Or like this:
                  . ./aws-set-profile.sh
                  The environment was not changed."

test_myscript "Missing parameter (with source)" \
              "source" \
              "" \
              "Profile name is missing. Please provide a profile name as an argument."

# TODO Should work even without source
test_myscript "Show help (without source)" \
              "nosource" \
              "-h" \
              "Please call this script source'd like this to make your changes permanent:
                    source ./aws-set-profile.sh
                    Or like this:
                    . ./aws-set-profile.sh
                    The environment was not changed." \

test_myscript "Show help (with source)" \
              "source" \
              "-h" \
              "This will help you set an AWS profile.

               -l   list all your profiles
               -h   display help
               name set a profile with a name"

# TODO Should work even without source
test_myscript "List profiles (without source)" \
              "nosource" \
              "-l" \
              "Please call this script source'd like this to make your changes permanent:
                    source ./aws-set-profile.sh
                    Or like this:
                    . ./aws-set-profile.sh
                    The environment was not changed."

test_myscript "List profiles (with source)" \
              "source" \
              "-l" \
              "Your AWS profiles:

              $ACTUAL_PROFILES"

# TODO Should work even without source
test_myscript "Invalid argument (without source)" \
              "nosource" \
              "-unknown" \
              "Please call this script source'd like this to make your changes permanent:
                                   source ./aws-set-profile.sh
                                   Or like this:
                                   . ./aws-set-profile.sh
                                   The environment was not changed."

test_myscript "Invalid argument (with source)" \
              "source" \
              "-unknown" \
              "Invalid argument, exiting."

test_myscript "Set profile (without source)" \
              "nosource" \
              "my_profile" \
              "Please call this script source'd like this to make your changes permanent:
                    source ./aws-set-profile.sh
                    Or like this:
                    . ./aws-set-profile.sh
                    The environment was not changed."

test_myscript "Set profile (with source)" \
              "source" \
              "my_profile" \
              "Setting profile with name my_profile:

               Executing 'env | grep AWS_PROFILE':
               AWS_PROFILE=my_profile

               You may also call 'aws sts get-caller-identity' to show your AWS account ID."

