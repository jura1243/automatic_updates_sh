#!/bin/bash
#check the updates
#send email if needed
#update if needed and send email on error


#which php
pathtophp=/usr/local/php/cgi/8.2/bin
#which composer
pathtocomposer=~/.local/bin
#which sendmail
#pathtosendmail=/usr/sbin
sendmailwithpath=$(which sendmail)
folderofdrupal=~/mysitefolder

emailfrom=do-not-reply@mysitedomain.ru
emailto=tome@yandex.ru

#0-send email 1-dont send
noemail=0
#0-upgrade 1-dont upgrade
noupgrade=0

cd $folderofdrupal

$pathtophp/php $pathtocomposer/composer update -W --dry-run &>$folderofdrupal/automatic_updates_sh/file
if grep  Upgrading  $folderofdrupal/automatic_updates_sh/file; then

#to send email
if [ $noemail -eq 0 ]; then
    echo -e "Content-Type: text/plain\r\nFrom: $emailfrom\r\nSubject: Available updates\r\n\r\n"|cat - $folderofdrupal/automatic_updates_sh/file| $sendmailwithpath -f $emailfrom $emailto
    retVal=$?
    if [ $retVal -ne 0 ]; then
        echo "email send error"
    else
        echo "email sent"
    fi
fi

#to update the site
if [ $noupgrade -eq 0 ]; then
    $pathtophp/php $folderofdrupal/vendor/bin/drush state:set system.maintenance_mode 1 --input-format=integer
    $pathtophp/php $pathtocomposer/composer update -W
    $pathtophp/php $folderofdrupal/vendor/bin/drush updatedb --cache-clear --yes
    retVal=$?
    if [ $retVal -ne 0 ]; then
        echo "updb error"
        echo -e "Content-Type: text/plain\r\nFrom: $emailfrom\r\nSubject: error on updb\r\n\r\n"|echo "error on updb\r\n from checkforupdates.sh"| $sendmailwithpath -f $emailfrom $emailto
    fi
    $pathtophp/php $folderofdrupal/vendor/bin/drush cache:rebuild
    $pathtophp/php $folderofdrupal/vendor/bin/drush state:set system.maintenance_mode 0 --input-format=integer
fi

else
    echo no updates
fi
