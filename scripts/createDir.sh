#!/bin/bash

#Check for invalid args
if [[ $# -ne 3 ]]; then
	printf "USAGE usern passw TTL\n"
	exit 1
fi
#Set vars
usern=$(echo $1 | tr '[:upper:]' '[:lower:]')
passw=$2
ttl=$3
#Create dir
mkdir "/var/www/html/ActiveFiles/$usern"
path="/var/www/html/ActiveFiles/$usern/"
#Create user and create pass file
adduser $usern > /dev/null
echo $passw | passwd $usern --stdin >/dev/null
touch /home/$usern/.secret
chmod 400 /home/$usern/.secret #Only root can read
echo $passw >> /home/$usern/.secret

#Check if password protected and set protection
if [[ $passw != "np" ]]; then
	if [[ -f "/etc/httpd/.htpasswd" ]]; then 
		htpasswd -b /etc/httpd/.htpasswd $usern $passw
	else
		htpasswd -b -c /etc/httpd/.htpasswd $usern $passw
	fi	
	touch "$path.htaccess"
	chown apache: "$path.htaccess"
	echo "AddDefaultCharset utf-8" >> "$path.htaccess"
	echo "Options +Indexes" >> "$path.htaccess"
	echo "AuthType Basic" >> "$path.htaccess"
	echo "AuthName \"$usern dir login\"" >> "$path.htaccess"
	echo "AuthUserFile /etc/httpd/.htpasswd" >> "$path.htaccess"
	echo "Require user $usern" >> "$path.htaccess"
fi
#Create cronjob and script to delete everything based on TTL
timeAdd=$(($ttl*60*60))
currEpoch=$(date +"%s")
killTime=$(($currEpoch+$timeAdd))
conv=$(date -d @$(($killTime)))
dayow=$(echo $conv | cut -d ' ' -f1)
monoy=$(echo $conv | cut -d ' ' -f2)
dayom=$(echo $conv | cut -d ' ' -f3)
gtime=$(echo $conv | cut -d ' ' -f4)
hours=$(echo $gtime | cut -d ':' -f1)
mins=$(echo $gtime | cut -d ':' -f2)

if [[ ${#mins} -eq 2 ]] && [[ ${mins:0:1} == '0' ]]; then
        mins=${mins:1:1}
fi

if [[ ${#hours} -eq 2 ]] && [[ ${hours:0:1} == '0' ]]; then
        hours=${hours:1:1}
fi

declare -A dow=( ["Sun"]="0" ["Mon"]="1" ["Tue"]="2" ["Wed"]="3" ["Thu"]="4" ["Fri"]="5" ["Sat"]="6")
declare -A moy=( ["Jan"]="1" ["Feb"]="2" ["Mar"]="3" ["Apr"]="4" ["May"]="5" ["Jun"]="6" ["Jul"]="7" ["Aug"]="8" ["Sep"]="9" ["Oct"]="10"["Nov"]="11" ["Dec"]="12")

dayow=${dow[$dayow]}
monoy=${moy[$monoy]}

echo "$mins $hours $dayom $monoy $dayow sudo /var/www/html/scripts/cleanAcc.sh $usern" >> /var/spool/cron/apache




