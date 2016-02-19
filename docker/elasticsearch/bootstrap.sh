#!/bin/bash
env

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

bash -c "sleep 4; curl -XPUT 'http://localhost:$PORT0/_template/filebeat?pretty' -d@/tmp/beats.template" &

/elasticsearch/bin/elasticsearch --network.host 0.0.0.0 --transport.host 0.0.0.0 --http.port $PORT0 --transport.tcp.port $PORT1