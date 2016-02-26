# How To Install PintoStack on legacy hosting or phisical machines

PintoStack from [DataArt](http://www.dataart.com/) is an open source Docker container system. It is very easy to set-up and to run and it offers an elegant solution for enterprise computing or for Big Data processing.

A new approach to running and managing distributed systems, PintoStack gives you immutable container infrastructure, with service discovery and continuous logging. Simply put, PintoStack is an easy, reliable and complete solution to get your cloud up and running.

This tutorial will guide you through the process of setting up PintoStack. Once complete, you will have a system consisting of:
- Docker containers
- Immutable infrastructure with Ansible and Vagrant
- Fault tolerant and fully elastic Marathon framework
- Dynamic service discovery via Consul
- Centralized logging with ELK stack
- iPython Notebook with Apache Spark for big data jobs


Prerequisites:

Managment PC/Laptop:
- [Docker](http://docker.io) installed on you managment computer or laptop
- User with sudo access on you managment computer or laptop

Server enviroment:
- You need atleast 3 servers
- All servers running 64-bit linux kernel OS
- All servers have a direct IP network interconnection on VPC intereface
- You can use your WAN interface for VPC but interface name on all servers needs to be same
- All servers need docker support in kernel (all modern linux based OS do, Ubuntu 14.04 Recomended)
- All servers need access to download from internet
- All servers need a same SSH username and same SSH/SUDO password
- Sudo priveleges is also required but NO PASSWORD will be add automaticaly

##Step # 1 - Build your PintoStack container.

Pull PintoStack image from DockerHub (If you can’t find PintoStack on DockerHub you can clone it from GitHub): 

```$ docker pull pintostack/pintostack```

or build a PintoStack image (if you are running 32-bit OS):

```$ docker build -t pintostack/pintostack .```

##Step # 2 - Configure your system for PintoStack.
First, set-up number of master/slaves in the PintoStack configuration file. In this tutorial we are using 1 master/3 slaves. Create a source.global file in conf folder on the host:

```$ sudo nano conf/source.global```

Change the MASTERS/SLAVES numbers to suit your configuration. In order for the cluster to run you need to have at least one master and one slave, you can always come back to this file to change the number.

```bash
### Global configuration

MASTERS=1
SLAVES=3

# Defaults. DO NOT overwrite variables below
SSH_KEY_FILE='~/.ssh/id_rsa'
ANSIBLE_INVENTORY_FILE=".vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory"
ANSIBLE_OPTS=""
```
>NOTICE: Remember you need MASTERS + SLAVES number of phisical servers.

Now we will set-up our servers. In this tutorial, our resource provider is managed server, so copy ```conf/source.managed.example``` to  ```conf/source.managed``` configuration file. And edit this file according to your resources.

```bash
### Managed Legacy Servers Parametrs
# For more information refere to https://github.com/pintostack/core

source conf/source.global

# All variables add below
# vagrant plugin install vagrant-managed-server

RESOURCE_PROVIDER='managed'
VPC_IF='eth0'
SSH_KEY_FILE='/pintostack/conf/id_rsa'

MANAGED_SSH_USERNAME='ubuntu'
MANAGED_SSH_PASSWORD='ubuntu'
MANAGED_MASTER_1="localhost"
MANAGED_SLAVE_1="192.168.10.149"
MANAGED_SLAVE_2="my-super-server.somewhere-in-inter.net"
```
Next, we need to create a new SSH key pair:

```$ ssh-keygen -t rsa```

at the prompt, save the pair into your conf folder: ```conf/id_rsa```. Ensure two files apeared in ```conf``` folder ```id_rsa``` and ```id_rsa.pub```.


```bash
$ docker run -d -v $(pwd)/conf:/pintostack/conf -v $(pwd)/.vagrant:/pintostack/.vagrant --name=pintostack-container pintostack/pintostack
```

Next, start a Bash session in your container: 

```$ docker exec -it pintostack-container bash```

Time to set-up your environment:

```# cd /pintostack```

```# ./pintostack.sh managed```
        
Congratulations, your cluster is up and running!

Now if you want to deploy an app (iPython notebook, for example) in the container:

```# ./marathon-push.sh ipythonnb.json```

If you want to check your system status, open Mesos UI, Marathon UI or Consul UI with:

```# ./open_webui.sh```

or head to http://master_ip:5050/ for Mesos UI, http://master_ip:8080/ui for Marathon UI.

If you want to access your logs, you have to deploy ElasticSearch and Kibana:

```# ./marathon-push.sh elasticsearch.json```

```# ./marathon-push.sh kibana.json```

and head to http://kibana.service.consul:5601/ for Kibana UI.
Consul UI lives on http://master_ip:8500/
