bash << 'EOF'
server="server_placeholder"
user="user_placeholder"

SECONDS=0
mkdir -p /root/scanbkscript/$user         #Make a directory to store data
/root/bin/ui $user | grep "Doc Root" | cut -d":" -f2 > /root/scanbkscript/$user/docroot.txt      #add ui error to /dev/null and also try to take output in variable
isuser=$( cat /root/scanbkscript/$user/docroot.txt | wc -l )
if [[ "$isuser" -eq 0 ]];                    # to check if user exists
        then echo "Try again";
        exit
fi
mkdir -p /root/scanbkscript/$user
echo "Checking for common malicious files for $user in all backup"
echo -e " \n"
COLUMNS=$(tput cols)
printf "%${COLUMNS}s" " " | tr " " "*"
var=$( cat /root/scanbkscript/$user/docroot.txt )
docurt="${var%/public_html*}"
mytext2="${var%public_html*}malware.txt"                #Malware.txt file location
echo $mytext2 > /root/scanbkscript/$user/nambi.txt
mytext3=$( cat /root/scanbkscript/$user/nambi.txt )
mytext4=$( cat $mytext3 | grep $user | wc -l )
rm -f /root/scanbkscript/$user/nex3.txt 2> /dev/null             #Deleting the files if it is already existing
rm -f /root/scanbkscript/$user/docroot.txt 2> /dev/null
rm -f /root/scanbkscript/$user/nambi.txt 2> /dev/null
rm -f /root/scanbkscript/$user/nex4.txt 2> /dev/null
rm -f /root/scanbkscript/$user/present.txt 2> /dev/null
rm -f /root/scanbkscript/$user/malware_new.txt 2> /dev/null
rm -f /root/scanbkscript/$user/malware_new2.txt 2> /dev/null
rm -f /root/scanbkscript/$user/malware_new3.txt 2> /dev/null
rm -f /root/scanbkscript/$user/filediff.txt 2> /dev/null
rm -f /root/scanbkscript/$user/commonfiles.txt 2> /dev/null
rm -f /root/scanbkscript/$user/differentfiles.txt 2> /dev/null
rm -f /root/scanbkscript/$user/identicalfiles.txt 2> /dev/null
if [ "$mytext4" -gt 0 ];
        then
        echo -e "\e[3;4;33mNumber of infected files in malware.txt:\e[0m $mytext4"
        echo -e "\e[3;4;33mScan:\e[0m Started"
        #echo -e " \n"
        #printf "%${COLUMNS}s" " " | tr " " "*"
        cat $mytext2 | awk '{ print $1 }' >> /root/scanbkscript/$user/malware_new.txt
        rev /root/scanbkscript/$user/malware_new.txt | cut -c2- |rev >> /root/scanbkscript/$user/malware_new2.txt
        cp /root/scanbkscript/$user/malware_new2.txt /root/scanbkscript/$user/malware_new3.txt
        mytext5=$( cat /root/scanbkscript/$user/malware_new2.txt | grep $user | wc -l )
        if [ "$mytext5" -gt 100 ];                                                             #Limit set to 100
                then
                rm -f /root/scanbkscript/$user/malware_new3.txt
                cat /root/scanbkscript/$user/malware_new2.txt | head -100 > /root/scanbkscript/$user/malware_new3.txt
                echo -e "\e[3;4;33mLimit of 100 files in malware.txt exceeded\e[0m: Yes"
                echo -e "\e[3;4;33mSo only the top 100 files listed in malware.txt are checked\e[0m"
        fi
        for file in $(cat /root/scanbkscript/$user/malware_new3.txt);
                do
                mytext="$file"
                echo ${mytext#*$user/} >> /root/scanbkscript/$user/nex3.txt
        done
        rm -f /root/scanbkscript/$user/datesop.txt
        /root/bin/sshrestore --list -u $user | grep $user | grep -v seed | cut -f1 -d":" >> /root/scanbkscript/$user/datesop.txt
        isbackup=$( cat /root/scanbkscript/$user/datesop.txt | wc -l )
        if [ "$isbackup" -eq 0 ];
                then
                echo "No backup available to scan"
                exit;
        fi
        for file in $(cat /root/scanbkscript/$user/datesop.txt);
                do
                daypath="$file/homedir/"
                #echo $daypath
                #cd $daypath
                for file in $(cat /root/scanbkscript/$user/nex3.txt);
                        do
                        file1="$docurt"/"$file"
                        file2="$daypath""$file"
                        if [ -f "$file2" ];
                                then
                                diff -sq $file1 $file2 2>/dev/null >> /root/scanbkscript/$user/filediff.txt
                                #echo $file2;
                                #ls -al $file2
                                ls -al $file2 2>/dev/null >> /root/scanbkscript/$user/present.txt;
                                #echo $file2
                        fi
                done
                #cat /root/scanbkscript/$user/present.txt

                echo "Common files between backup $daypath and $docurt" >> /root/scanbkscript/$user/commonfiles.txt
                cat /root/scanbkscript/$user/present.txt >> /root/scanbkscript/$user/commonfiles.txt
                echo -e " \n" >> /root/scanbkscript/$user/commonfiles.txt
                echo "#######################################################################################" >> /root/scanbkscript/$user/commonfiles.txt
                #cp /root/scanbkscript/$user/present.txt /root/scanbkscript/$user/commonfiles.txt
                rm -f /root/scanbkscript/$user/present.txt 2> /dev/null
                echo "#######################################################################################" >> /root/scanbkscript/$user/identicalfiles.txt
                echo "#######################################################################################" >> /root/scanbkscript/$user/differentfiles.txt
                echo "Identical files between backup $daypath and $docurt" >> /root/scanbkscript/$user/identicalfiles.txt
                cat /root/scanbkscript/$user/filediff.txt | grep identical >> /root/scanbkscript/$user/identicalfiles.txt
                echo "Different files between backup $daypath and $docurt" >> /root/scanbkscript/$user/differentfiles.txt
                cat /root/scanbkscript/$user/filediff.txt | grep differ >> /root/scanbkscript/$user/differentfiles.txt
                echo -e " \n" >> /root/scanbkscript/$user/identicalfiles.txt
                echo "#######################################################################################" >> /root/scanbkscript/$user/identicalfiles.txt
                echo -e " \n" >> /root/scanbkscript/$user/differentfiles.txt
                echo "#######################################################################################" >> /root/scanbkscript/$user/differentfiles.txt
                rm -f /root/scanbkscript/$user/filediff.txt 2> /dev/null
                #echo -e " \n"
                #printf "%${COLUMNS}s" " " | tr " " "*"
        done
        #cd
        #echo loop completed;
        #else
        #echo "$mytext3 does not exist or there is no malware files specified in $mytext3 file"
#fi
monthlycount=$(expr $( cat /root/scanbkscript/$user/commonfiles.txt | grep "cpbackup/monthly" | wc -l ) - 1)
weeklycount=$(expr $( cat /root/scanbkscript/$user/commonfiles.txt | grep "cpbackup/weekly" | wc -l ) - 1)
dailycount=$(expr $( cat /root/scanbkscript/$user/commonfiles.txt | grep "cpbackup/daily" | wc -l ) - 1)
monthlycount1=$(expr $( cat /root/scanbkscript/$user/identicalfiles.txt | grep "cpbackup/monthly" | wc -l ) - 1)
weeklycount1=$(expr $( cat /root/scanbkscript/$user/identicalfiles.txt | grep "cpbackup/weekly" | wc -l ) - 1)
dailycount1=$(expr $( cat /root/scanbkscript/$user/identicalfiles.txt | grep "cpbackup/daily" | wc -l ) - 1)
monthlycount2=$(expr $( cat /root/scanbkscript/$user/differentfiles.txt | grep "cpbackup/monthly" | wc -l ) - 1)
weeklycount2=$(expr $( cat /root/scanbkscript/$user/differentfiles.txt | grep "cpbackup/weekly" | wc -l ) - 1)
dailycount2=$(expr $( cat /root/scanbkscript/$user/differentfiles.txt | grep "cpbackup/daily" | wc -l ) - 1)
echo -e "\e[3;4;33mScan:\e[0m Completed"
mkdir $docurt/backupscanresult 2>/dev/null
cp /root/scanbkscript/$user/differentfiles.txt $docurt/backupscanresult/
cp /root/scanbkscript/$user/identicalfiles.txt $docurt/backupscanresult/
cp /root/scanbkscript/$user/commonfiles.txt $docurt/backupscanresult/
duration=$SECONDS
red=`tput setaf 1`
green=`tput setaf 2`
reset=$(tput sgr0)
echo -e "\e[3;4;33mTime:\e[0m ${green} $(($duration / 60)) minutes and $(($duration % 60)) seconds ${reset}"
echo -e "\e[3;4;33mNumber of common files:\e[0m    Monthly=$monthlycount   Weekly=$weeklycount   Daily=$dailycount"
echo -e "\e[3;4;33mNumber of identical files:\e[0m Monthly=$monthlycount1   Weekly=$weeklycount1   Daily=$dailycount1"
echo -e "\e[3;4;33mNumber of different files:\e[0m Monthly=$monthlycount2   Weekly=$weeklycount2   Daily=$dailycount2"
echo -e "\e[3;4;33mList of common files:\e[0m $docurt/backupscanresult/commonfiles.txt"
echo -e "\e[3;4;33mList of indentical files:\e[0m $docurt/backupscanresult/identicalfiles.txt"
echo -e "\e[3;4;33mList of different files:\e[0m $docurt/backupscanresult/differentfiles.txt"
echo -e " \n"
printf "%${COLUMNS}s" " " | tr " " "*"
title="NOTE"
printf "%*s\n" $(((${#title}+$COLUMNS)/2)) "$title"
echo "${red}The script only checks for the files listed in malware.txt and not malware signature. So a infected file which is not listed in malware.txt will not be detected by the script${reset}"
echo -e "\e[3;4;33m${red}It is always recommended to inform the customer to get their website code checked with a professional website security expert as the same vulnerabilities that were exploited to hack the website might be present in the backup.${reset}\n\e[0m"
printf "%${COLUMNS}s" " " | tr " " "*"
fi
EOF
