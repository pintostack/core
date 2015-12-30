# IPYTHON NOTEBOOK WITH SPARK CONTEXT AND HDFS RUNNING ON SOFT-CLUSTER TUTORIAL 

## ABOUT
Completing this tutorial you will get iPython Notebook web interface front-end with integration in Apache SPARK big data processing engine and access to Apache Hadoop (HDFS) storage. Also you can add new HDFS or SPARK nodes when needed by one click. This document contains an easy to use solution for Data Scientists, Data Analytics and others envolved in Big Data processing to get an on-demand playground without big investments. Solution offered as a reference in this tutorial is automatic ent-to-end cluster deployment and management system running on your laptop with hundreds of droplets (VM's) running in a back-ground on Digital Ocean's platform. 

> NOTE: This tutorial was verified on PC running Ubuntu 14.0.4 LTS and Mac running OSX 10.9 with Digital Ocean account.

## PREREQUISITES 

This tutorial was written assuming you already have:
* Machin/Laptop running Linux, FreeBSD, Mac OSX, or other unix like OS (UBUNTU 14.0.4 LTS or OSX 10.9 recommended)
* Git software installed
* You already have Digital Ocean account with full access
* You have enough money on your Digital Ocean account to run at least 15 x 8Gb droplets

### REQUIRED SOFTWARE INSTALLATION

Before you begin you have to install some software
* Python 2.7 (For Ubuntu 14.0.4 LTS recommended but not necessary ) - For Mac users [python 2.7-or later required](https://www.python.org/downloads/mac-osx/), do not forget to close the terminal window and open a new one after installation. We hope that users of other supported OS's knows how to swhich to python 2.7. 
* Ansible 2.1 or later strictly required - You can obtain fresh Ansible using ```pip``` (to get latest version from github installed run ```# pip install git+https://github.com/ansible/ansible.git```). Other option is to download and install Ansible 2.1 from ```http://releases.ansible.com/ansible/ansible-latest.tar.gz```. First way is recomended now.
* After all done you have to run following commands in command-line to install required python modules:
```
# apt-get install -y python-pip # You can skip this on your mac
# pip install pyopenssl ndg-httpsclient pyasn1
# pip install mock --upgrade
# pip install six --upgrade
# pip install dopy --upgrade
```

> NOTE: Depending on system configuration it might be required to run installation commands as super user. 

### CONFIGURING DIGITAL OCEAN ACCOUNT

#### Token id

It's time to open digital ocean management [portal](https://cloud.digitalocean.com/settings/applications). On this page you need to create new token id, which will be used later . Store this one line token in a save place, you will need it while folowing this instruction and later.

#### SSH Keys

SSH keys are used in order to perform authentication on the droplets. In order to create a new ssh key pair you might follow [GitHub instruction](https://help.github.com/articles/generating-ssh-keys/). Now you should upload content of your public key file (usualy ~/.ssh/id_rsa.pub) with key name ```soft-cluster-key``` to the [digital ocean web site](https://cloud.digitalocean.com/settings/security).


> NOTE: It is importent that you have 3 things compleating this section: one line API Token, SSH Private key (usualy ~/.ssh/id_rsa), SSH Public key (usualy ~/.ssh/id_rsa.pub). After cluster will be created you will be able to login into the droplets: ```ssh -i <path to your private key part> <user name>@<machine ip>```

## DEPLOYMENT

Please make sure you satisfy [PREREQUISITES](#prerequisites) before getting started.

### GETTING SNAPSHOT

Getting the snapshot from repository with command line GIT:
```
    $ git clone https://github.com/astaff/soft-cluster.git
    $ cd soft-cluster
    $ git checkout 78bbde5cf3b1cb897ec9074a1421f5ad091fbeeb
```

### Configure VPC details

#### Edit file: ```infrastructure/do.source```

You can find the Digital Ocean configuration in ```soft-cluster/infrastructure/do.source```. File structure is very simple. Next items could be changed from do.source:
* ```SSH_KEY_ID=<NUMERIC KEY ID>``` , to get your key id you need API token you created before and run ```./infrastructure/digital_ocean.py --ssh-keys -p -a <ONE LINE API TOKEN> | grep -B1 soft-cluster-key```, searching your key id in a list ``` "id" : 1234567 ```. This numeric key id identifies ssh key that will be using later to login to the droplets.
* ```SSH_KEY_FILE=<FULL PATH TO SSH PRIVATE KEY FILE>``` (ususaly ~/.ssh/id_rsa), containing private key corresponding to the public key uploaded to digital ocean web site.
* ```SIZE=<DROPLET MEMORY SIZE>``` (8gb recomended, but do not use less than 4gb for this tutorial), all available options see [here](https://www.digitalocean.com/pricing/) 16gb, 8gb, 4gb, ...
* ```LOCATION=<PREFERED DATACENTER FOR YOUR DROPLETS>```, (default is ams3 in Amsterdam) all available options see [here](https://www.digitalocean.com/features/reliability/) nyc1, nyc2, ... or by running ```./infrastructure/digital_ocean.py --regions -p -a <ONE LINE API TOKEN>``` and finding slug.
* ```IMAGE_NAME=<INSTALLATION IMAGE FOR DROPLET>``` (default is ubuntu-14-04-x64, do not change this until you know what you are doing) that image will be installed in your droplets

After all your ```infrastructure/do.source``` file should look like this:
```
# Digital Ocean Account Parametrs
# SSH_KEY_ID=<NUMERIC KEY ID>
SSH_KEY_ID=1234567
# SSH_KEY_FILE=<FULL PATH TO SSH PRIVATE KEY FILE ususaly ~/.ssh/id_rsa>
SSH_KEY_FILE=~/.ssh/id_rsa
# SIZE=<DROPLET MEMORY SIZE do not use less than 4gb for this tutorial>
SIZE=8gb
# LOCATION=<PREFERED DATACENTER FOR YOUR DROPLETS ams3 in EU or nyc3 in US>
LOCATION=ams3
# Do not change this until you know what you are doing
IMAGE_NAME=ubuntu-14-04-x64
```

### PROVISIONING

Open terminal window and define environment variable for your session:
```
$ export DO_API_TOKEN=<ONE LINE API TOKEN>
```
Now it's time to run provisioning for your droplets, in same terminal window run 
```
$ cd <SOFTWARE ROOT DIRECTORY>
```
and
```
$ ./provision.sh --target=do --master=3 --slave=11
```

> NOTE: This may take a several minutes but after command completes you should be able to find 15 new droplets in your digital ocean web site [console](https://cloud.digitalocean.com/droplets). Checkout that 3 for masters, 11 for slaves, and 1 for docker-registry droplets was created and are running. Also you can try to ssh to one of those new droplets by copying ip addres and running ```ssh -i <PATH TO PRIVATE KEY  usualy /$HOME/.ssh/id_dsa> root@<DROPLET_IP>```

### BOOTSTRAPING

In soft-cluster directory run:
```
$ ./bootstrap-masters.sh && ./bootstrap-slaves.sh && ./bootstrap-docker-registry.sh
```
> NOTE: After successful bootstrap you can find an ip address of master-1 host in your [Digital Ocean web console](https://cloud.digitalocean.com/droplets) and open in browser ```http://<MASTER-1_IP>:5050``` and ```http://<MASTER-1_IP>:8080``` to see the cluster managment interfaces. If everithing works like expected you can proceed installing bundled application on this platform.

### RUNNING iPython Notebook in SPARK Context and HDFS cluster

#### BUILDING DOCKER CONTAINERS

In the docker/ directory you can find all bundled Docker containers to setup all working with soft-cluster
```
$ ls docker
$ ./docker-push.sh ipythonnb && ./docker-push.sh hdfs
```  

#### RUNNING CONTAINERS IN CLUSTER

To run built containers you should submit JSON container descreption to marathon (running on ```http://<master-1_ip>:5050```):
```
$ ls marathon
$ ./marathon-push.sh ipythonnb.json && ./marathon-push.sh hdfs-nn.json
```
Now wait for HDFS/namenode to get from ```Deploing``` to ```Running``` status in marathon web UI (running on ```http://<master-1_ip>:5050```).
```
$ ./marathon-push.sh hdfs-dn.json
```
Now wait for HDFS/datanode to get from ```Deploing``` to ```Running``` status in marathon web UI (running on ```http://<master-1_ip>:5050```) and you can create more HDFS datanodes directly in marathon web UI. For this tutorial you should create at least one HDFS datanode.

> NOTE: You can open iPython Notebook web UI by finding ipythonnb on applications tab of marathon web UI ```http://<master-1_ip>:5050``` and geting node name it is running on (usualy slave-1). Now search this node IP in your [Digital Ocean web console](https://cloud.digitalocean.com/droplets), and open in browser ```http://<slave-X-ip>:31080```.

## RUNNING EXAMPLE

First make sure iPython Notebook web UI is running by finding ```ipythonnb``` on applications tab of marathon web UI ```http://<master-1_ip>:5050``` clicking it and getting name of the node it is running on (usualy slave-1). Now search this node IP in your [Digital Ocean web console](https://cloud.digitalocean.com/droplets), and open it in browser ```http://<slave-X-ip>:31080```

### UPLOADING DATA FILE TO HDFS

```bash
 hadoop fs -put README.txt hdfs://slave-1.node.consul:31851/
```

### RUNNING DATA ANALITIC SCRIPT

```python
text_file = sc.textFile("hdfs://hdfs.service.consul:31851/README.txt")
word_counts = text_file \
    .flatMap(lambda line: line.split()) \
    .map(lambda word: (word, 1)) \
    .reduceByKey(lambda a, b: a + b)
word_counts.collect()
```
