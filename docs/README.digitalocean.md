# About

This is detailed description on how to deploy cluster in Digital Ocean.


## Prerequisites 
* Linux, FreeBSD, OSX, or other unix-like OS (Ubuntu 14.04 LTS or OSX 10.9+ recommended)
* Python 2.7
* Digital Ocean account and API key
* Vagrant 1.8 or later
* Ansible 2.1. At the time of writing of this document, Ansible 2.0 was still in beta. Latest version can be installed directly from master branch: ```pip install git+https://github.com/ansible/ansible.git```). 
* Following dependencies to run Ansible tasks:
```bash
apt-get install -y python-pip # You can skip this on your mac
pip install pyopenssl ndg-httpsclient pyasn1
pip install mock --upgrade
pip install six --upgrade
pip install dopy --upgrade
```
> NOTE: Depending on system configuration it might be required to run installation commands as super user. 

## Configuring Digital Ocean Account

### API Key
It's time to open digital ocean management [portal](https://cloud.digitalocean.com/settings/applications). On this page you'll need to create new API key, which will be used later. Simpy copy it into a safe place, we'll use it later.

### SSH Keys
For machines we are going to create we'll need SSH keys. In order to create a new ssh key pair follow [GitHub instructions](https://help.github.com/articles/generating-ssh-keys/). Now you should upload content of your public key file (usualy ~/.ssh/id_rsa.pub) with key name ```soft-cluster-key``` to the [digital ocean web site](https://cloud.digitalocean.com/settings/security).

> NOTE: Veify that you now have API key and SSH keys provisioned into Digital Ocean.

## Deployment

### Configure VPC details

Edit file ```source.digital_ocean```:
* ```SSH_KEY_ID=<NUMERIC KEY ID>``` , to get your key id you'll need API token. Run ```./infrastructure/digital_ocean.py --ssh-keys -p -a <ONE LINE API TOKEN> | grep -B1 soft-cluster-key```, searching your key id in a list ``` "id" : 1234567 ```. This numeric key id identifies ssh key that will be using later to login to the droplets.
* ```SSH_KEY_FILE=<FULL PATH TO SSH PRIVATE KEY FILE>``` (ususaly ~/.ssh/id_rsa), containing private key corresponding to the public key uploaded to digital ocean web site.
* ```SIZE=<DROPLET MEMORY SIZE>``` (8gb recomended, but do not use less than 4gb for this tutorial). Available options are listed [here](https://www.digitalocean.com/pricing/)
* ```LOCATION=<PREFERED DATACENTER FOR YOUR DROPLETS>```, (default is ams3 in Amsterdam). Available options are listed [here](https://www.digitalocean.com/features/reliability/) You can also get them by running ```./infrastructure/digital_ocean.py --regions -p -a <API_TOKEN>```.
* ```IMAGE_NAME=<INSTALLATION IMAGE FOR DROPLET>``` Default is ubuntu-14-04-x64. Do not change this until you know what you are doing. 

Here is an example of ```infrastructure/do.source```:
```bash
### Digital Ocean Account Parametrs
# For more information refere to https://github.com/pintostack/core

source source.global

# All variables add below

#SSH_KEY_FILE='~/.ssh/id_rsa'

DO_TOKEN='Change me'
DO_IMAGE='ubuntu-14-04-x64'
DO_REGION=ams3
DO_SIZE='8gb'
```





## Configure VPC details

### file: infrastructure/do.source

You can find the file under <software root>/infrastructure/do.source. File structure is very simple.

* ```SSH_KEY_FILE=<FULL PATH TO SSH KEY FILE YOU CREATED BEFORE>``` (ususaly ~/.ssh/id_rsa), containing private key corresponding to the public key uploaded to digital ocean web site.
* ```DO_SIZE=<DROPLET MEMORY SIZE>``` (8gb recomended), all available options see [here](https://www.digitalocean.com/pricing/) 8gb, 4gb, ...
* ```DO_REGION=<PREFERED DATACENTER FOR YOUR DROPLETS```, (default is ams3)all available options see [here](https://www.digitalocean.com/features/reliability/) nyc1, nyc2, ...
* ```DO_IMAGE=<INSTALLATION IMAGE FOR DROPLET>``` (default is ```ubuntu-14-04-x64```, do not change this until you know what you are doing) that image will be installed on your droplets

After all your ```source.digital_ocean``` file should look like this:
```bash
### Digital Ocean Account Parametrs
# For more information refere to https://github.com/pintostack/core

source source.global

# All variables add below

#SSH_KEY_FILE='~/.ssh/id_rsa'

DO_TOKEN='Change me'
DO_IMAGE='ubuntu-14-04-x64'
DO_REGION=ams3
DO_SIZE='8gb'
```

## Provisioning

Run
```
$ vagrant up --provider=digital_ocean
```

This may take a several minutes but after command completes you should be able to find new droplets in your digital ocean web site [console](https://cloud.digitalocean.com/droplets).  Also you can try to ssh to one of those new droplets by running ```vagrant ssh master-1```

## Infrastructure ready, lets bootstrap software

Once you finished provisioning droplets you can start deploying the cluster software on this new infrastructure.
[Please follow instructions](README.md#bootstrap).
