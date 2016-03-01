#!/bin/bash

HOST_JSON=$(curl -s http://$HOST:8500/v1/agent/self) 
export HOST_IP=$(echo $HOST_JSON | jq .Config.AdvertiseAddr | sed -n 's/.*"\(.*\)".*/\1/p')
export CONTAINER_IP=$(ip -o -4 addr list eth0 | perl -n -e 'if (m{inet\s([\d\.]+)\/\d+\s}xms) { print $1 }')

export LIBPROCESS_ADVERTISE_IP=$HOST_IP
export LIBPROCESS_ADVERTISE_PORT=$PORT1
export LIBPROCESS_IP="0.0.0.0"
export LIBPROCESS_PORT=$PORT1
export MESOS_MASTER="consul.service.consul"
echo "${CONTAINER_IP} ${HOST}" >> /etc/hosts
env

/usr/bin/chronos run_jar --hostname $LIBPROCESS_ADVERTISE_IP --master zk://master-1.node.consul:2181/mesos --zk_hosts master-1.node.consul:2181