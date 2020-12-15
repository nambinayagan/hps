#!/bin/bash
###################              Author: Nambinayagan                 ################
SECONDS=0
echo Enter username of the cPanel account         #Input
read username
mkdir -p /root/scanbkscript/$username
ui $username | grep "Doc Root" | cut -d":" -f2 > /root/scanbkscript/$username/docroot.txt
isuser=$( cat /root/scanbkscript/$username/docroot.txt | wc -l )
if [ "$isuser" -eq 0 ];                                                           #if [ -f "$mytext3" ];
then
echo "Try again"
return
fi
mkdir -p /root/scanbkscript/$username
echo "Checking for common malicious files for $username in all backup"
echo -e " \n"
echo "#######################################################################################"
var=$( cat /root/scanbkscript/$username/docroot.txt )
docurt="${var%/public_html*}"
mytext2="${var%public_html*}malware.txt"
echo $mytext2 > /root/scanbkscript/$username/ding.txt
mytext3=$( cat /root/scanbkscript/$username/ding.txt )
mytext4=$( cat $mytext3 | grep $username | wc -l )
rm -f /root/scanbkscript/$username/nex3.txt 2> /dev/null
rm -f /root/scanbkscript/$username/docroot.txt 2> /dev/null
rm -f /root/scanbkscript/$username/ding.txt 2> /dev/null
rm -f /root/scanbkscript/$username/nex4.txt 2> /dev/null
rm -f /root/scanbkscript/$username/present.txt 2> /dev/null
rm -f /root/scanbkscript/$username/malware_new.txt 2> /dev/null
rm -f /root/scanbkscript/$username/malware_new2.txt 2> /dev/null
rm -f /root/scanbkscript/$username/malware_new3.txt 2> /dev/null
#if [ "$mytext4" -gt 100 ];
#then
#echo "$mytext3 file exist and has more than 100 malicious files in it. So exiting"
#return
#fi
if [ "$mytext4" -gt 0 ];
then
echo "$mytext3 file exist and has $mytext4 malware files"
echo -e " \n"
echo "#######################################################################################"
cat $mytext2 | awk '{ print $1 }' >> /root/scanbkscript/$username/malware_new.txt
rev /root/scanbkscript/$username/malware_new.txt | cut -c2- |rev >> /root/scanbkscript/$username/malware_new2.txt
cp /root/scanbkscript/$username/malware_new2.txt /root/scanbkscript/$username/malware_new3.txt
mytext5=$( cat /root/scanbkscript/$username/malware_new2.txt | grep $username | wc -l )
if [ "$mytext5" -gt 500 ];
then
rm -f /root/scanbkscript/$username/malware_new3.txt
cat /root/scanbkscript/$username/malware_new2.txt | head -500 > /root/scanbkscript/$username/malware_new3.txt
echo "Checking only for first 500 files in malware.txt as the limit is exceeded"
fi


for file in $(cat /root/scanbkscript/$username/malware_new3.txt);
do
mytext="$file"
echo ${mytext#*$username/} >> /root/scanbkscript/$username/nex3.txt
done
rm -f /root/scanbkscript/$username/datesop.txt
sshrestore --list -u $username | grep $username | grep -v seed | cut -f1 -d":" >> /root/scanbkscript/$username/datesop.txt
isbackup=$( cat /root/scanbkscript/$username/datesop.txt | wc -l )
if [ "$isbackup" -eq 0 ];
then
echo "No backup available"
return
fi
for file in $(cat /root/scanbkscript/$username/datesop.txt);
do
daypath="$file/homedir/"
echo $daypath
cd $daypath
for file in $(cat /root/scanbkscript/$username/nex3.txt);
do
ll $file 2>/dev/null >> /root/scanbkscript/$username/present.txt
done
cat /root/scanbkscript/$username/present.txt
rm -f /root/scanbkscript/$username/present.txt 2> /dev/null
echo -e " \n"
echo "#######################################################################################"
done
cd
else
echo "$mytext3 does not exist or there is no malware files specified in $mytext3 file"
fi
duration=$SECONDS
red=`tput setaf 1`
green=`tput setaf 2`
echo "The script took${green} $(($duration / 60)) minutes and $(($duration % 60)) seconds ${reset} to check the presence of $mytext4 infected file in backup"

echo "#######################################################################################"

echo "${red}Note: The script only checks if the files listed in malware.txt. So a infected file which is not listed in malware.txt will not be detected by the script${reset}"
echo -e "\e[3;4;33m${red}It is always recommended to inform the customer to get their website code checked with a professional website security expert as the same vulnerabilities that were exploited to hack the website might be present in the backup.${reset}\n\e[0m"
echo "#######################################################################################"
