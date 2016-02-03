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

# HOST_JSON=$(curl -s http://$HOST:8500/v1/agent/self) \
# HOSTNAME=$(echo $HOST_JSON | jq .Config.NodeName | sed -n 's/.*"\(.*\)".*/\1/p')
# HOST=$(echo $HOST_JSON | jq .Config.AdvertiseAddr | sed -n 's/.*"\(.*\)".*/\1/p')

case $COMMAND in
	namenode)
		declare -A parameters=( \
		["NN_HOSTNAME"]=$HOST \
		["NN_RPC_ADDR"]=$HOST:$PORT0 \
		["NN_IPC_ADDR"]=$HOST:$PORT1 \
		["NN_HTTP_ADDR"]=$HOST:$PORT2)
 		;;
	datanode)
		NN_RPC_JSON=$(curl -s http://$HOST:8500/v1/catalog/service/hdfs-rpc)
		NN_IPC_JSON=$(curl -s http://$HOST:8500/v1/catalog/service/hdfs-ipc)
		NN_RPC_NODE=$(echo "$NN_RPC_JSON" | jq .[0].Node | sed -n 's/.*"\(.*\)".*/\1/p')
		NN_RPC_PORT=$(echo "$NN_RPC_JSON" | jq .[0].ServicePort)
		NN_IPC_NODE=$(echo "$NN_IPC_JSON" | jq .[0].Node | sed -n 's/.*"\(.*\)".*/\1/p')
		NN_IPC_PORT=$(echo "$NN_IPC_JSON" | jq .[0].ServicePort)
		NN_HOSTNAME=$NN_RPC_NODE

		declare -A parameters=( \
		["NN_HOSTNAME"]=$NN_HOSTNAME \
		["NN_RPC_ADDR"]=$NN_RPC_NODE:$NN_RPC_PORT \
		["NN_IPC_ADDR"]=$NN_IPC_NODE:$NN_IPC_PORT \
		["DN_HOSTNAME"]=$HOST \
		["DN_RPC_ADDR"]=0.0.0.0:$PORT0 \
		["DN_IPC_ADDR"]=0.0.0.0:$PORT1 \
		["DN_HTTP_ADDR"]=0.0.0.0:$PORT2)
 		;;
 	client)
		NN_RPC_JSON=$(curl -s http://$HOST:8500/v1/catalog/service/hdfs-rpc)
		NN_RPC_NODE=$(echo "$NN_RPC_JSON" | jq .[0].Node | sed -n 's/.*"\(.*\)".*/\1/p')
		NN_RPC_PORT=$(echo "$NN_RPC_JSON" | jq .[0].ServicePort)

		declare -A parameters=( \
		["NN_HOSTNAME"]=$NN_RPC_NODE \
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
