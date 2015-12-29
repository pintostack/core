#!/bin/bash
#Print environment
env
#Register
IP=`getent hosts $HOST | awk '{print $1}'`
reg_var='{'"\
		\"ID\": \"kibana\",\
		\"Name\": \"kibana\",\
		\"Tags\": [\"http-$PORT0\"],\
		\"Address\": \"$IP\",\
		\"Check\": "'{'"\
    		\"Script\": \"nc -w 5 -z $IP $PORT0 >/dev/null\",\
    		\"Interval\": \"10s\"\
  		"'}}'

curl -s http://$HOST:8500/v1/agent/service/deregister/kibana
echo $reg_var | curl -H 'Content-Type: application/json' -X PUT -d @- http://$HOST:8500/v1/agent/service/register

#Run kibana whit elasticsearch
ELASTIC_HTTP_PORT=`curl -s http://$HOST:8500/v1/catalog/service/elasticsearch | jq .[0].ServiceTags | grep http | sed s/[^0-9]//g`

beats_template="\
{
  \"mappings\": {
    \"_default_\": {
      \"_all\": {
        \"enabled\": true,
        \"norms\": {
          \"enabled\": false
        }
      },
      \"dynamic_templates\": [
        {
          \"template1\": {
            \"mapping\": {
              \"doc_values\": true,
              \"ignore_above\": 1024,
              \"index\": \"not_analyzed\",
              \"type\": \"{dynamic_type}\"
            },
            \"match\": \"*\"
          }
        }
      ],
      \"properties\": {
        \"@timestamp\": {
          \"type\": \"date\"
        },
        \"message\": {
          \"type\": \"string\",
          \"index\": \"analyzed\"
        },
        \"offset\": {
          \"type\": \"long\",
          \"doc_values\": \"true\"
        }
      }
    }
  },
  \"settings\": {
    \"index.refresh_interval\": \"5s\"
  },
  \"template\": \"filebeat-*\"
}
"

echo $beats_template > /tmp/beats.template

curl -XPUT "http://elasticsearch.service.consul:$ELASTIC_HTTP_PORT/_template/filebeat?pretty" -d@/tmp/beats.template

/kibana/bin/kibana --host 0.0.0.0 --port $PORT0 --elasticsearch "http://elasticsearch.service.consul:$ELASTIC_HTTP_PORT"
