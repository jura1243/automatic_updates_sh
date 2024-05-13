# Automatic updates for drupal via bash script

The script is intended for shared hosting. It was tested on beget hosting and drupal 10. We keep in mind that you have a dayly automatic backups tuned. You have to pinn your current drupal version. Before launching the script tune paths and email on the beginning. You can launch the script via cron every day. The script creates a temporary file with name "file". 

Скрипт для разделяемого хостинга. подразумевается что настроены автоматические ежедневные недельные бэкапы. Нужно закрепить текущую версию друпала. чтоб не переходил на другие версии. Надо подправить переменные пути и почту для отправки. Запускать можно через cron каждый день: /bin/bash ~/dev.zoroastrian.ru/automatic_updates_sh/checkforupdates.sh . Создается временный файл для почты file .

перевод на английский и описание обновлю.
