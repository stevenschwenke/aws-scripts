#!/usr/bin/env zsh

# Description: Executes tests for aws-set-mfa-access-token.sh
# Usage:       ./aws-set-mfa-access-token-test.sh MFA_SERIAL_NUMBER TOKEN_CODE
# Dependencies: aws-set-mfa-access-token.sh
#
# Examples:
#   ./aws-set-mfa-access-token-test.sh arn:aws:iam::000000000042:mfa/youruser 424242
#

ACTUAL_PROFILES=$1

# Clear screen for better viewing of test results
clear

# Source script-tester.sh
source script-tester.sh

# Test cases

run_test "Show help (without source)" \
              "nosource" \
              "aws-set-mfa-access-token.sh" \
              "-h" \
              "This will call AWS STS with your current credentials, get a temporary access token and set this token with the following environment variables:

               	AWS_ACCESS_KEY_ID
               	AWS_SECRET_ACCESS_KEY
               	AWS_SESSION_TOKEN

               Usage:

               . ./aws-set-mfa-access-token.sh MFA_SERIAL_NUMBER TOKEN_CODE

               Example:

               . ./aws-set-mfa-access-token.sh arn:aws:iam::000000000042:mfa/youruser 424242

               This will cause every request to be send with this access token.

               To be able to change environment variables, this script has to be executed with 'source' like this:
               source ./aws-set-mfa-access-token.sh" \

run_test "Show help (with source)" \
              "source" \
              "aws-set-mfa-access-token.sh" \
              "-h" \
              "This will call AWS STS with your current credentials, get a temporary access token and set this token with the following environment variables:

               	AWS_ACCESS_KEY_ID
               	AWS_SECRET_ACCESS_KEY
               	AWS_SESSION_TOKEN

               Usage:

               . ./aws-set-mfa-access-token.sh MFA_SERIAL_NUMBER TOKEN_CODE

               Example:

               . ./aws-set-mfa-access-token.sh arn:aws:iam::000000000042:mfa/youruser 424242

               This will cause every request to be send with this access token.

               To be able to change environment variables, this script has to be executed with 'source' like this:
               source ./aws-set-mfa-access-token.sh"

run_test "Invalid argument (without source)" \
              "nosource" \
              "aws-set-mfa-access-token.sh" \
              "-unknown" \
              "Invalid argument, exiting."

run_test "Invalid argument (with source)" \
              "source" \
              "aws-set-mfa-access-token.sh" \
              "-unknown" \
              "Invalid argument, exiting."

run_test "Just one instead of two parameters (without source)" \
              "nosource" \
              "aws-set-mfa-access-token.sh" \
              "first" \
              "Please provide two arguments:
               1. MFA_SERIAL_NUMBER
               2. TOKEN_CODE"

run_test "Just one instead of two parameters (with source)" \
              "source" \
              "aws-set-mfa-access-token.sh" \
              "first" \
              "Please provide two arguments:
               1. MFA_SERIAL_NUMBER
               2. TOKEN_CODE"

run_test "Three instead of two parameters (without source)" \
              "nosource" \
              "aws-set-mfa-access-token.sh" \
              "first" \
              "Please provide two arguments:
               1. MFA_SERIAL_NUMBER
               2. TOKEN_CODE"

run_test "Three instead of two parameters (with source)" \
              "source" \
              "aws-set-mfa-access-token.sh" \
              "first" \
              "Please provide two arguments:
               1. MFA_SERIAL_NUMBER
               2. TOKEN_CODE"
