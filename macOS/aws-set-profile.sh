#!/bin/zsh

# From https://stackoverflow.com/questions/2683279/how-to-detect-if-a-script-is-being-sourced
 is_sourced() {
   if [ -n "$ZSH_VERSION" ]; then
       case $ZSH_EVAL_CONTEXT in *:file:*) return 0;; esac
   else  # Add additional POSIX-compatible shell names here, if needed.
       case ${0##*/} in dash|-dash|bash|-bash|ksh|-ksh|sh|-sh) return 0;; esac
   fi
   return 1  # NOT sourced.
 }

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
		cat ~/.aws/credentials | grep "\[" | tail -n +2
        if is_sourced
		then
			return
		else
			exit
		fi
		;;
   esac
done

if ! is_sourced
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




