#!/bin/bash

timeAdd=$((12*60*60))
echo $timeAdd
currEpoch=$(date +"%s")
echo $currEpoch
killTime=$(($currEpoch+$timeAdd))
echo $killTime
conv=$(date -d @$(($killTime)))
echo $conv
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

echo "$mins $hours $dayom $monoy $dayow sudo /var/www/html/scripts/cleanAcc.sh sean"
