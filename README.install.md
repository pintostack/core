# About
This folder contains infrastructure provision and bootstrap scripts in ansible.

Cluster deployment process could be logically and physically split into two separate steps:

* Provisioning (new master, slave and docker-registry machines are created)
* Boostrapping (machines are configured to run in cluster)

But in fact both of thoes steps done by executing  ```vagrant up --provider=[aws|digital_ocean|virtualbox]```
First step creates virtual resources that are later used in bootstrap phase. After this stage completes you can access list of resources in provider and see new virtual machines executing ```vagrant global-status```. And connect to any of thoese machines by ```vagrant ssh <hostname>```

>NOTICE: It's important to notice that provisioning depends on the resource provider, and requires additional settings to be done on provider side. Bootstrap stage however less dependant, and uses ansible to deploy packages, configure software settings and so on. In some cases it is suggested to run ansible script from the same VPC where you will be deploying your cluster. Call it soft-cluster-launchpad for example but it is not required.

# Prerequisite

Depending on your virtual resource provider, it might be required to install additional software, section below defines common prerequisites.

## Prerequisite. Ansible 2.1
Download and install Ansible 2.1 from [here](http://releases.ansible.com/ansible/ansible-latest.tar.gz)
Other options to obtain fresh Ansible is to use ```pip``` (to get freshest version from github ```pip install git+https://github.com/ansible/ansible.git ```, metod ```pip install ansible``` do not work while ansible 2.1 not released yet.), mac users can use brew (```brew install ansible```).
Depending on system configuration it might be required to run installation command as super user.

> NOTE: But since version > 2.1 strictly required this method is recomended now ```pip install git+https://github.com/ansible/ansible.git```

## Prerequisite. Vagrant 1.8 or later
Download and install Vagrant 1.8 or later from [here](https://www.vagrantup.com/downloads.html)
Depending on system configuration it might be required to run installation command as super user.

> NOTE: Version > 1.8 strictly required. 

# Provisioning cluster machines

The package is designed to behave in a same way in all providers, however there are differences in required configuration variables for various providers so folow the next readme according to your provider.
## Edit ```source.provider``` files
### Virtualbox (local)
[Please follow the link for detailed instructions.](docs/README.virtualbox.md)

### DigitalOcean
[Please follow the link for detailed instructions.](docs/README.digital_ocean.md)

### AWS
[Please follow the link for detailed instructions.](docs/README.aws.md)

### Azure (temporary unsupported)
[Please follow the link for detailed instructions.](docs/README.azure.md)

## Bootstrap
In order to boostrap the cluster run ```vagrant up --provider=[aws|digital_ocean|virtualbox]``` this will creates machines and install and configure all newely provisioned machines and ensure the state of the existing ones, this step may take a while and several times console can freez for several minutes, please be patient.
>NOTE: Now after successful bootstrap you can open a Web UI of your system executing ```./open-webui.sh``` or ssh to your to any of your machine by typing ```vagrant ssh master-1```. If everithing works like expected you can proceed installing bundled application on this platform.

## Running bundled applications
If everithing works like expected you can run bundled application.
* First you need to build a docker container with application you want with ```./docker-push.sh <DOCKER DIR NAME>``` for more help run ```./docker-push.sh```.
* To actualy start docker container on cluster you need to push job description in JSON format to mesos server, usualy running on ```master-1``` host. You can find a list of bundled JOBs in marathon directory, and run ```./marathon-push.sh <JOB_DESC_NAME>.json```.

