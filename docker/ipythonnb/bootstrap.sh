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
export MESOS_MASTER="consul.service.consul"
export MESOS_NATIVE_LIBRARY=/usr/local/lib/libmesos.so
export MESOS_NATIVE_JAVA_LIBRARY=/usr/local/lib/libmesos.so
export SPARK_HOME=/usr/lib/spark/
echo "${CONTAINER_IP} ${HOST}" >> /etc/hosts

ipython profile create pyspark

echo "c = get_config()

# Simply find this line and change the port value
c.NotebookApp.port = $NB_PORT
c.NotebookApp.open_browser = False
c.NotebookApp.ip = '*'
c.InteractiveShellApp.exec_lines = [
    'import os',
    'import sys',
    'spark_home = os.environ.get(\"SPARK_HOME\")',
    'pyspark_submit_args = os.environ.get(\"PYSPARK_SUBMIT_ARGS\", \"\")',
    'pyspark_submit_args += \" pyspark-shell\"',
    'os.environ[\"PYSPARK_SUBMIT_ARGS\"] = pyspark_submit_args',
    'sys.path.insert(0, spark_home + \"/python\")',
    'sys.path.insert(0, os.path.join(spark_home, \"python/lib/py4j-0.8.2.1-src.zip\"))',
    'execfile(os.path.join(spark_home, \"python/pyspark/shell.py\"))'
]
"\
> /root/.ipython/profile_pyspark/ipython_notebook_config.py


export PYSPARK_SUBMIT_ARGS=" --master mesos://${MESOS_MASTER}:5050
--executor-memory 1024m
--executor-cores 1
--driver-memory 1024m
--driver-cores 1
--conf spark.python.worker.memory=1024m
--conf spark.task.cpus=1
--conf spark.cores.max=8
--conf spark.mesos.executor.home=/usr/lib/spark
--conf spark.driver.port=${PORT2}
--conf spark.fileserver.port=${PORT3}
--conf spark.broadcast.port=${PORT4}
--conf spark.blockManager.port=${PORT5}
--conf spark.ui.port=${PORT6}
--conf spark.replClassServer.port=${PORT7}
--conf spark.mesos.executor.docker.image=pintostack/pintostack-mesos-slave
--conf spark.mesos.coarse=true
"

#--conf spark.executor.uri=http://${MESOS_MASTER}/spark-1.5.2-bin-hadoop2.6.tgz
#--conf spark.mesos.coarse=false
#--conf spark.broadcast.factory=org.apache.spark.broadcast.HttpBroadcastFactor

#/root/spark/bin/pyspark $PYSPARK_SUBMIT_ARGS
ipython notebook --profile=pyspark

