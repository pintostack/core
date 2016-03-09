1. setup cluster
2. submit chronos.json (```./marathon-push.sh chronos.json```)
3. start cassandra (```./marathon-push.sh cassandra.json```)
    from cassandra:3.3 running container connect to cassandra: cqlsh slave-2 31161
4. create space and table, insert value.

CREATE KEYSPACE mykeyspace
WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };

USE mykeyspace;

CREATE TABLE numbers (
  number_id int PRIMARY KEY,
  value int
);

insert into numbers (number_id, value) values (1, 1);

5. start dispatcher (./marathon-push.sh spark-dispatcher.json)

https://issues.apache.org/jira/browse/SPARK-13258
SPARK_JAVA_OPTS="-Dspark.mesos.executor.home=/ -Dspark.mesos.executor.docker.image=cyberdisk/spark:latest -Dspark.task.cpus=1 -Dspark.cores.max=8" ./bin/spark-submit \
  --class SimpleApp \
  --master mesos://ec2-54-193-23-64.us-west-1.compute.amazonaws.com:31286 \
  --deploy-mode cluster --supervise  --executor-memory 300M \
  --total-executor-cores 2 \
  --conf spark.task.cpus=1 \
  --conf spark.cores.max=8 \
  --conf spark.mesos.executor.home=/ \
  --conf spark.mesos.executor.docker.image=cyberdisk/spark:latest \
  https://s3-us-west-1.amazonaws.com/ygpublic/simple-project_2.10-1.0.jar \
  1



curl -L -H 'Content-Type: application/json' -X POST -d@file.json  http://ec2-52-53-218-73.us-west-1.compute.amazonaws.com:31268/scheduler/iso8601
