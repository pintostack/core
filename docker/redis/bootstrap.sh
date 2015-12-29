#!/bin/bash

env

echo $HOST

function register_service () {
  DNS=$(getent hosts $HOST)
  IP=(${DNS// / })

	insert_command='{'"\
		\"ID\": \"redis\",\
		\"Name\": \"redis\",\
		\"Address\": \"$IP\",\
		\"Tags\": [\"$PORT0\"],\
		\"Port\": $PORT0,\
		\"Check\": "'{'"\
    		\"Script\": \"nc -w 5 -z $HOST $PORT0 >/dev/null\",\
    		\"Interval\": \"10s\"\
  		"'}}'

  echo $HOST
	curl -s http://$HOST.node.consul:8500/v1/agent/service/deregister/redis
	echo
  echo $insert_command | curl -H 'Content-Type: application/json' -X PUT -d @- http://$HOST.node.consul:8500/v1/agent/service/register
  echo
  echo "service-registered" >> /tmp/logfile
}

echo "function-ok" > /tmp/logfile
register_service

# RUN OTHER COMMAND
exec "$@"
