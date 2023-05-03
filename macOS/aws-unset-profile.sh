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

while getopts ":h" option; do
   case $option in
      h) # Display help
         echo "This will unset the following environment variable:"
 		 echo
		 echo "	AWS_PROFILE"
		 echo
		 echo "To be able to change environment variables, this script has to be executed with 'source' like this:"
		 echo "source ./aws-unset-profile.sh"
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
	echo "You are not running this script as source."
	echo "To make these changes permanent, call this script source'd like this:"
	echo "source ./aws-unset-profile.sh"
	exit
fi

echo "Removing AWS_PROFILE from environment variables ..."
unset AWS_PROFILE
echo "Done."