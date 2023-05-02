#!/bin/bash

# Modify this to your username
USERNAME=steven

if [ ${BASH_SOURCE[0]} == ${0} ]
then
	SOURCED=false
else
	SOURCED=true
fi

Help() {
echo "This will help you set a AWS profile."
echo
echo "-l   list all your profiles"
echo "name set a profile with a name"
}

while getopts ":h :l :s" option; do
   case $option in
      h) # Display help
         Help
         exit;;
      l)
   		echo "Your AWS profiles:"
		echo
		cat /home/steven/.aws/credentials | grep "\[" | tail -n +2
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
	echo "To make these changes permanent, call this script source'd like this:"
	echo "source ./aws-set-profile.sh"
	exit
else
	echo "Setting profile with name $1:"
	export AWS_PROFILE=$1
	echo
	echo "Executing 'env | grep AWS_PROFILE':"
	env | grep AWS_PROFILE
	echo
	echo "You may also call 'aws sts get-caller-identity' to show your AWS account ID."
	return
fi




