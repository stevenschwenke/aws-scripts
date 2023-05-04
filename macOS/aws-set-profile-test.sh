#!/usr/bin/env zsh

# Call this script like this:
# ./aws-set-profile-test.sh "[your_profile_1]\n[your_profile_2]\n[your_profile_3]"

ACTUAL_PROFILES=$1

# Clear screen for better viewing of test results
clear

# Source script-tester.sh
source script-tester.sh

# Test cases
run_test "Missing parameter (without source)" \
              "nosource" \
              "aws-set-profile.sh" \
              "" \
              "Profile name is missing. Please provide a profile name as an argument."

run_test "Missing parameter (with source)" \
              "source" \
              "aws-set-profile.sh" \
              "" \
              "Profile name is missing. Please provide a profile name as an argument."

run_test "Show help (without source)" \
              "nosource" \
              "aws-set-profile.sh" \
              "-h" \
              "This will help you set an AWS profile.

               -l   list all your profiles
               -h   display help
               name set a profile with a name" \

run_test "Show help (with source)" \
              "source" \
              "aws-set-profile.sh" \
              "-h" \
              "This will help you set an AWS profile.

               -l   list all your profiles
               -h   display help
               name set a profile with a name"

run_test "List profiles (without source)" \
              "nosource" \
              "aws-set-profile.sh" \
              "-l" \
              "Your AWS profiles:

              $ACTUAL_PROFILES"

run_test "List profiles (with source)" \
              "source" \
              "aws-set-profile.sh" \
              "-l" \
              "Your AWS profiles:

              $ACTUAL_PROFILES"

run_test "Invalid argument (without source)" \
              "nosource" \
              "aws-set-profile.sh" \
              "-unknown" \
              "Invalid argument, exiting."

run_test "Invalid argument (with source)" \
              "source" \
              "aws-set-profile.sh" \
              "-unknown" \
              "Invalid argument, exiting."

run_test "Set profile (without source)" \
              "nosource" \
              "aws-set-profile.sh" \
              "my_profile" \
              "Please call this script source'd like this to make your changes permanent:
                    source ./aws-set-profile.sh
                    Or like this:
                    . ./aws-set-profile.sh
                    The environment was not changed."

run_test "Set profile (with source)" \
              "source" \
              "aws-set-profile.sh" \
              "my_profile" \
              "Setting profile with name my_profile:

               Executing 'printenv AWS_PROFILE':
               my_profile

               You may also call 'aws sts get-caller-identity' to show your AWS account ID."

