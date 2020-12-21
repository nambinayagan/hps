#!/bin/bash
###################              Author: Nambinayagan                 ################
#SECONDS=0
echo -e "\e[3;4;33mEnter username:\e[0m"         #Input
read username
SECONDS=0
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
rm -f /root/scanbkscript/$username/filediff.txt 2> /dev/null
rm -f /root/scanbkscript/$username/commonfiles.txt 2> /dev/null
rm -f /root/scanbkscript/$username/differentfiles.txt 2> /dev/null
rm -f /root/scanbkscript/$username/identicalfiles.txt 2> /dev/null
#if [ "$mytext4" -gt 100 ];
#then
#echo "$mytext3 file exist and has more than 100 malicious files in it. So exiting"
#return
#fi
if [ "$mytext4" -gt 0 ];
then
echo -e "\e[3;4;33mNumber of infected files in malware.txt:\e[0m $mytext4"
echo -e "\e[3;4;33mScan:\e[0m Started"
#echo -e " \n"
#echo "#######################################################################################"
cat $mytext2 | awk '{ print $1 }' >> /root/scanbkscript/$username/malware_new.txt
rev /root/scanbkscript/$username/malware_new.txt | cut -c2- |rev >> /root/scanbkscript/$username/malware_new2.txt
cp /root/scanbkscript/$username/malware_new2.txt /root/scanbkscript/$username/malware_new3.txt
mytext5=$( cat /root/scanbkscript/$username/malware_new2.txt | grep $username | wc -l )
if [ "$mytext5" -gt 500 ];
then
rm -f /root/scanbkscript/$username/malware_new3.txt
cat /root/scanbkscript/$username/malware_new2.txt | head -500 > /root/scanbkscript/$username/malware_new3.txt
echo -e "\e[3;4;33mLimit of 500 files in malware.txt exceeded\n\e[0m: Yes"
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
#echo $daypath
#cd $daypath
for file in $(cat /root/scanbkscript/$username/nex3.txt);
do
file1="$docurt"/"$file"
file2="$daypath""$file"
if [ -f "$file2" ];
then
diff -sq $file1 $file2 >> /root/scanbkscript/$username/filediff.txt
ll $file2 2>/dev/null >> /root/scanbkscript/$username/present.txt
fi
done
#cat /root/scanbkscript/$username/present.txt

echo "Common files between backup $daypath and $docurt" >> /root/scanbkscript/$username/commonfiles.txt
cat /root/scanbkscript/$username/present.txt >> /root/scanbkscript/$username/commonfiles.txt
echo -e " \n" >> /root/scanbkscript/$username/commonfiles.txt
echo "#######################################################################################" >> /root/scanbkscript/$username/commonfiles.txt
#cp /root/scanbkscript/$username/present.txt /root/scanbkscript/$username/commonfiles.txt
rm -f /root/scanbkscript/$username/present.txt 2> /dev/null
echo "#######################################################################################" >> /root/scanbkscript/$username/identicalfiles.txt
echo "#######################################################################################" >> /root/scanbkscript/$username/differentfiles.txt
echo "Identical files between backup $daypath and $docurt" >> /root/scanbkscript/$username/identicalfiles.txt
cat /root/scanbkscript/$username/filediff.txt | grep identical >> /root/scanbkscript/$username/identicalfiles.txt
echo "Different files between backup $daypath and $docurt" >> /root/scanbkscript/$username/differentfiles.txt
cat /root/scanbkscript/$username/filediff.txt | grep differ >> /root/scanbkscript/$username/differentfiles.txt
echo -e " \n" >> /root/scanbkscript/$username/identicalfiles.txt
echo "#######################################################################################" >> /root/scanbkscript/$username/identicalfiles.txt
echo -e " \n" >> /root/scanbkscript/$username/differentfiles.txt
echo "#######################################################################################" >> /root/scanbkscript/$username/differentfiles.txt
rm -f /root/scanbkscript/$username/filediff.txt 2> /dev/null
#echo -e " \n"
#echo "#######################################################################################"
done
cd
else
echo "$mytext3 does not exist or there is no malware files specified in $mytext3 file"
fi
monthlycount=$(expr $( cat /root/scanbkscript/$username/commonfiles.txt | grep "cpbackup/monthly" | wc -l ) - 1)
weeklycount=$(expr $( cat /root/scanbkscript/$username/commonfiles.txt | grep "cpbackup/weekly" | wc -l ) - 1)
dailycount=$(expr $( cat /root/scanbkscript/$username/commonfiles.txt | grep "cpbackup/daily" | wc -l ) - 1)
monthlycount1=$(expr $( cat /root/scanbkscript/$username/identicalfiles.txt | grep "cpbackup/monthly" | wc -l ) - 1)
weeklycount1=$(expr $( cat /root/scanbkscript/$username/identicalfiles.txt | grep "cpbackup/weekly" | wc -l ) - 1)
dailycount1=$(expr $( cat /root/scanbkscript/$username/identicalfiles.txt | grep "cpbackup/daily" | wc -l ) - 1)
monthlycount2=$(expr $( cat /root/scanbkscript/$username/differentfiles.txt | grep "cpbackup/monthly" | wc -l ) - 1)
weeklycount2=$(expr $( cat /root/scanbkscript/$username/differentfiles.txt | grep "cpbackup/weekly" | wc -l ) - 1)
dailycount2=$(expr $( cat /root/scanbkscript/$username/differentfiles.txt | grep "cpbackup/daily" | wc -l ) - 1)
echo -e "\e[3;4;33mScan:\e[0m Completed"
duration=$SECONDS
red=`tput setaf 1`
green=`tput setaf 2`
reset=$(tput sgr0)
echo -e "\e[3;4;33mTime:\e[0m ${green} $(($duration / 60)) minutes and $(($duration % 60)) seconds ${reset}"
#echo "You can find the list of identical and different files between home directory and backup in following files"
echo -e "\e[3;4;33mNumber of common files:\e[0m    Monthly=$monthlycount   Weekly=$weeklycount   Daily=$dailycount"
echo -e "\e[3;4;33mNumber of identical files:\e[0m Monthly=$monthlycount1   Weekly=$weeklycount1   Daily=$dailycount1"
echo -e "\e[3;4;33mNumber of different files:\e[0m Monthly=$monthlycount2   Weekly=$weeklycount2   Daily=$dailycount2"
echo -e "\e[3;4;33mList of common files:\e[0m /root/scanbkscript/$username/commonfiles.txt"
echo -e "\e[3;4;33mList of indentical files:\e[0m /root/scanbkscript/$username/identicalfiles.txt"
echo -e "\e[3;4;33mList of different files:\e[0m /root/scanbkscript/$username/differentfiles.txt"
echo -e " \n"
echo "#######################################################################################"

echo "${red}Note: The script only checks for the files listed in malware.txt. So a infected file which is not listed in malware.txt will not be detected by the script${reset}"
echo -e "\e[3;4;33m${red}It is always recommended to inform the customer to get their website code checked with a professional website security expert as the same vulnerabilities that were exploited to hack the website might be present in the backup.${reset}\n\e[0m"
echo "#######################################################################################"
