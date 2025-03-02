#!/usr/bin/env bash

CLUSTER_HOST="postgres1@pg188"
CLUSTER_PATH="~/dpf79"
WAL_PATH="~/gvg44"
TABLESPACE1_PATH="~/dvm64"
TABLESPACE2_PATH="~/hmd60"
TABLESPACE3_PATH="~/iqp71"

BACKUP_NAME=$(date "+%Y%m%d_%H%M%S")
BACKUPS_DIR="backups"
mkdir "$BACKUPS_DIR"

MAX_BACKUPS_COUNT=14

ssh $CLUSTER_HOST "pg_ctl stop -D $CLUSTER_PATH"

rsync -avz $CLUSTER_HOST:$CLUSTER_PATH :$WAL_PATH :$TABLESPACE1_PATH :$TABLESPACE2_PATH :$TABLESPACE3_PATH $BACKUPS_DIR/"$BACKUP_NAME"

ssh $CLUSTER_HOST "pg_ctl start -l /dev/null -D $CLUSTER_PATH"


BACKUPS_COUNT=$(ls $BACKUPS_DIR | wc -l)

if (( $BACKUPS_COUNT > $MAX_BACKUPS_COUNT ));
then
  OLDEST_BACKUP=$(ls $BACKUPS_DIR | head -1)
  rm -rf $BACKUPS_DIR/"$OLDEST_BACKUP"
fi

