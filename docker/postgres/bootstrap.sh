#!/bin/bash


env

echo $HOST

function register_service () {
  DNS=$(getent hosts $HOST)
  IP=(${DNS// / })

	insert_command='{'"\
		\"ID\": \"postgres\",\
		\"Name\": \"postgres\",\
		\"Tags\": [\"rpc-$PORT0\"],\
		\"Address\": \"$IP\",\
		\"Check\": "'{'"\
    		\"Script\": \"nc -w 5 -z $HOST $PORT0 >/dev/null\",\
    		\"Interval\": \"10s\"\
  		"'}}'

        echo $HOST
	curl -s http://$HOST.node.consul:8500/v1/agent/service/deregister/postgres
	echo
        echo $insert_command | curl -H 'Content-Type: application/json' -X PUT -d @- http://$HOST.node.consul:8500/v1/agent/service/register
        echo
}

if [ "$1" = 'postgres' ]; then
	# SET DEFAULT VALUES IF NOT SET
	export PGDATA=${PGDATA:-/var/services/data/postgres}
	export PGLOG=${PGLOG:-/var/services/log/postgres}
	export PGDB=${PGDB:-devicehive}
	export PGSUPERPASSWORD=${PGSUPERPASSWORD:-12345}
	mkdir -p "$PGDATA" "$PGLOG"
	chown -R postgres "$PGDATA" "$PGLOG"

	# INITIAL SETUP IF NO PGDATA FOLDER
	if [ -z "$(ls -A "$PGDATA")" ]; then
		# EDIT postgresql.conf
		gosu postgres initdb
		sed -ri "s/^#(listen_addresses\s*=\s*)\S+/\1'*'/" "$PGDATA"/postgresql.conf

		# CREATE PGDB DATABASE
		gosu postgres postgres --single -jE <<-EOSQL
			CREATE DATABASE "$PGDB" OWNER "postgres";
		EOSQL
		echo

		# SET SUPER USER PASSWORD postgres
		if [ "$PGSUPERPASSWORD" != 'none' ]; then
			gosu postgres postgres --single -jE <<-EOSQL
				ALTER USER postgres WITH SUPERUSER PASSWORD '$PGSUPERPASSWORD';
			EOSQL
			echo
		fi

		# ALLOW ALL HOST
		{ echo; echo "host all all 0.0.0.0/0 md5"; } >> "$PGDATA"/pg_hba.conf
	fi

        # REGISTER POSTGRES in CONSUL
        register_service

	# RUN POSTGRES
	exec gosu postgres "$@" -p $PORT0
fi

# RUN OTHER COMMAND
exec "$@"
