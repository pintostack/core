#!/bin/bash -x

function register_service () {
	insert_command='{'"\
		\"ID\": \"kafka\",\
		\"Name\": \"kafka\",\
		\"Tags\": [\"queue-$PORT0\"],\
		\"Address\": \"$HOST\",\
		\"Check\": "'{'"\
    		\"Script\": \"nc -w 5 -z $HOST $PORT0 >/dev/null\",\
    		\"Interval\": \"10s\"\
  		"'}}'

        echo $HOST
	curl -s http://$HOST.node.consul:8500/v1/agent/service/deregister/kafka
	echo
        echo $insert_command | curl -H 'Content-Type: application/json' -X PUT -d @- http://$HOST.node.consul:8500/v1/agent/service/register
        echo
}

register_service

export ZOOKEEPER_CONNECTION_STRING=zookeeper.service.consul:2181
export KAFKA_ADVERTISED_HOST_NAME=$HOST.node.consul
export KAFKA_PORT=$PORT0
export KAFKA_ADVERTISED_PORT=$PORT0

env
