# Quick start guide

## Make my http container balanced

1. Open Consul UI usualy master-1:8500
2. Find a servise name for service you want to balance for hdfs it is hdfs-http
3. Copy marathon/hdfs-nn-lb-http.json to [whatever you need].json
4. Change "id": "/hdfs/http-lb" and "BACKEND_SERVICE_NAME": "hdfs-http"
5. And run ./marathon-push.sh [whatever you need].json
6. Find a load balancer service in consul UI
7. Greate...
