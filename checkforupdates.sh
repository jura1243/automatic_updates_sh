#!/bin/bash
#check the updates
#send email if needed
#update if needed and send email on error

#prefer programs
#add path to php and composer and drush in $PATH in your .bashrc
#for example export PATH=/usr/local/php/cgi/8.3/bin:$HOME/.local/bin:$HOME/mysitefolder/vendor/bin:$PATH

#tune paths
#which php
pathtophp=/usr/local/php/cgi/8.3/bin
#which composer
pathtocomposer=~/.local/bin
sendmailwithpath=$(which sendmail)
folderofdrupal=~/mysitefolder

#tune settings
emailfrom=do-not-reply@mysitedomain.ru
emailto=tome@yandex.ru
#0-send email 1-dont send
noemail=0
#0-upgrade 1-dont upgrade
noupgrade=0

#1-send email 0-dont send
email=1
#1-upgrade 0-dont upgrade
upgrade=1


#begin of the program
cd $folderofdrupal

$pathtocomposer/composer update -W --dry-run &>$folderofdrupal/automatic_updates_sh/file
if grep  Upgrading  $folderofdrupal/automatic_updates_sh/file; then

#to send email
if [ $email -eq 1 ]; then
    echo -e "Content-Type: text/plain\r\nFrom: $emailfrom\r\nSubject: Available updates\r\n\r\n"|cat - $folderofdrupal/automatic_updates_sh/file| $sendmailwithpath -f $emailfrom $emailto
    retVal=$?
    if [ $retVal -ne 0 ]; then
        echo "email send error"
    else
        echo "email sent"
    fi
fi

#to update the site
if [ $upgrade -eq 1 ]; then
    $folderofdrupal/vendor/bin/drush state:set system.maintenance_mode 1 --input-format=integer
    $pathtocomposer/composer update -W
    $folderofdrupal/vendor/bin/drush updatedb --cache-clear --yes
    retVal=$?
    if [ $retVal -ne 0 ]; then
        echo "updb error"
        echo -e "Content-Type: text/plain\r\nFrom: $emailfrom\r\nSubject: error on updb\r\n\r\n"|echo "error on updb\r\n from checkforupdates.sh"| $sendmailwithpath -f $emailfrom $emailto
    fi
    $folderofdrupal/vendor/bin/drush cache:rebuild
    $folderofdrupal/vendor/bin/drush state:set system.maintenance_mode 0 --input-format=integer
fi

else
    echo no updates
fi
