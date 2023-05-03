#!/bin/zsh

# From https://stackoverflow.com/questions/2683279/how-to-detect-if-a-script-is-being-sourced
is_sourced() {
  if [ -n "$ZSH_VERSION" ]; then
    case $ZSH_EVAL_CONTEXT in *:file:*) return 0 ;; esac
  else  # Add additional POSIX-compatible shell names here, if needed.
    case ${0##*/} in dash | -dash | bash | -bash | ksh | -ksh | sh | -sh) return 0 ;; esac
  fi
  return 1  # NOT sourced.
}

help() {
  echo "This will help you set an AWS profile."
  echo
  echo "-l   list all your profiles"
  echo "-h   display help"
  echo "name set a profile with a name"
}

while getopts ":hl" option; do
  case $option in
    h) # Display help
      help
      exit 0
      ;;
    l) # List profiles
      echo "Your AWS profiles:"
      echo
      awk '/\[/ { if (NR > 1) print }' ~/.aws/credentials
      if is_sourced; then
        return
      else
        exit 0
      fi
      ;;
    *) # Parsing invalid arguments
      echo "Invalid argument, exiting."
      exit 1
      ;;
  esac
done

if ! is_sourced; then
  echo "Please call this script source'd like this to make your changes permanent:"
  echo "source ./aws-set-profile.sh"
  echo "Or like this:"
  echo ". ./aws-set-profile.sh"
  echo "The environment was not changed."
  exit 0
else
  # Check if the profile name is provided
  if [ -z "$1" ]; then
    echo "Profile name is missing. Please provide a profile name as an argument."
    exit 1
  fi

  echo "Setting profile with name $1:"
  export AWS_PROFILE=$1
  echo
  echo "Executing 'env | grep AWS_PROFILE':"
  env | grep AWS_PROFILE
  echo
  echo "You may also call 'aws sts get-caller-identity' to show your AWS account ID."
  return
fi
exit 0
