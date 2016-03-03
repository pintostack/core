1. setup cluster
2. submit chronos.json (./marathon-push chronos.json)
3. start cassandra (./marathon-push.sh cassandra.json)
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

5. start dispatcher


curl -L -H 'Content-Type: application/json' -X POST -d@file.json  http://ec2-52-53-218-73.us-west-1.compute.amazonaws.com:31268/scheduler/iso8601
