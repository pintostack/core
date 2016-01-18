# About

This is detailed description on how to deploy cluster in Digital Ocean.




## Prerequisites 
* Linux, FreeBSD, OSX, or other unix-like OS (Ubuntu 14.04 LTS or OSX 10.9+ recommended)
* Python 2.7
* Digital Ocean account and API key
* Ansible 2.0. At the time of writing of this document, Ansible 2.0 was still in beta. Latest version can be installed directly from master branch: ```pip install git+https://github.com/ansible/ansible.git```). 
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
### Getting PintoStack
Getting the snapshot from repository with command line GIT:
```
    $ git clone https://github.com/pintostack/core.git
    $ cd core
```

### Configure VPC details

Edit file ```infrastructure/do.source```:
* ```SSH_KEY_ID=<NUMERIC KEY ID>``` , to get your key id you'll need API token. Run ```./infrastructure/digital_ocean.py --ssh-keys -p -a <ONE LINE API TOKEN> | grep -B1 soft-cluster-key```, searching your key id in a list ``` "id" : 1234567 ```. This numeric key id identifies ssh key that will be using later to login to the droplets.
* ```SSH_KEY_FILE=<FULL PATH TO SSH PRIVATE KEY FILE>``` (ususaly ~/.ssh/id_rsa), containing private key corresponding to the public key uploaded to digital ocean web site.
* ```SIZE=<DROPLET MEMORY SIZE>``` (8gb recomended, but do not use less than 4gb for this tutorial). Available options are listed [here](https://www.digitalocean.com/pricing/)
* ```LOCATION=<PREFERED DATACENTER FOR YOUR DROPLETS>```, (default is ams3 in Amsterdam). Available options are listed [here](https://www.digitalocean.com/features/reliability/) You can also get them by running ```./infrastructure/digital_ocean.py --regions -p -a <API_TOKEN>```.
* ```IMAGE_NAME=<INSTALLATION IMAGE FOR DROPLET>``` Default is ubuntu-14-04-x64. Do not change this until you know what you are doing. 

Here is an example of ```infrastructure/do.source```:
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





## Configure VPC details

### file: infrastructure/do.source

You can find the file under <software root>/infrastructure/do.source. File structure is very simple.

Next items could be changed from do.source and corresponding yml files (./infrastructure/provision/do-*.yml):
* ```SSH_KEY_ID=<NUMERIC KEY ID>``` , you can get your key id by running ```./infrastructure/digital_ocean.py --ssh-keys -p -a <ONE LINE TOKEN YOU CREATED BEFORE> | grep -B1 <KEY NAME YOU ENTERED IN WEB CONSOLE>```  and searching your key id in a list. This numeric key id identifies ssh key that will be used later to login to the droplets.
* ```SSH_KEY_FILE=<FULL PATH TO SSH KEY FILE YOU CREATED BEFORE>``` (ususaly ~/.ssh/id_rsa), containing private key corresponding to the public key uploaded to digital ocean web site.
* ```SIZE=<DROPLET MEMORY SIZE>``` (8gb recomended), all available options see [here](https://www.digitalocean.com/pricing/) 8gb, 4gb, ...
* ```LOCATION=<PREFERED DATACENTER FOR YOUR DROPLETS```, (default is ams3)all available options see [here](https://www.digitalocean.com/features/reliability/) nyc1, nyc2, ... or by running ```./infrastructure/digital_ocean.py --regions -p -a <ONE LINE API TOKEN>``` and finding slug.
* ```IMAGE_NAME=<INSTALLATION IMAGE FOR DROPLET>``` (default is ubuntu-14-04-x64, do not change this until you know what you are doing) that image will be installed on your droplets

After all your ```infrastructure/do.source``` file should look like this:
```
# Digital Ocean Account Parametrs
SSH_KEY_ID=1234567
SSH_KEY_FILE=~/.ssh/id_rsa
SIZE=8gb
LOCATION=ams3
# Do not change this until you know what you are doing
IMAGE_NAME=ubuntu-14-04-x64
```

## Provisioning

Open terminal window and define environment variable for your session:
```
$ export DO_API_TOKEN=<ONE LINE API TOKEN, created before>
```
now it's time to run provisioning for your droplets, in same terminal window run 
```
$ cd <SOFTWARE ROOT DIRECTORY>
```
and
```
$ ./provision.sh --target=do --master=3 --slave=11
```

This may take a several minutes but after command completes you should be able to find 15 new droplets in your digital ocean web site [console](https://cloud.digitalocean.com/droplets). Checkout that 3 for masters, 11 for slaves, and 1 for docker-registry droplets was created and are running. Also you can try to ssh to one of those new droplets by copying ip addres and running ```ssh -i <PATH TO PRIVATE KEY  usualy /$HOME/.ssh/id_dsa> root@<DROPLET_IP>```

## Infrastructure ready, lets bootstrap software

Once you finished provisioning droplets you can start deploying the cluster software on this new infrastructure.
[Please follow instructions](README.md#bootstrap).
