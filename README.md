# automatic_updates_sh
automatic updates for drupal via bash script

Скрипт для разделяемого хостинга. подразумевается что настроены автоматические ежедневные недельные бэкапы.

Нужно закрепить текущую версию друпала. чтоб не переходил на другие версии.

Надо подправить переменные пути и почту для отправки

Запускать можно в cron е каждые 2 дня: /bin/bash ~/dev.zoroastrian.ru/automatic_updates_sh/checkforupdates.sh

Создается временный файл для почты file .
