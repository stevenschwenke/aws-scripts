#!/bin/bash

if [ ${BASH_SOURCE[0]} == ${0} ]
then
	SOURCED=false
else
	SOURCED=true
fi

while getopts ":h" option; do
   case $option in
      h) # Display help
		 echo "This will call AWS STS with your current credentials, get a temporary access token and set this token with the following environment variables:"
		 echo
		 echo "	AWS_ACCESS_KEY_ID"
		 echo "	AWS_SECRET_ACCESS_KEY"
		 echo "	AWS_SESSION_TOKEN"
		 echo
		 echo "Usage:"
		 echo
		 echo "aws-set-mfa-access-token MFA_SERIAL_NUMBER TOKEN_CODE"
		 echo
		 echo "Example:"
		 echo
		 echo "aws-set-mfa-access-token arn:aws:iam::000000000042:mfa/youruser 424242"
		 echo
		 echo "This will cause every request to be send with this access token."
		 echo
		 echo "To be able to change environment variables, this script has to be executed with 'source' like this:"
		 echo "source ./aws-set-mfa-access-token.sh"
		 if [ $SOURCED = true ]
		 then
			return
		 else
			exit
		 fi
		 ;;
   esac
done

if [ $SOURCED = false ]
then
	echo "You are not running this script as source."
	echo "To make these changes permanent, call this script source'd like this:"
	echo "source ./aws-set-mfa-access-token.sh"
	exit
fi

if [ $# -lt 2 ]
then
	echo "Please provide two arguments:"
	echo "1. MFA_SERIAL_NUMBER"
	echo "2. TOKEN_CODE"
	return
fi

echo "Checking if environment variables are set ..."
echo
if [ -z ${AWS_ACCESS_KEY_ID+x} ]; then 
	echo "AWS_ACCESS_KEY_ID is unset";
	AWS_ACCESS_KEY_ID_ALREADY_SET=false
else 
	echo "AWS_ACCESS_KEY_ID is set to '$AWS_ACCESS_KEY_ID'"; 
	AWS_ACCESS_KEY_ID_ALREADY_SET=true
fi

if [ -z ${AWS_SECRET_ACCESS_KEY+x} ]; then 
	echo "AWS_SECRET_ACCESS_KEY is unset"; 
	AWS_SECRET_ACCESS_KEY_ALREADY_SET=false
else 
	echo "AWS_SECRET_ACCESS_KEY is set to '$AWS_SECRET_ACCESS_KEY'"; 
	AWS_SECRET_ACCESS_KEY_ALREADY_SET=true
fi

if [ -z ${AWS_SESSION_TOKEN+x} ]; then 
	echo "AWS_SESSION_TOKEN is unset"; 
	AWS_SESSION_TOKEN_ALREADY_SET=false
else 
	echo "AWS_SESSION_TOKEN is set to '$AWS_SESSION_TOKEN'"; 
	AWS_SESSION_TOKEN_ALREADY_SET=true
fi

echo

if [ $AWS_ACCESS_KEY_ID_ALREADY_SET = true ] || [ $AWS_SECRET_ACCESS_KEY_ALREADY_SET = true ] || [ $AWS_SESSION_TOKEN_ALREADY_SET = true ]; then
	echo "The already existing variables will be overriden. Continue?"
	read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || return
else
	echo "No existing variables set. Will continue ..."
fi


echo "Getting new MFA access token ..."
CREDJSON="$(aws sts get-session-token --serial-number $1 --token-code $2)"

ACCESSKEY="$(echo $CREDJSON | jq '.Credentials.AccessKeyId' | sed 's/"//g')"
SECRETACESSKEY="$(echo $CREDJSON | jq '.Credentials.SecretAccessKey' | sed 's/"//g')"
SESSIONTOKEN="$(echo $CREDJSON | jq '.Credentials.SessionToken' | sed 's/"//g')"

echo
echo "AccessKeyId:"
echo $ACCESSKEY
echo "SECRETACESSKEY:"
echo $SECRETACESSKEY
echo "SESSIONTOKEN:"
echo $SESSIONTOKEN

echo
echo "Setting values as environment variables ..."
export AWS_ACCESS_KEY_ID=$ACCESSKEY
export AWS_SECRET_ACCESS_KEY=$SECRETACESSKEY
export AWS_SESSION_TOKEN=$SESSIONTOKEN
echo "Done."
