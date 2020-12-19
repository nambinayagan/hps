#!/bin/bash/

rm -f newdetails1.txt
rm -f phpversionapinew.txt
rm -f phpversionapi_finalnew.txt
rm -f phpversionapi_finalnew1.txt
hostname > server_namefile.txt
serv=$( cat server_namefile.txt )
whmapi1 php_get_vhost_versions | egrep "version:|vhost:|account_owner:|account:" | cut -d ":" -f 2- | paste -d, - - - - >> phpversionapinew.txt
sed -e "s/^/"$serv",/" phpversionapinew.txt > phpversionapi_finalnew.txt
#cat phpversionapi_finalnew.txt | wc -l
cat phpversionapi_finalnew.txt | grep -v "1,,," > phpversionapi_finalnew1.txt
#cat phpversionapi_finalnew1.txt | wc -l
sed -e 's/, /_/g' phpversionapi_finalnew1.txt > names7.txt

for file in $( cat names7.txt )
do
mytext2=$( echo $file | cut -d "_" -f 3 )
mytext3=$( grep $mytext2 /etc/trueuserdomains | cut -d ":" -f 1 )
echo $file _$mytext3 >> newdetails1.txt
done
cat newdetails1.txt
