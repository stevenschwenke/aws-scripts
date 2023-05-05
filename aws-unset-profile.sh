#!/usr/bin/env zsh

# Description: Unsets the environment variable AWS_PROFILE.
# Usage:       . ./aws-unset-profile.sh
# Dependencies: none
#
# Examples:
#   ./aws-unset-profile.sh -h
#   . ./aws-unset-profile
#
# Options:
#   -h    Display help

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
  printf "This will unset the following environment variable:\n\n"
  printf "	AWS_PROFILE\n\n"
  printf "To be able to change environment variables, this script has to be executed with 'source' like this:\n"
  printf "source ./aws-unset-profile.sh\n"
}

aws_unset_profile() {
  while getopts ":hl" option; do
    case $option in
      h) # Display help
        display_help
        return 0
        ;;
      *) # Parsing invalid arguments
        printf "Invalid argument, exiting.\n"
        return 1
        ;;
    esac
  done

  shift $((OPTIND - 1))

  if is_sourced; then
    printf "Removing AWS_PROFILE from environment variables ...\n"
    unset AWS_PROFILE
    printf "Done.\n"
  else
    printf "Please call this script source'd like this to make your changes permanent:\n"
    printf "source ./aws-unset-profile.sh\n"
    printf "Or like this:\n"
    printf ". ./aws-unset-profile.sh\n"
    printf "The environment was not changed.\n"
    exit 0
  fi
}

aws_unset_profile "$@"
