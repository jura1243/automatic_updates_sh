#to check the updates, send email and update

pathtophp=/usr/local/php/cgi/8.2/bin
pathtocomposer=~/.local/bin
folderofdrupal=~/dev.zoroastrian.ru

emailfrom=do-not-reply@zoroastrian.ru
emailto=jurawww@yandex.ru

cd $folderofdrupal

$pathtophp/php $pathtocomposer/composer update -W --dry-run &>$folderofdrupal/automatic_updates_sh/file
if grep updates  $folderofdrupal/automatic_updates_sh/file; then

#to send email
    echo -e "Content-Type: text/plain\r\nFrom: $emailfrom\r\nSubject: Available updates\r\n\r\n"|cat - ./file| /usr/local/bin/sendmail -f $emailfrom $emailto
    retVal=$?
    if [ $retVal -ne 0 ]; then
        echo "email send error"
    else
        echo "email sent"
    fi

#to update the site
    cd $folderofdrupal
    $pathtophp/php vendor/bin/drush state:set system.maintenance_mode 1 --input-format=integer
    $pathtophp/php $pathtocomposer/composer update -W
    $pathtophp/php vendor/bin/drush updb --yes
    $pathtophp/php vendor/bin/drush cache:rebuild
    $pathtophp/php vendor/bin/drush state:set system.maintenance_mode 0 --input-format=integer

else
    echo no updates
fi
