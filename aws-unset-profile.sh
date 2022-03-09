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
         echo "This will unset the following environment variable:"
 		 echo
		 echo "	AWS_PROFILE"
		 echo
		 echo "To be able to change environment variables, this script has to be executed with 'source' like this:"
		 echo "source ./aws-unset-profile.sh"
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
	echo "source ./aws-unset-profile.sh"
	exit
fi

echo "Removing AWS_PROFILE from environment variables ..."
unset AWS_PROFILE
echo "Done."