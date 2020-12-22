#!/bin/bash/

rm -f newdetails1.txt
rm -f phpversionapinew.txt
rm -f phpversionapi_finalnew.txt
rm -f phpversionapi_finalnew1.txt

serv=$( uname -n )
whmapi1 php_get_vhost_versions | egrep "version:|vhost:|account_owner:|account:" | grep -v "version: 1" | cut -d ":" -f 2- | paste -d, - - - - >> phpversionapinew.txt
sed -i "s/^/"$serv",/" phpversionapinew.txt
sed -i 's/, /_/g' phpversionapinew.txt 

for file in $( cat phpversionapinew.txt )
do
mytext2=$( echo $file | cut -d "_" -f 3 )
mytext3=$( grep $mytext2 /etc/trueuserdomains | cut -d ":" -f 1 )
echo $file _$mytext3 >> newdetails1.txt
done
cat newdetails1.txt
rm -f newdetails1.txt
rm -f phpversionapinew.txt
