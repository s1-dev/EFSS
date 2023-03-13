#!/bin/bash

#Check for invalid args
if [[ $# -ne 1 ]];  then
	printf "Error: invalid args\n"
	exit 1
fi

usern=$1
#Delete all files uploaded and dir
rm -r -f /var/www/html/ActiveFiles/$usern
#Delete user and all login configuration
userdel -r -f $usern > /dev/null
if [[ -f "/etc/httpd/.htpasswd" ]]; then
	check=$(cat /etc/httpd/.htpasswd | grep -E ^$usern:)
	if [[ $check != "" ]]; then
		linec=$(cat /etc/httpd/.htpasswd | wc -l)
		if [[ $linec -eq 1 ]]; then
			rm -f /etc/httpd/.htpasswd
		else
			cat /etc/httpd/.htpasswd | grep -v ^$usern: > /etc/httpd/tmp.htpasswd && mv -f /etc/httpd/tmp.htpasswd /etc/httpd/.htpasswd
			rm -f /etc/httpd/tm.htpasswd
		fi
	fi
fi
#Remove cronjob from apache file
check=$(cat /var/spool/cron/apache | grep -E $usern$)
if [[ $check != "" ]]; then 
	cat /var/spool/cron/apache | grep -v $usern$ > /var/www/html/logs/tmpcron && mv -f /var/www/html/logs/tmpcron /var/spool/cron/apache
	rm -f /var/www/html/logs/tmpcron
fi
 
