############
###########3#!/bin/bash
#to check the updates, send email and update


#exit

pathtophp=/usr/local/php/cgi/8.3/bin
pathtocomposer=/home/j/username/.local/bin
folderofdrupal=/home/j/username/dirofcomposerjson
sendmailwithpath=$(which sendmail)

emailfrom=do-not-reply@zoroastrian.ru
emailto=jurawww@yandex.ru

#0-send email 1-dont send
noemail=0
#0-upgrade 1-dont upgrade
noupgrade=0

#1-send email 0-dont send
email=1
#1-upgrade 0-dont upgrade
upgrade=1

cd $folderofdrupal
# $pathtophp/php vendor/bin/drush.php cron
#exit

$pathtophp/php $pathtocomposer/composer update -W --dry-run &>$folderofdrupal/automatic_updates_sh/file
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
    $pathtophp/php $folderofdrupal/vendor/bin/drush.php state:set system.maintenance_mode 1 --input-format=integer
    $pathtophp/php $pathtocomposer/composer update -W
    $pathtophp/php $folderofdrupal/vendor/bin/drush.php updatedb --cache-clear --yes

    retVal=$?
    if [ $retVal -ne 0 ]; then
        echo "updb error"
        echo -e "Content-Type: text/plain\r\nFrom: $emailfrom\r\nSubject: error on updb\r\n\r\n"|echo "error on updb\r\n from checkforupdates.sh"| $sendmailwithpath -f $emailfrom $emailto
#    else
#        echo "email sent"
    fi

    $pathtophp/php $folderofdrupal/vendor/bin/drush.php cache:rebuild
    $pathtophp/php $folderofdrupal/vendor/bin/drush.php state:set system.maintenance_mode 0 --input-format=integer
fi

else
    echo no updates
fi
$pathtophp/php $folderofdrupal/vendor/bin/drush.php cron
