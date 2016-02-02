#!/bin/bash

function print_usage (){
  echo "Usage: bootstrap.sh COMMAND"
  echo "       where COMMAND is one of:"
  echo "  namenode             run DFS namenode"
  echo "  datanode             run DFS datanode"
  echo "  client			   test only, setup client environment vaiables"
}

function register_nn_service (){
	insert_command='{'"\
		\"ID\": \"hdfs\",\
		\"Name\": \"hdfs\",\
		\"Tags\": [\"rpc-$PORT0\", \"ipc-$PORT1\", \"http-$PORT2\"],\
		\"Address\": \"$HOST\",\
		\"Check\": "'{'"\
    		\"Script\": \"nc -w 5 -z $HOST $PORT0 >/dev/null\",\
    		\"Interval\": \"10s\"\
  		"'}}'

	curl -s http://$HOST:8500/v1/agent/service/deregister/hdfs
	echo $insert_command | curl -H 'Content-Type: application/json' -X PUT -d @- http://$HOST:8500/v1/agent/service/register
}

if [ $# = 0 ]; then
  print_usage
  exit
fi

COMMAND=$1
NN_HOSTNAME='hdfs.service.dc1.consul'

env

HOST_JSON=$(curl -s http://$HOST:8500/v1/agent/self) \
HOSTNAME=$(echo $HOST_JSON | jq .Config.NodeName | sed -n 's/.*"\(.*\)".*/\1/p')
HOST=$(echo $HOST_JSON | jq .Config.AdvertiseAddr | sed -n 's/.*"\(.*\)".*/\1/p')

case $COMMAND in
	namenode)
		NN_IP=$HOST
		declare -A parameters=(["NN_IP"]=$NN_IP \
		["NN_HOSTNAME"]=$NN_HOSTNAME \
		["NN_RPC_PORT"]=$PORT0 \
		["NN_SERVICE_RPC_PORT"]=$PORT1 \
		["NN_HTTP_PORT"]=$PORT2)
 		;;
	datanode)
		HDFS_NN_JSON=$(curl -s http://$HOST:8500/v1/catalog/service/hdfs)
		NN_RPC_PORT=$(echo "$HDFS_NN_JSON" | jq .[0].ServiceTags | sed -n 's/.*"rpc-\([0-9]*\)".*/\1/p')
		NN_SERVICE_RPC_PORT=$(echo "$HDFS_NN_JSON" | jq .[0].ServiceTags | sed -n 's/.*"ipc-\([0-9]*\)".*/\1/p')
		NN_IP=$(echo "$HDFS_NN_JSON" | jq .[0].Address)
		DN_HOSTNAME=$HOSTNAME

		declare -A parameters=(["NN_IP"]=$NN_IP \
		["NN_HOSTNAME"]=$NN_HOSTNAME \
		["NN_RPC_PORT"]=$NN_RPC_PORT \
		["NN_SERVICE_RPC_PORT"]=$NN_SERVICE_RPC_PORT \
		["DN_HOSTNAME"]=$DN_HOSTNAME \
		["DN_RPC_PORT"]=$PORT0 \
		["DN_IPC_PORT"]=$PORT1 \
		["DN_HTTP_PORT"]=$PORT2)
 		;;
 	client)
		HDFS_NN_JSON=$(curl -s http://$HOST:8500/v1/catalog/service/hdfs)
		NN_RPC_PORT=$(echo "$HDFS_NN_JSON" | jq .[0].ServiceTags | sed -n 's/.*"rpc-\([0-9]*\)".*/\1/p')

		declare -A parameters=(["NN_HOSTNAME"]=$NN_HOSTNAME \
		["NN_RPC_PORT"]=$NN_RPC_PORT)
		;;
 	default)
		echo 'Invalid parameter $COMMAND'
		exit
		;;
esac

function replace {
	for name in "${!parameters[@]}"; do sed -i -e $'s/${'$name'}/'"${parameters["$name"]}"'/g' $1; done
}

export CONF_PATH="/conf"
cp ${CONF_PATH}/core-site.xml.template ${CONF_PATH}/core-site.xml

case $COMMAND in
	namenode)
		cp ${CONF_PATH}/hdfs-site-nn.xml.template ${CONF_PATH}/hdfs-site.xml
		;;
	datanode)
		cp ${CONF_PATH}/hdfs-site-dn.xml.template ${CONF_PATH}/hdfs-site.xml
		;;

esac

replace ${CONF_PATH}/core-site.xml
replace ${CONF_PATH}/hdfs-site.xml

case $COMMAND in
	namenode)
		#register_nn_service
		if [ ! -d /hadoop/name ]; then 
			echo "NameNode dir is unformatted, formatting."
			bin/hdfs namenode -format
		fi
		# Register namenode in Consul
		# curl
		bin/hdfs namenode
		;;
	datanode)
		bin/hdfs datanode
		# Register datanode in Consul
		# curl
		;;
esac
