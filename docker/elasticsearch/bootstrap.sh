#!/bin/bash
env
IP=`getent hosts $HOST | awk '{print $1}'`
reg_var='{'"\
		\"ID\": \"elasticsearch\",\
		\"Name\": \"elasticsearch\",\
		\"Tags\": [\"http-$PORT0\", \"tcp-$PORT1\"],\
		\"Address\": \"$IP\",\
		\"ServicePort\": $PORT0,\
		\"Check\": "'{'"\
    		\"Script\": \"nc -w 5 -z $IP $PORT0 >/dev/null\",\
    		\"Interval\": \"10s\"\
  		"'}}'

curl -s http://$HOST:8500/v1/agent/service/deregister/elasticsearch

echo $reg_var | curl -H 'Content-Type: application/json' -X PUT -d @- http://$HOST:8500/v1/agent/service/register

# Submit filebeats template into the ES after start up
bash -c "sleep 3; curl -XPUT 'http://localhost:$PORT0/_template/filebeat?pretty' -d@/etc/filebeat/filebeat.template.json" &

/elasticsearch/bin/elasticsearch --network.host 0.0.0.0 --transport.host 0.0.0.0 --http.port $PORT0 --transport.tcp.port $PORT1