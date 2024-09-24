#!/usr/bin/env bash

REMOTE_HOST="postgres1@pg188"

BACKUPS_DIR="backups"

if [ $# -eq 0 ];
then
    if [ "$(ls $BACKUPS_DIR | wc -l)" -eq 0 ];
    then
        exit
    fi
    BACKUP_NAME=$(ls $BACKUPS_DIR | tail -1)
else
    BACKUP_NAME=$1
fi

ssh $REMOTE_HOST "pg_ctl stop -D $"

rsync -avz $BACKUPS_DIR/"$BACKUP_NAME"/* $REMOTE_HOST:~/

