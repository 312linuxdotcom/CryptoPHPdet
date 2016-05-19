#!/bin/bash
#This is a generic social.png scanner for php tags. If it hits on any files, they are more than likely infected with cryptoPHP
#There are other scripts that are more thorough. The purpose of the script is to quickly identify which user on a multi-tenant server is infected. Using Fox-IT scripts can take days whereas this script should take an hour or so.
mailto=youremail@example.com
sociallist=/root/social.list
sedlist=/root/sed.list
cryptohits=/root/cryptophp.hits
cryptolog=/var/log/cryptophp.log
#update the locate database, locate social.png files and log them to file
`which updatedb` && `which locate` social.png > $sociallist

#Escape the annoying whitespace from filename, which previously broke this script
`which sed` 's/ /\\ /g' $sociallist > $sedlist

#Seach for php tags inside of social.png files and log the hits
#for i in `grep -v virtfs $sociallist`; do `which file` $i |grep -i php | uniq ;done > $cryptohits
`which grep` -v virtfs $sedlist | `which xargs` -l `which file` | `which grep` -i php > $cryptohits

#date and log the hitlist
date +%Y%m%d >> $cryptolog; `which cat` $cryptohits >> $cryptolog

#Email execution and cleanup
if [ -s $cryptohits ]
then
mail -s "CryptoPHP Detector $(hostname)" $mailto < $cryptohits
fi
rm -f $cryptohits
rm -f $sedlist
rm -f $sociallist
