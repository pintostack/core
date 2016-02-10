#!/usr/bin/env bash

if [ -z $MASTER_IP ]; then
  echo "$MASTER_IP is not set"
  exit 1
fi

if [ -z $SLAVE_IP ]; then
  echo "$SLAVE_IP is not set"
  exit 1
fi

#Run ZK
docker run --net="host" -d \
 pintostack-zk

#Run Mesos Master
docker run --net="host" \
-e "MESOS_HOSTNAME=${MASTER_IP}" \
-e "MESOS_IP=${MASTER_IP}" \
-e "MESOS_ZK=zk://${MASTER_IP}:2181/mesos" \
-e "MESOS_PORT=5050" \
-e "MESOS_LOG_DIR=/var/log/mesos" \
-e "MESOS_QUORUM=1" \
-e "MESOS_REGISTRY=in_memory" \
-e "MESOS_WORK_DIR=/var/lib/mesos" \
-d \
 pintostack-mesos


#Run marathon

docker run --net="host" \
-d \
-p 8080:8080 \
pintostack-marathon --master zk://${MASTER_IP}:2181/mesos --zk zk://${MASTER_IP}:2181/marathon

#Run Mesos Slave

docker run  \
--entrypoint="mesos-slave" \
--net="host" \
--pid=host \
-e "MESOS_MASTER=zk://${MASTER_IP}:2181/mesos" \
-e "MESOS_PORT=5051" \
-e "MESOS_IP=${SLAVE_IP}" \
-e "MESOS_LOG_DIR=/var/log/mesos" \
-e "MESOS_LOGGING_LEVEL=INFO" \
-v /var/run/docker.sock:/var/run/docker.sock   \
-v $(which docker):/bin/docker   \
-v /usr/lib/x86_64-linux-gnu/libapparmor.so.1:/usr/lib/x86_64-linux-gnu/libapparmor.so.1 \
-e "MESOS_WORK_DIR=/var/lib/mesos" \
-d pintostack-mesos --containerizers=docker

