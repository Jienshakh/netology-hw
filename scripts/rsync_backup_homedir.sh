#!/bin/bash

HOME_DIR=/home/jien/

BACKUP_DIR=/tmp/backup/

rsync -avh -c --progress --delete  $HOME_DIR $BACKUP_DIR

# Записываем результат в системный лог
if [ $? -eq 0 ]; then
    logger -t "BACKUP_DIR" "Резервное копирование успешно завершено."
else
    logger -t "BACKUP_DIR" "Ошибка резервного копирования!"
fi
