#!/usr/bin/env bash

BACKUPS_DIR="backups"
PGPATH="dpf79"
WAL_DIR="gvg44"
TABLESPACE1_DIR="dvm64"
TABLESPACE2_DIR="hmd60"
TABLESPACE3_DIR="iqp71"

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

pg_ctl stop -D "$PGPATH"

if [ -d $PGPATH ]; then
    rm -rf $PGPATH
fi
if [ -d $TABLESPACE1_DIR ]; then
    rm -rf $TABLESPACE1_DIR
fi
if [ -d $TABLESPACE2_DIR ]; then
    rm -rf $TABLESPACE2_DIR
fi
if [ -d $TABLESPACE3_DIR ]; then
    rm -rf $TABLESPACE3_DIR
fi
if [ -d $WAL_DIR ]; then
    rm -rf $WAL_DIR
fi

cp -r $BACKUPS_DIR/"$BACKUP_NAME"/* ~

ln -sF "$HOME"/"$TABLESPACE1_DIR" $PGPATH/pg_tblspc/16385
ln -sF "$HOME"/"$TABLESPACE2_DIR" $PGPATH/pg_tblspc/16386
ln -sF "$HOME"/"$TABLESPACE3_DIR" $PGPATH/pg_tblspc/16387
ln -sF "$HOME"/"$WAL_DIR" $PGPATH/pg_wal

chmod 777 $TABLESPACE1_DIR $TABLESPACE2_DIR $TABLESPACE3_DIR $WAL_DIR

pg_ctl start -l /dev/null -D "$PGPATH"

