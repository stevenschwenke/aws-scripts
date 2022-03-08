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
         echo "This will unset the following environment variables:"
 		 echo
		 echo "	AWS_ACCESS_KEY_ID"
		 echo "	AWS_SECRET_ACCESS_KEY"
		 echo "	AWS_SESSION_TOKEN"
		 echo
		 echo "To be able to change environment variables, this script has to be executed with 'source' like this:"
		 echo "source ./aws-unset-mfa-access-token.sh"
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
	echo "source ./aws-unset-mfa-access-token.sh"
	exit
fi

echo "Removing AWS_ACCESS_KEY_ID from environment variables ..."
unset AWS_ACCESS_KEY_ID
echo "Removing AWS_SECRET_ACCESS_KEY from environment variables ..."
unset AWS_SECRET_ACCESS_KEY
echo "Removing AWS_SESSION_TOKEN from environment variables ..."
unset AWS_SESSION_TOKEN

