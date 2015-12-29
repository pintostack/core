#!/bin/bash -e

set -x

#find postgres

env

curl -s http://$HOST.node.consul:8500/v1/catalog/service/postgres
echo $HOST

curl -s http://$HOST:8500/v1/catalog/service/postgres

PG_HOST_JSON=$(curl -s http://$HOST.node.consul:8500/v1/catalog/service/postgres)
echo $PG_HOST_JSON

PG_PORT=$(echo "$PG_HOST_JSON" | jq .[0].ServiceTags | sed -n 's/.*"rpc-\([0-9]*\)".*/\1/p')
echo $PG_PORT

PG_IP=$(echo "$PG_HOST_JSON" | jq .[0].Address | sed 's/"//g')
echo $PG_IP

echo "Postgres configuration $PG_IP : $PG_PORT"

KF_HOST_JSON=$(curl -s http://$HOST.node.consul:8500/v1/catalog/service/kafka)
KF_PORT=$(echo "$KF_HOST_JSON" | jq .[0].ServiceTags | sed -n 's/.*"queue-\([0-9]*\)".*/\1/p')
KF_IP=$(echo "$KF_HOST_JSON" | jq .[0].Address | sed 's/"//g')

echo "Kafka configuration $KF_IP : $KF_PORT"

# If a ZooKeeper container is linked with the alias `zookeeper`, use it.
# You MUST set DH_ZK_ADDRESS and DH_ZK_PORT in env otherwise.
#[ -n "$ZOOKEEPER_PORT_2181_TCP_ADDR" ] && DH_ZK_ADDRESS=$ZOOKEEPER_PORT_2181_TCP_ADDR
#[ -n "$ZOOKEEPER_PORT_2181_TCP_PORT" ] && DH_ZK_PORT=$ZOOKEEPER_PORT_2181_TCP_PORT

# If a Kafka container is linked with the alias `kafka`, use it.
# You MUST set DH_KAFKA_ADDRESS and DH_KAFKA_PORT in env otherwise.
#[ -n "$KAFKA_PORT_9092_TCP_ADDR" ] && DH_KAFKA_ADDRESS=$KAFKA_PORT_9092_TCP_ADDR
#[ -n "$KAFKA_PORT_9092_TCP_PORT" ] && DH_KAFKA_PORT=$KAFKA_PORT_9092_TCP_PORT

# If a Postgres container is linked with the alias `postgres`, use it.
# You MUST set DH_POSTGRES_ADDRESS and DH_POSTGRES_PORT in env otherwise.
#[ -n "$POSTGRES_PORT_5432_TCP_ADDR" ] && DH_POSTGRES_ADDRESS=$POSTGRES_PORT_5432_TCP_ADDR
#[ -n "$POSTGRES_PORT_5432_TCP_PORT" ] && DH_POSTGRES_PORT=$POSTGRES_PORT_5432_TCP_PORT

#[ -n "$POSTGRES_ENV_POSTGRES_DB" ] && DH_POSTGRES_DB=$POSTGRES_ENV_POSTGRES_DB
#[ -n "$POSTGRES_ENV_POSTGRES_USERNAME" ] && DH_POSTGRES_USERNAME=$POSTGRES_ENV_POSTGRES_USERNAME
#[ -n "$POSTGRES_ENV_POSTGRES_PASSWORD" ] && DH_POSTGRES_PASSWORD=$POSTGRES_ENV_POSTGRES_PASSWORD

echo "Starting DeviceHive"
java -server -Xmx512m -XX:MaxRAMFraction=1 -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70 -XX:+ScavengeBeforeFullGC -XX:+CMSScavengeBeforeRemark -jar \
-Dspring.datasource.url=jdbc:postgresql://$PG_IP:$PG_PORT/postgres \
-Dspring.datasource.username="postgres" \
-Dspring.datasource.password="12345" \
-Dmetadata.broker.list=$KF_IP:$KF_PORT \
-Dzookeeper.connect=zookeeper.service.consul:2181 \
-Dthreads.count=${DH_KAFKA_THREADS_COUNT:-3} \
-Dhazelcast.port=${DH_HAZELCAST_PORT:-5701} \
-Dserver.context-path=/api \
-Dserver.port=$PORT0 \
./devicehive-${DH_VERSION}-boot.jar

set +x
