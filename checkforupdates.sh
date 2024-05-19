#to check the updates, send email and update

pathtophp=/usr/local/php/cgi/8.2/bin
pathtocomposer=~/.local/bin
folderofdrupal=~/dev.zoroastrian.ru

emailfrom=do-not-reply@zoroastrian.ru
emailto=jurawww@yandex.ru

#0-send email 1-dont send
noemail=0
#0-upgrade 1-dont upgrade
noupgrade=0

cd $folderofdrupal

$pathtophp/php $pathtocomposer/composer update -W --dry-run &>$folderofdrupal/automatic_updates_sh/file
if grep  Upgrading  $folderofdrupal/automatic_updates_sh/file; then

#to send email
if [ $noemail -eq 0 ]; then
    echo -e "Content-Type: text/plain\r\nFrom: $emailfrom\r\nSubject: Available updates\r\n\r\n"|cat - $folderofdrupal/automatic_updates_sh/file| /usr/local/bin/sendmail -f $emailfrom $emailto
    retVal=$?
    if [ $retVal -ne 0 ]; then
        echo "email send error"
    else
        echo "email sent"
    fi
fi

#to update the site
if [ $noupgrade -eq 0 ]; then
    cd $folderofdrupal
    $pathtophp/php $folderofdrupal/vendor/bin/drush state:set system.maintenance_mode 1 --input-format=integer
    $pathtophp/php $pathtocomposer/composer update -W
    $pathtophp/php $folderofdrupal/vendor/bin/drush updb --yes
    $pathtophp/php $folderofdrupal/vendor/bin/drush cache:rebuild
    $pathtophp/php $folderofdrupal/vendor/bin/drush state:set system.maintenance_mode 0 --input-format=integer
fi

else
    echo no updates
fi
