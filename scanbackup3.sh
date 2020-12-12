#!/bin/bash
SECONDS=0
echo Enter username or domain name         #Input
read username
ui $username | grep "Doc Root" | cut -d":" -f2 > docrot.txt
isuser=$( cat docrot.txt | wc -l )
if [ "$isuser" -eq 0 ];                                                           #if [ -f "$mytext3" ];
then
echo "Try again"
return
fi
echo "Checking for common malicious files for $username in all backup"
echo -e " \n"
echo "#######################################################################################"
var=$( cat docrot.txt )
docurt="${var%/public_html*}"
mytext2="${var%public_html*}malware.txt"
echo $mytext2 > ding.txt
mytext3=$( cat ding.txt )
mytext4=$( cat $mytext3 | grep $username | wc -l )
rm -f /root/nex3.txt 2> /dev/null
rm -f /root/docrot.txt 2> /dev/null
rm -f /root/ding.txt 2> /dev/null
rm -f /root/nex4.txt 2> /dev/null
rm -f /root/present.txt 2> /dev/null
rm -f $docurt/malware_new.txt 2> /dev/null
rm -f $docurt/malware_new2.txt 2> /dev/null
if [ "$mytext4" -gt 100 ];
then
echo "$mytext3 file exist and has more than 100 malicious files in it. So exiting"
return
fi
if [ "$mytext4" -gt 0 ];                                                           #if [ -f "$mytext3" ];
then
echo "$mytext3 file exist and has $mytext4 malware files"
echo -e " \n"
echo "#######################################################################################"
cat $mytext2 | awk '{ print $1 }' >> $docurt/malware_new.txt
rev $docurt/malware_new.txt | cut -c2- |rev >> $docurt/malware_new2.txt
for file in $(cat $docurt/malware_new2.txt);
do
mytext="$file"
echo ${mytext#*$username/} >> nex3.txt
done
rm -f datesop.txt
sshrestore --list -u $username | grep $username | grep -v seed | cut -f1 -d":" >> datesop.txt
isbackup=$( cat datesop.txt | wc -l )
if [ "$isbackup" -eq 0 ];
then
echo "No backup available"
return
fi
for file in $(cat datesop.txt);
do
daypath="$file/homedir/"
echo $daypath
cd $daypath
for file in $(cat /root/nex3.txt);
do
ll $file 2>/dev/null >> /root/present.txt
done
cat /root/present.txt
rm -f /root/present.txt 2> /dev/null
echo -e " \n"
echo "#######################################################################################"
done
cd
else
echo "$mytext3 does not exist or there is no malware files specified in $mytext3 file"
fi
duration=$SECONDS
echo "The script took $(($duration / 60)) minutes and $(($duration % 60)) seconds to check the presence of $mytext4 infected file in backup"
