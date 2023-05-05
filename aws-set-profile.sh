#!/usr/bin/env zsh

# Description: Sets an AWS profile as environment variable.
# Usage:       . ./aws-set-profile.sh PROFILE_NAME
# Dependencies: none
#
# Examples:
#   ./aws-set-profile.sh -h
#   . ./aws-set-profile aws1
#
# Options:
#   -h    Display help
#   -l    List available profiles

# From https://stackoverflow.com/questions/2683279/how-to-detect-if-a-script-is-being-sourced
is_sourced() {
  if [ -n "$ZSH_VERSION" ]; then
    case $ZSH_EVAL_CONTEXT in *:file:*) return 0 ;; esac
  else  # Add additional POSIX-compatible shell names here, if needed.
    case ${0##*/} in dash | -dash | bash | -bash | ksh | -ksh | sh | -sh) return 0 ;; esac
  fi
  return 1  # NOT sourced.
}

display_help() {
  printf "This will help you set an AWS profile.\n\n"
  printf "-l   list all your profiles\n"
  printf "-h   display help\n"
  printf "name set a profile with a name\n"
}

aws_set_profile() {
  while getopts ":hl" option; do
    case $option in
      h) # Display help
        display_help
        return 0
        ;;
      l) # List profiles
        printf "Your AWS profiles:\n\n"
        awk '/\[/ { if (NR > 1) print }' ~/.aws/credentials
        return
        ;;
      *) # Parsing invalid arguments
        printf "Invalid argument, exiting.\n"
        return 1
        ;;
    esac
  done

  shift $((OPTIND - 1))

  # Check if the profile name is provided
  if [ -z "$1" ]; then
    printf "Profile name is missing. Please provide a profile name as an argument.\n"
    return 1
  fi

  if is_sourced; then
    printf "Setting profile with name %s:\n" "$1"
    export AWS_PROFILE=$1
    printf "\nExecuting 'printenv AWS_PROFILE':\n"
    printenv AWS_PROFILE
    printf "\nYou may also call 'aws sts get-caller-identity' to show your AWS account ID.\n"
  else
    printf "Please call this script source'd like this to make your changes permanent:\n"
    printf "source ./aws-set-profile.sh\n"
    printf "Or like this:\n"
    printf ". ./aws-set-profile.sh\n"
    printf "The environment was not changed.\n"
    exit 0
  fi
}

aws_set_profile "$@"
