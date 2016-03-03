#!/bin/bash

HOST_JSON=$(curl -s http://$HOST:8500/v1/agent/self)
export HOST_IP=$(echo $HOST_JSON | jq .Config.AdvertiseAddr | sed -n 's/.*"\(.*\)".*/\1/p')
export CONTAINER_IP=$(ip -o -4 addr list eth0 | perl -n -e 'if (m{inet\s([\d\.]+)\/\d+\s}xms) { print $1 }')
export NB_PORT=$PORT0
export LIBPROCESS_ADVERTISE_IP=$HOST_IP
export LIBPROCESS_ADVERTISE_PORT=$PORT1
export LIBPROCESS_IP="0.0.0.0"
export LIBPROCESS_PORT=$PORT1
export SPARK_LOCAL_IP=$CONTAINER_IP
export SPARK_LOCAL_HOSTNAME=$HOST
export MESOS_MASTER="master-1.node.consul"
export MESOS_NATIVE_LIBRARY=/usr/local/lib/libmesos.so
export MESOS_NATIVE_JAVA_LIBRARY=/usr/local/lib/libmesos.so
export SPARK_HOME=/usr/lib/spark/
echo "${CONTAINER_IP} ${HOST}" >> /etc/hosts

./sbin/start-mesos-dispatcher.sh --host $HOST --master mesos://master-1.node.consul:5050;

while true; do echo 'running..'; sleep 60; done