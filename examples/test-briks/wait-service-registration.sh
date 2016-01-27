#!/usr/bin/env bash
RETRY=20
INTERVAL=5
DEFAULT_HOST="master-1"
SERVICE=$1
if [ -z $SERVICE ]; then
    echo "
This script will lookup for default port for SERVICE 
and try to connect it from $DEFAULT_HOST
Usage:
    $0 [SERVICE_NAME]	#Put here same name you are using in consul"
    exit 1
fi

SERVICE_IS_OK=false
while [ "x$SERVICE_IS_OK" != "xtrue"  -a  ${RETRY} -gt 0 ]; do
 SERVICE_IS_OK=`vagrant ssh ${DEFAULT_HOST} -c "curl -s http://localhost:8080/v2/apps/$SERVICE |jq -r .app.tasks[0].healthCheckResults[0].alive" | tail -n 1`
 RETRY=$[ $RETRY - 1 ]
 sleep $INTERVAL
done

vagrant ssh ${DEFAULT_HOST} -c "curl -s http://localhost:8080/v2/apps/SERVICE/namenode |jq -r .app.tasks[0].healthCheckResults[0].alive" | tail -n 1

if [ "x${SERVICE_IS_OK}" != "xtrue" ]; then
 echo "ERROR: Mesos do not see $SERVICE"
 exit 1
else
 echo "INFO: Mesos started $SERVICE"
fi

if [ $SERVICE == "hdfs/namenode" ]; then
# HOTFIX: Now it works only with SERVICE needs to be fixed  jq -r .[0].ServiceTags 
	SERVICE_IP=`vagrant ssh ${DEFAULT_HOST} -c "curl -s localhost:8500/v1/catalog/service/hdfs | jq -r .[0].Address" | tail -n 1`
	SERVICE_PORT=`vagrant ssh ${DEFAULT_HOST} -c "curl -s localhost:8500/v1/catalog/service/hdfs |  jq -r .[0].ServiceTags | sed -n 's/.*\"http-\([0-9]*\)\".*/\1/p'" | tail -n 1`
	echo "
INFO: Found $SERVICE on ${SERVICE_IP} : ${SERVICE_PORT}
Executing curl from ${DEFAULT_HOST}...
"
	vagrant ssh ${DEFAULT_HOST} -c "curl -s  $SERVICE_IP\:$SERVICE_PORT " | grep "Licensed to the Apache Software Foundation (ASF)"
else
	SERVICE_IP=`vagrant ssh ${DEFAULT_HOST} -c "curl -s localhost:8500/v1/catalog/service/$SERVICE | jq -r .[0].Address" | tail -n 1`
	SERVICE_PORT=`vagrant ssh ${DEFAULT_HOST} -c "curl -s localhost:8500/v1/catalog/service/$SERVICE |  jq -r .[0].ServicePort" | tail -n 1`
	echo "
INFO: Found $SERVICE on ${SERVICE_IP}:${SERVICE_PORT}
Executing nc -z -v -w5 $SERVICE_IP $SERVICE_PORT from ${DEFAULT_HOST}...
"
	vagrant ssh ${DEFAULT_HOST} -c "nc -z -v -w5 $SERVICE_IP $SERVICE_PORT"
fi
