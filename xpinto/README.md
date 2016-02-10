Step 1
Docker in Docker
docker run \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(which docker):/bin/docker \
  -v /usr/lib/x86_64-linux-gnu/libapparmor.so.1:/usr/lib/x86_64-linux-gnu/libapparmor.so.1 \
  -it ubuntu
  
  
Step 2
HOST_IP=172.31.10.179

Run ZK
docker run -d -p 2181:2181 -p 2888:2888 -p 3888:3888 garland/zookeeper

Run MMaster
docker run --net="host" \
-p 5050:5050 \
-e "MESOS_HOSTNAME=${HOST_IP}" \
-e "MESOS_IP=${HOST_IP}" \
-e "MESOS_ZK=zk://${HOST_IP}:2181/mesos" \
-e "MESOS_PORT=5050" \
-e "MESOS_LOG_DIR=/var/log/mesos" \
-e "MESOS_QUORUM=1" \
-e "MESOS_REGISTRY=in_memory" \
-e "MESOS_WORK_DIR=/var/lib/mesos" \
-d \
garland/mesosphere-docker-mesos-master



docker run --net="host" \
-e "MESOS_HOSTNAME=${HOST_IP}" \
-e "MESOS_IP=${HOST_IP}" \
-e "MESOS_ZK=zk://${HOST_IP}:2181/mesos" \
-e "MESOS_PORT=5050" \
-e "MESOS_LOG_DIR=/var/log/mesos" \
-e "MESOS_QUORUM=1" \
-e "MESOS_REGISTRY=in_memory" \
-e "MESOS_WORK_DIR=/var/lib/mesos" \
-d mesos



Run Marathon

docker run \
--net="host" \
-d \
-p 8080:8080 \
marathon --master zk://${HOST_IP}:2181/mesos --zk zk://${HOST_IP}:2181/marathon

Run Mesos Slave
docker run -d \
--net="host" \
--name mesos_slave_1 \
--entrypoint="mesos-slave" \
-e "MESOS_MASTER=zk://${HOST_IP}:2181/mesos" \
-e "MESOS_IP=${HOST_IP}" \
-e "MESOS_LOG_DIR=/var/log/mesos" \
-e "MESOS_LOGGING_LEVEL=INFO" \
-v /var/run/docker.sock:/var/run/docker.sock   \
-v $(which docker):/bin/docker   \
-v /usr/lib/x86_64-linux-gnu/libapparmor.so.1:/usr/lib/x86_64-linux-gnu/libapparmor.so.1 \
garland/mesosphere-docker-mesos-master:latest

--entrypoint="mesos-slave --containerizers=docker,mesos" \

docker run -d \
--entrypoint="mesos-slave" \
--net="host" \
-e "MESOS_MASTER=zk://${HOST_IP}:2181/mesos" \
-e "MESOS_PORT=5051" \
-e "MESOS_IP=${HOST_IP}" \
-e "MESOS_LOG_DIR=/var/log/mesos" \
-e "MESOS_LOGGING_LEVEL=INFO" \
-v /etc/mesos-slave/containerizers:/etc/mesos-slave/containerizers \
-v /etc/mesos-slave/executor_registration_timeout:/etc/mesos-slave/executor_registration_timeout \
-v /var/run/docker.sock:/var/run/docker.sock   \
-v $(which docker):/bin/docker   \
-v /usr/lib/x86_64-linux-gnu/libapparmor.so.1:/usr/lib/x86_64-linux-gnu/libapparmor.so.1 \
mesos

docker run  \
--privileged \
--entrypoint="mesos-slave" \
--net="host" \
-e "MESOS_MASTER=zk://${HOST_IP}:2181/mesos" \
-e "MESOS_PORT=5051" \
-e "MESOS_IP=${HOST_IP}" \
-e "MESOS_LOG_DIR=/var/log/mesos" \
-e "MESOS_LOGGING_LEVEL=INFO" \
-v /etc/mesos-slave/containerizers:/etc/mesos-slave/containerizers \
-v /etc/mesos-slave/executor_registration_timeout:/etc/mesos-slave/executor_registration_timeout \
-v /var/run/docker.sock:/var/run/docker.sock   \
-v $(which docker):/bin/docker   \
-v /usr/lib/x86_64-linux-gnu/libapparmor.so.1:/usr/lib/x86_64-linux-gnu/libapparmor.so.1 \
-e "MESOS_WORK_DIR=/var/lib/mesos" \
-it mesos 


Run APP
curl -X POST http://ec2-54-210-211-178.compute-1.amazonaws.com:8080/v2/apps -d @app.json -H "Content-type: application/json"