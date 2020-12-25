bash << 'EOF'
user1="atestvwk"
#echo Enter username
#read user1
docroot1=$( /root/bin/ui $user1 | grep "Doc Root" | cut -d":" -f2 )
[ -z "$docroot1" ] && exit;
docroot2=$( echo $docroot1 | sed 's/public_html//g' )
title1="###################################################"
COLUMNS=$(tput cols)
printf "%*s\n" $(((${#title1}+$COLUMNS)/2)) "$title1"
title="Complete Disk usage"
printf "%*s\n" $(((${#title}+$COLUMNS)/2)) "$title"
#echo -e "#############################################################################"
title1="###################################################"
printf "%*s\n" $(((${#title1}+$COLUMNS)/2)) "$title1"
#echo "Complete disk usage"
du -hac $docroot2  | sort -rh | head -100
#printf "hello"
printf "%*s\n" $(((${#title1}+$COLUMNS)/2)) "$title1"
title2="Disk usage by Mail"
printf "%*s\n" $(((${#title2}+$COLUMNS)/2)) "$title2"
printf "%*s\n" $(((${#title1}+$COLUMNS)/2)) "$title1"

du -hac $docroot2/mail  | sort -rh | head -25
printf "%*s\n" $(((${#title1}+$COLUMNS)/2)) "$title1"

#echo -e "#############################################################################"
EOF
