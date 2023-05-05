#!/usr/bin/env zsh

# jq is needed for parsing the JSON that includes the AWS credentials
jq_missing() {
  if command -v jq >/dev/null 2>&1; then
    return 1
  fi
}

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
  printf "This will call AWS STS with your current credentials, get a temporary access token and set this token with the following environment variables:\n\n"
  printf "	AWS_ACCESS_KEY_ID\n"
  printf "	AWS_SECRET_ACCESS_KEY\n"
  printf "	AWS_SESSION_TOKEN\n\n"
  printf "Usage:\n\n"
  printf "aws-set-mfa-access-token MFA_SERIAL_NUMBER TOKEN_CODE\n\n"
  printf "Example:\n\n"
  printf "aws-set-mfa-access-token arn:aws:iam::000000000042:mfa/youruser 424242\n\n"
  printf "This will cause every request to be send with this access token.\n\n"
  printf "To be able to change environment variables, this script has to be executed with 'source' like this:\n"
  printf "source ./aws-set-mfa-access-token.sh\n"
}

aws_set_mfa_access_token() {

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

  # Check number of arguments is two
  if [ $# -lt 2 ]
  then
    printf "Please provide two arguments:\n"
    printf "1. MFA_SERIAL_NUMBER\n"
    printf "2. TOKEN_CODE\n"
    return
  fi

  # Check if environment variables already set
  printf "Checking if environment variables are set ...\n\n"
  if [ -z ${AWS_ACCESS_KEY_ID+x} ]; then
    printf "AWS_ACCESS_KEY_ID is unset\n";
    AWS_ACCESS_KEY_ID_ALREADY_SET=false
  else
    printf "AWS_ACCESS_KEY_ID is set to '$AWS_ACCESS_KEY_ID'\n";
    AWS_ACCESS_KEY_ID_ALREADY_SET=true
  fi
  if [ -z ${AWS_SECRET_ACCESS_KEY+x} ]; then
    printf "AWS_SECRET_ACCESS_KEY is unset\n";
    AWS_SECRET_ACCESS_KEY_ALREADY_SET=false
  else
    printf "AWS_SECRET_ACCESS_KEY is set to '$AWS_SECRET_ACCESS_KEY'\n";
    AWS_SECRET_ACCESS_KEY_ALREADY_SET=true
  fi

  if [ -z ${AWS_SESSION_TOKEN+x} ]; then
    printf "AWS_SESSION_TOKEN is unset\n\n";
    AWS_SESSION_TOKEN_ALREADY_SET=false
  else
    printf "AWS_SESSION_TOKEN is set to '$AWS_SESSION_TOKEN'\n\n";
    AWS_SESSION_TOKEN_ALREADY_SET=true
  fi

  # Confirming overwrite or return out of script
  if [ $AWS_ACCESS_KEY_ID_ALREADY_SET = true ] || [ $AWS_SECRET_ACCESS_KEY_ALREADY_SET = true ] || [ $AWS_SESSION_TOKEN_ALREADY_SET = true ]; then
    printf "The already existing variables will be overriden. Continue?\n"
    read -q "REPLY?Continue? (Y/N): "
    if [[ $REPLY != [yY] ]] && [[ $REPLY != [yY][eE][sS] ]]; then
      echo "Exiting"
      return
    else
      printf "\n"
    fi

  else
    printf "No existing variables set. Will continue ...\n"
  fi

  if is_sourced; then
    # Get MFA access token from AWS
    printf "Getting new MFA access token ...\n\n"
    CREDJSON="$(aws sts get-session-token --serial-number $1 --token-code $2)"

    if [ $? -ne 0 ]; then
      echo "Failed to retrieve session credentials. Please check your input and try again. Your AWS environment variables have not been altered."
      return 1
    fi

    ACCESSKEY="$(echo $CREDJSON | jq '.Credentials.AccessKeyId' | sed 's/"//g')"
    SECRETACESSKEY="$(echo $CREDJSON | jq '.Credentials.SecretAccessKey' | sed 's/"//g')"
    SESSIONTOKEN="$(echo $CREDJSON | jq '.Credentials.SessionToken' | sed 's/"//g')"

    printf "AccessKeyId:\n"
    printf "$ACCESSKEY\n\n"
    printf "SecretAccessKey:\n"
    printf "$SECRETACESSKEY\n\n"
    printf "SessionToken:\n"
    printf "$SESSIONTOKEN\n\n"

    printf "Setting values as environment variables ...\n"
    export AWS_ACCESS_KEY_ID=$ACCESSKEY
    export AWS_SECRET_ACCESS_KEY=$SECRETACESSKEY
    export AWS_SESSION_TOKEN=$SESSIONTOKEN
    printf "Done.\n\n"
    printf "Here are all your AWS environment variables:\n"
    printenv | grep '^AWS'
  else
    printf "Please call this script source'd like this to make your changes permanent:\n"
    printf "source ./aws-set-profile.sh\n"
    printf "Or like this:\n"
    printf ". ./aws-set-profile.sh\n"
    printf "The environment was not changed.\n"
    exit 0
  fi
}

if jq_missing; then
  echo "jq is not installed. Please install it and try again."
  if is_sourced; then
    return
  else
    exit 1
  fi
fi

aws_set_mfa_access_token "$@"
