# Introduction

PintoStack is a container Platform as a Service for brave and true. A paradigm shift from how we used to run and manage distributed systems.

The core principles of PintoStack are:
- infrastructure immutability
- separation of services and infrastructure
- deterministic deployments
- service isolation and discovery

> NOTE: Want to spin a cluster and cruch some puilc data and tear it down afterwards? Try our IPython+Spark tutorial on top of UK Road Accidents data on DigitalOcean [here](docs/README.ipython-spark-hdfs.md) 

In our PaaS we are using the following fundamental components:
- **Containerization.** Every service in our cluster is a container. We use containers for DFS nodes, KV storages, web applications. We are using Docker for containerization, and deploying Docker Registry as the part of the cluster to store the images of all services and applications you'll be running.
- **Resource management.** Apache Mesos is used to abstract CPU, memory, storage, and other resources away from machines (physical or virtual), enabling fault-tolerant and elastic distributed systems to easily be built and run effectively. We are using Mesos to deploy our payload, which comes in the form of Docker containers as per.
- **Scheduling.** While Mesos provides resource abstraction, our services and applications need to be deployed, monitored and scaled. We are using Marathon from Mesosphere to define services in form of JSON files which link to Docker images in local registry.
- **Service Discovery.** Some services depend on others. We want our infrastructure to be immutable, hence we need service discovery. We are using Consul from Hashicorp. Consul is deployed on each host node and is accessible from every container. You can query Consul to register your service and get information about other services registered in the cluster. Service discovery is available through RESTful API and can be easily integrated into your applications and scripts. Service discovery is also available through a cluster-wide DNS service which allows to resolve service URI’s into IP addresses. For example db-0.service will resolve into an IP address of a machine where db-0 service is running. 
- **Logging.** We are using Elasticsearch Logstash and Kibana (ELK) for log aggreation and analysis. As everything in our cluster, ELK comes in the form of container availeble for deployment through Marathon. Having ELK containerized allows to run it at scale on the same cluster. All services and containers are shipping their logs into ELK providing you with a consolidated view of a distriubuted system. 
- **Run everywhere.** PintoStack infrastructure provisioned and bootstrapped using Vagrant and Ansible. Your applications and services are running in containers. This combination creates an abstraction from cloud or virtualization provider. You can tune PintoStack to run on DigitalOcean, AWS, GCE, Azure or private cloud running OpenStack or just KVM or xen.

# Running the Cluster
1. Provision and machines in cloud or virtualization provider of choice using Vagrant. Edit ```source.global``` to match your environment. This will give you clean machines to build on top of. 
```MATERS=N SLAVES=M ``` thrn run ```vagrant up --provider [aws|digital_ocean|virtualbox]```
This will bring necessery instances up and run bootstrap scripts giving you a ready to use environment in the end.
2. Build service containers and push them into registry. For example to build HDFS 2.6 that comes with PintoStack by running ```docker-build.sh hdfs```
3. Push Marathon jobs ```marathon-push.sh hdfs-nn.json``` and ```marathon-push.sh hdfs-dn.json``` to run HDFS DataNode and NameNode in PintoStack.
4. Discover services through consul REST API running ```curl http://$HOST/v1/catalog/service/cassandra-dev``` on each node or resolve through DNS as ```cassandra-dev.service.consul```.

Find out more in this [step by step guide](./README.install.md) 

# Building Docker Images
You can start with one of existing images available in docker registry as an example, or start a new one.
Once you are done with your image configuration feel free to push it into the docker registry by runnging
```./docker-duild.sh <image directory name> ```
Command will create docker image and push it into local cluster registry.

# Starting Tasks
Marathon and Mesos together are guarding task execution. Creating marathon tasks is easy process, as usual there are several tasks defined in marathon directory.
Create a copy of a file containing existing task definition, change docker image path, task name and other task specific parameters.
You probably want to edit number of ports task scheduler framework will book for you, healthcheck parameters.
Starting your task is easy, just enter the command into the shell:

```./marathon-push.sh <marathon task file name with json> ```

For instance ```./marathon-push.sh kafka.json ```.

No you can open marathon on your master machine and see how task is deployed to the slave machine.
Typically marathon web ui available on port 8080, and mesos information on 5050. 

# History
It all started with trying to setup a scalable performance testing environment for http://devicehive.com where we could independently run our application containers, test containers, and infrastructure: Cassandra and Kafka. We wanted something we could play with locally to ensure it runs property and set for a real test in cloud infrastructure. After extensive search, everything we found was too provider specific and required extensive background knowledge. Docker swarm, docker compose, chef, puppet, you name it. There were bits and pieces, and tutorials and discussion threads, but there was not solution. That’s when the work has started. 
