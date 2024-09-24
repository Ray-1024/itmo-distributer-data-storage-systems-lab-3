#!/usr/bin/bash

# define lab env vars

export LAB_BASE_PATH=$HOME

export LAB_CLUSTER_PATH=$LAB_BASE_PATH/dpf79
export LAB_WALDIR_PATH=$LAB_BASE_PATH/gvg44

export LAB_TABLESPACE1_PATH=$LAB_BASE_PATH/dvm64
export LAB_TABLESPACE2_PATH=$LAB_BASE_PATH/hmd60
export LAB_TABLESPACE3_PATH=$LAB_BASE_PATH/iqp71

export LAB_POSTGRESQL_CONF=$LAB_CLUSTER_PATH/postgresql.conf
export LAB_PG_HBA=$LAB_CLUSTER_PATH/pg_hba.conf
export LAB_CREATE_SQL_PATH=$LAB_BASE_PATH/create.sql
export LAB_PROCESS_SQL_PATH=$LAB_BASE_PATH/process.sql


# stop old cluster
pg_ctl -D "$LAB_CLUSTER_PATH" stop

rm -rf "$LAB_CLUSTER_PATH"
rm -rf "$LAB_WALDIR_PATH"
rm -rf "$LAB_TABLESPACE1_PATH"
rm -rf "$LAB_TABLESPACE2_PATH"
rm -rf "$LAB_TABLESPACE3_PATH"

# make new postgresql cluster
initdb -D "$LAB_CLUSTER_PATH" --encoding=KOI8-R --locale=ru_RU.KOI8-R --waldir="$LAB_WALDIR_PATH"
mkdir "$LAB_TABLESPACE1_PATH"
mkdir "$LAB_TABLESPACE2_PATH"
mkdir "$LAB_TABLESPACE3_PATH"


# configure cluster


## postgresql.conf

#port = 9905
sed -i -e 's/#port = 5432/port = 9905/g' "$LAB_POSTGRESQL_CONF"

#max_connections = 20
sed -i -e 's/max_connections = 100/max_connections = 20/g' "$LAB_POSTGRESQL_CONF"

#shared_buffers = 512MB
sed -i -e 's/shared_buffers = 128MB/shared_buffers = 512MB/g' "$LAB_POSTGRESQL_CONF"

#temp_buffers = 32MB
sed -i -e 's/#temp_buffers = 8MB/temp_buffers = 32MB/g' "$LAB_POSTGRESQL_CONF"

#work_mem = 64MB
sed -i -e 's/#work_mem = 4MB/work_mem = 64MB/g' "$LAB_POSTGRESQL_CONF"

#checkpoint_timeout = 30min
sed -i -e 's/#checkpoint_timeout = 5min/checkpoint_timeout = 30min/g' "$LAB_POSTGRESQL_CONF"

#effective_cache_size = 2GB
sed -i -e 's/#effective_cache_size = 4GB/effective_cache_size = 2GB/g' "$LAB_POSTGRESQL_CONF"

#fsync = on
sed -i -e 's/#fsync = on/fsync = on/g' "$LAB_POSTGRESQL_CONF"

#commit_delay = 10
sed -i -e 's/#commit_delay = 0/commit_delay = 10/g' "$LAB_POSTGRESQL_CONF"

#log_destination = 'csvlog'
sed -i -e "s/#log_destination = 'stderr'/log_destination = 'csvlog'/g" "$LAB_POSTGRESQL_CONF"

#logging_collector = on
sed -i -e 's/#logging_collector = off/logging_collector = on/g' "$LAB_POSTGRESQL_CONF"

#log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'
sed -i -e "s/#log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'/log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'/g" "$LAB_POSTGRESQL_CONF"

#log_statement = 'none'
sed -i -e "s/#log_statement = 'none'/log_statement = 'none'/g" "$LAB_POSTGRESQL_CONF"

#log_duration = on
sed -i -e 's/#log_duration = off/log_duration = on/g' "$LAB_POSTGRESQL_CONF"

#log_connections = on
sed -i -e 's/#log_connections = off/log_connections = on/g' "$LAB_POSTGRESQL_CONF"

#log_disconnections = on
sed -i -e 's/#log_disconnections = off/log_disconnections = on/g' "$LAB_POSTGRESQL_CONF"

#log_min_messages = error
sed -i -e 's/#log_min_messages = warning/log_min_messages = error/g' "$LAB_POSTGRESQL_CONF"



#wal_level = replica
sed -i -e 's/#wal_level = replica/wal_level = replica/g' "$LAB_POSTGRESQL_CONF"

#archive_mode = off
sed -i -e 's/#archive_mode = off/archive_mode = on/g' "$LAB_POSTGRESQL_CONF"

#archive_command = ''
sed -i -e "s/#archive_command = ''/archive_command = 'cp %p \/var\/db\/postgres1\/%f'/g" "$LAB_POSTGRESQL_CONF"

#restore_command = ''
sed -i -e "s/#restore_command = ''/restore_command = 'cp \/var\/db\/postgres1\/%f %p'/g" "$LAB_POSTGRESQL_CONF"

#archive_timeout = 0
sed -i -e "s/#archive_timeout = 0/archive_timeout = 10/g" "$LAB_POSTGRESQL_CONF"



#pg_hba.conf

pg_ctl start -D "$LAB_CLUSTER_PATH"
psql -d template1 -p 9905 -f "$LAB_CREATE_SQL_PATH"
pg_ctl stop -D "$LAB_CLUSTER_PATH"

echo 'local all all peer' > "$LAB_PG_HBA"
echo 'host  all all 127.0.0.1/32  password' >> "$LAB_PG_HBA"
echo 'host  all all ::1/128 password' >> "$LAB_PG_HBA"
echo 'host  all all 0.0.0.0/0  reject' >> "$LAB_PG_HBA"
echo 'host  all all ::0/0 reject' >> "$LAB_PG_HBA"


# start cluster
pg_ctl start -D "$LAB_CLUSTER_PATH"

### FILL DATA

psql -d uglygoldwood -p 9905 -f "$LAB_PROCESS_SQL_PATH"