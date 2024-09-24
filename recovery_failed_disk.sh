#!/usr/bin/env bash

REMOTE_HOST="postgres1@pg188"

BACKUPS_DIR="backups"

PGPATH="dpf79"
TABLESPACE1_DIR="dvm64"
TABLESPACE2_DIR="hmd60"
TABLESPACE3_DIR="iqp71"
WAL_DIR="gvg44"

NEW_PGPATH="dpf79.new"

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

ssh $REMOTE_HOST "pg_ctl stop -D ~/$PGPATH"


rsync -avz $BACKUPS_DIR/"$BACKUP_NAME"/"$PGPATH"/* $REMOTE_HOST:~/"$NEW_PGPATH"
rsync -avz $BACKUPS_DIR/"$BACKUP_NAME"/"$TABLESPACE1_DIR"/* $REMOTE_HOST:~/"$TABLESPACE1_DIR"
rsync -avz $BACKUPS_DIR/"$BACKUP_NAME"/"$TABLESPACE2_DIR"/* $REMOTE_HOST:~/"$TABLESPACE2_DIR"
rsync -avz $BACKUPS_DIR/"$BACKUP_NAME"/"$TABLESPACE3_DIR"/* $REMOTE_HOST:~/"$TABLESPACE3_DIR"
rsync -avz $BACKUPS_DIR/"$BACKUP_NAME"/"$WAL_DIR"/* $REMOTE_HOST:~/"$WAL_DIR"


ssh $REMOTE_HOST "
  chmod 750 \$HOME/$NEW_PGPATH/
  ln -sF \$HOME/$TABLESPACE1_DIR/ \$HOME/$NEW_PGPATH/pg_tblspc/16385
  ln -sF \$HOME/$TABLESPACE2_DIR/ \$HOME/$NEW_PGPATH/pg_tblspc/16386
  ln -sF \$HOME/$TABLESPACE3_DIR/ \$HOME/$NEW_PGPATH/pg_tblspc/16387
  ln -sF \$HOME/$WAL_DIR/ \$HOME/$NEW_PGPATH/pg_wal
  chmod 777 \$HOME/$TABLESPACE1_DIR/ \$HOME/$TABLESPACE2_DIR/ \$HOME/$TABLESPACE3_DIR/ \$HOME/$WAL_DIR/
  pg_ctl start -l /dev/null -D $NEW_PGPATH
"

