#!/bin/bash

#Checks how many directories are currently deployed
check=$(ls /var/www/html/ActiveFiles | wc -l)
if [[ $check -gt 20 ]]; then 
	exit 1
fi
exit 0
