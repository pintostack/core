# How To Install PintoStack

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

- [Docker](http://docker.io) installed 
- user with sudo access
- [Digital Ocean](http://digitalocean.com) account (for the purpose of this tutorial. PintoStack can work with AWS, Digital Ocean and Virtualbox)

##Step # 1 - Build your PintoStack container.

Pull PintoStack image from DockerHub (If you can’t find PintoStack on DockerHub you can clone it from GitHub): 

```$ docker pull pintostack```

and build a PintoStack image:

```$ docker build -t pintostack .```

##Step # 2 - Configure your system for PintoStack.

First, set-up number of master/slaves in the PintoStack configuration file. In this tutorial we are using 1 master/3 slaves. Create a source.global file in conf folder on the host:

```$ sudo nano conf/source.global```

Change the MASTERS/SLAVES numbers to suit your configuration. In order for the cluster to run you need to have at least one master and one slave, you can always come back to this file to change the number.

        ### Global configuration

        MASTERS=1
        SLAVES=3

        # Defaults. DO NOT overwrite variables below
        SSH_KEY_FILE='~/.ssh/id_rsa'
        ANSIBLE_INVENTORY_FILE=".vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory"
        ANSIBLE_OPTS=""

Now we will set-up our cloud servers. In this tutorial, our provider is Digital Ocean, so create a source.digital_ocean configuration file in conf folder on the host:

```$ sudo nano conf/source.digital_ocean```

At Digital Ocean API portal (https://cloud.digitalocean.com/settings/api/tokens) generate new token and insert it into the file instead of ‘TOKEN_ID’:
        
        ### Digital Ocean Account Parameters

        source conf/source.global

        # All variables add below

        SSH_KEY_FILE='/pintostack/conf/id_rsa'
        DO_TOKEN='TOKEN_ID'
        DO_IMAGE='ubuntu-14-04-x64'
        DO_REGION=nyc3
        DO_SIZE='8gb'
        
Next, we need to create a new SSH key pair:

```$ ssh-keygen -t rsa```

at the prompt, save the pair into your conf folder: ```~/conf/id_rsa```

Ensure the SSH key name Vagrant do not exist in your Digital Ocean account. You can use [this tutorial](https://www.digitalocean.com/community/tutorials/how-to-use-ssh-keys-with-digitalocean-droplets) for guidance.

### Step # 3 - Build and deploy PintoStack. 

First, start-up your PintoStack container (this step contains mounting your local conf and vagrant folders into /pintostack, plugging in inventory, settings and keys) :

```$ docker run -d -v $(pwd)/conf:/pintostack/conf -v $(pwd)/.vagrant:/pintostack/.vagrant --name=pintostack-container pintostack```

Next, start a Bash session in your container: 

```$ docker exec -it pintostack-container bash```

Time to set-up your environment:

```# cd /pintostack```

```# ./pintostack.sh digital_ocean```
        
Congratulations, your cluster is up and running!

Now if you want to deploy an app (iPython notebook, for example) in the container:

```# ./marathon-push.sh ipythonnb.json```

If you want to check your system status, open Mesos UI and Marathon UI with:

```# ./open_webui.sh```

or head to http://master_ip:5050/ for Mesos UI, http://master_ip:8080/ui for Marathon UI.

If you want to access your logs, you have to deploy ElasticSearch and Kibana:

```# ./marathon-push.sh elasticsearch.json```

```# ./marathon-push.sh kibana.json```

and head to http://master_ip:5601/ for Kibana UI.
Consul UI lives on http://master_ip:8500/ui 
