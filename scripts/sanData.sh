#!/bin/bash

#Check for invalid args
if [[ $# -ne 2 ]]; then
	printf "USAGE filename usern\n"
	exit 1
fi

un=$(echo "$2" | tr '[:upper:]' '[:lower:]')
#Make file online readable and place in the pertinent dir
chmod 444 "/var/www/html/uploads/$1"
mv "/var/www/html/uploads/$1" "/var/www/html/ActiveFiles/$un/$1"
#Confirm functionality
check=$(ls /var/www/html/ActiveFiles/$un/ | grep ^$1$)
if [[ $check == "" ]]; then 
	exit 1
fi
exit 0
