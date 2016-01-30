# About

This is detailed description on how to deploy cluster in Digital Ocean.


## Prerequisites 
* Linux, FreeBSD, OSX, or other unix-like OS (Ubuntu 14.04 LTS or OSX 10.9+ recommended)
* Python 2.7
* Digital Ocean account and API key
* Ansible 2.0. Latest version can be installed: ```pip install ansible```). 
* Vagrant 1.8 or later with ```digital_ocean``` plugin

To install Vagrant plugin run:
```
sudo vagrant plugin install digital_ocean
```
Following dependencies to run Ansible tasks:
```bash
apt-get install -y python-pip # You can skip this on your mac
pip install pyopenssl ndg-httpsclient pyasn1 mock six dopy --upgrade
```
> NOTE: Depending on system configuration it might be required to run installation commands as super user. 

## Configuring Digital Ocean Account

### Creating API Token

It's time to open digital ocean management [portal](https://cloud.digitalocean.com/settings/applications). On this page you need to create new token id, which will be used later . Edit file ```source.digital_ocean``` and put this one line tokent to ```DO_TOKEN='Change me'```.

## Deployment

### Generating SSH Keys

For machines we are going to create we'll need SSH keys. In order to create a new ssh key pair follow [GitHub instructions](https://help.github.com/articles/generating-ssh-keys/). Now system will automaticaly upload content of your public key file (usualy a pivate key ```~/.ssh/id_rsa``` with extention ```.pub```) with key name ```Vagrant``` to the Digital Ocean. And after all done you will see it [here](https://cloud.digitalocean.com/settings/security) later.

### Configure VPC details

Edit file ```source.digital_ocean```:
* ```DO_SIZE=<DROPLET MEMORY SIZE>``` (8gb recomended, but do not use less than 4gb for this tutorial). Available options are listed [here](https://www.digitalocean.com/pricing/)
* ```DO_REGION=<PREFERED DATACENTER FOR YOUR DROPLETS>```, (default is ```ams3``` in Amsterdam). Available options are listed [here](https://www.digitalocean.com/features/reliability/)
* ```DO_IMAGE=<INSTALLATION IMAGE FOR DROPLET>``` Default is ```ubuntu-14-04-x64```. Do not change this until you know what you are doing. 

Here is an example of ```source.digital_ocean``` file:
```bash
### Digital Ocean Account Parametrs
# For more information refere to https://github.com/pintostack/core

source source.global

# All variables add below

SSH_KEY_FILE='~/.ssh/id_rsa'
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

This may take a several minutes but after command completes you should be able to find new droplets in your digital ocean web site [console](https://cloud.digitalocean.com/droplets).  You can run ```./open-webui.sh``` to see a web ui, or you can try to ssh to one of those new droplets by running ```vagrant ssh master-1```

Once you finished provisioning droplets you can start deploying the cluster software on this new infrastructure.
[Please follow instructions](../README.install.md#bootstrap).
