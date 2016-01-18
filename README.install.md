# About
This folder contains infrastructure provision and bootstrap scripts in ansible.

Cluster deployment process could be logically and physically split into two separate steps:

* Provisioning (new master, slave and docker-registry machines are created)
* Boostrapping (machines are configured to run in cluster)
But in fact it is done by typing ```vagrant up --provider=[aws|digital_ocean|virtualbox]```
First step creates virtual resources that are later used by bootstrap phase. After this stage completes you can access list of resources in provider and see new virtual machines.
It's important to notice that provisioning depends on the resource provider, and requires additional settings to be done on provider side.
Bootstrap stage however less dependant, and uses ansible to deploy packages, configure software settings.

> NOTE: It is suggested to run ansible script from the same VPC where you will be deploying your cluster. Call it soft-cluster-launchpad for example.

# Prerequisite

Depending on your virtual resource provider, it might be required to install additional software, section below defines common prerequisites.

## Prerequisite. Ansible
Download and install Ansible 2.1 from http://releases.ansible.com/ansible/ansible-latest.tar.gz
Other options to obtain fresh Ansible are to use pip (to get freshest version from github ```pip install git+https://github.com/ansible/ansible.git ```, next metod do not work now on some platforms ```pip install ansible``` ), mac users can use brew (```brew install ansible```).
Depending on system configuration it might be required to run installation command as super user.

> NOTE: Version > 2.1 strictly required. This way is recomended now ```pip install git+https://github.com/ansible/ansible.git```

## Prerequisite. Vagrant
Download and install Vagrant 1.8 or later from https://www.vagrantup.com/downloads.html
Depending on system configuration it might be required to run installation command as super user.

> NOTE: Version > 1.8 strictly required. 

# Provisioning cluster machines

The package is designed to behave in a same way in all providers, however there are differences in what configuration variables are required for various providers.
## Edit source.provider files
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

NOTE: Now after successful bootstrap you can ssh to your machine by typing ```vagrant ssh master-1```. If everithing works like expected you can proceed installing bundled application on this platform with ```./docker-push.sh <DOCKER DIR NAME>``` and ```./marathon-push.sh <DOCKER IMAGE MRATHON DESC>.json```.

