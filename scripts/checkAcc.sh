#!/bin/bash

#Check for invalid command-line args
if [[ $# -ne 2 ]]; then
	printf "Invalid number of args. USAGE: PATH string typeInt\n"
	exit 1
fi
#Check Account
if [[ $2 -eq 0 ]]; then
	un=$1 
	slen=${#un}
	if [[ $slen -lt 4 ]]; then 
		printf "ERROR: The given dir/username has a length of $slen. Usernames can only have a length between 4 and 10.\n"
		exit 1
	fi
	if [[ $slen -gt 10 ]]; then 
		printf "ERROR: The given dir/username has a length of  $slen. Usernames can only have a length between 4 and 10.\n"
		exit 1
	fi
	regex=^[a-zA-Z]+$
	if ! [[ $1 =~ $regex ]]; then
		printf "ERROR: Username must only contain alphabetic characters.\n"
		exit 1
	fi
	exist=$(ls /var/www/html/ActiveFiles | grep -i ^$un$)
	if [[ $exist != "" ]]; then
		printf "ERROR: The given dir/username is already in use. Please try another name.\n"
		exit 1
	fi

	exit 0
fi
#Check Password
if [[ $2 -eq 1 ]]; then 
	pw=$1
	if [[ $pw == "np" ]]; then
		exit 0
	fi
	slen=${#pw}
	valid=true
	if [[ $slen -lt 8 ]]; then
		printf "ERROR: The given password has a length of $slen. Passwords can only have a length between 8 and 50.\n"
		valid=false
	fi
	if [[ $slen -gt 50 ]]; then 
		printf "ERROR: The given password has a length of $slen. Passwords can only have a length between 8 and 50.\n"
		valid=false 
	fi
	regex=[\#\%\^\&\*]
	if ! [[ $pw =~ $regex ]]; then
		printf "ERROR: Given password does not contain a special character. Please review password complexity requirements.\n"
		valid=false
	fi
	regex=[A-Z]
	if ! [[ $pw =~ $regex ]]; then 
		printf "ERROR: Given password does not contain at least one uppercase character.\n"
		valid=false 
	fi
	regex=[a-z]
	if ! [[ $pw =~ $regex ]]; then  
                printf "ERROR: Given password does not contain at least one lowercase character.\n"
		valid=false 
        fi
	regex=[0-9]
	if ! [[ $pw =~ $regex ]]; then  
                printf "ERROR: Given password does not contain at least one numeric character.\n"
		valid=false 
    fi
	#regex=^[0-9a-zA-Z\#\%\^\&\*]+$
	#if ! [[ $pw =~ $regex ]]; then
	#	printf "ERROR: Given password contains illegal characters.\n"
	#	valid=false
	#fi

	if [[ $valid == true ]]; then
		exit 0
	fi
	exit 1
fi
#Check TTL
if [[ $2 -eq 2 ]]; then
	ttl=$1
	regex=^[1-2]{0,1}[0-9]$
	if ! [[ $ttl =~ $regex ]]; then 
		printf "ERROR: Given time to live of dir is not a whole numbter between 1 and 24 (inclusive).\n"	
		exit 1
	fi
	checkt=$(($ttl))
	if [[ $checkt -lt 1 ]] || [[ $checkt -gt 24 ]]; then
		printf "ERROR: Given time to live of dir is not a whole number between 1 and 24 (inclusive).\n"
		exit 1
	fi
	exit 0
fi

