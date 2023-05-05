#!/usr/bin/env zsh

# Call this script like this:
# ./aws-unset-profile-test.sh

# Clear screen for better viewing of test results
clear

# Source script-tester.sh
source script-tester.sh

# Test cases

run_test "Show help (without source)" \
              "nosource" \
              "aws-unset-profile.sh" \
              "-h" \
              "This will unset the following environment variable:

                	AWS_PROFILE

                To be able to change environment variables, this script has to be executed with 'source' like this:
                source ./aws-unset-profile.sh" \

run_test "Show help (with source)" \
              "source" \
              "aws-unset-profile.sh" \
              "-h" \
              "This will unset the following environment variable:

                	AWS_PROFILE

                To be able to change environment variables, this script has to be executed with 'source' like this:
                source ./aws-unset-profile.sh" \

run_test "Invalid argument (without source)" \
              "nosource" \
              "aws-unset-profile.sh" \
              "-unknown" \
              "Invalid argument, exiting."

run_test "Invalid argument (with source)" \
              "source" \
              "aws-unset-profile.sh" \
              "-unknown" \
              "Invalid argument, exiting."

run_test "Unset profile (without source)" \
              "nosource" \
              "aws-unset-profile.sh" \
              "my_profile" \
              "Please call this script source'd like this to make your changes permanent:
                    source ./aws-unset-profile.sh
                    Or like this:
                    . ./aws-unset-profile.sh
                    The environment was not changed."

run_test "Unset profile (with source)" \
              "source" \
              "aws-unset-profile.sh" \
              "my_profile" \
              "Removing AWS_PROFILE from environment variables ...
               Done."

