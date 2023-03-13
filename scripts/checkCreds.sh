#!/bin/bash

#Check for invalid args
if [[ $# -ne 2 ]]; then
	printf "Invalid args\n"
	exit 1
fi

usern=$(echo "$1" | tr '[:upper:]' '[:lower:]')
passw=$2
#Check if username is correct
check=$(cat /etc/passwd | grep -E ^$usern:)
if [[ $check == "" ]]; then
	exit 1
fi
check=$(cat /home/$usern/.secret)
#check if pass is correct
if [[ $check != $passw ]]; then
	exit 1
fi
exit 0
