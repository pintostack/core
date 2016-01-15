# About

This is detailed description on how to deploy cluster in Digital Ocean.

## Pre-requisites

We assume you already read [Pre-requisites in README.md](README.md#prerequisite) You would need several libraries installed on machine to work with digital ocean provider. For most of Mac users [python 2.7-or later required](https://www.python.org/downloads/mac-osx/), do not forget to close the terminal window and open a new one after installation. For Ubuntu 14.0.4 LTS Python 2.7 recomended but not necessary. Other requirments you can install with pip as described below.

```
# apt-get install -y python-pip # You can skip this on your mac
# pip install pyopenssl ndg-httpsclient pyasn1
# pip install mock --upgrade
# pip install six --upgrade
# pip install dopy --upgrade
```

## Configuring Digital Ocean for your cluster

> Token id

It's time to open digital ocean management [portal](https://cloud.digitalocean.com/settings/applications). On this page you need to create new token id, which is later used by ansible. Store this one line token in a save place you will need it while folowing this instruction and later.

> SSH Keys

SSH keys are used in order to perform authentication on the droplets. In order to create a new ssh key pair you might follow [this](https://help.github.com/articles/generating-ssh-keys/) link. Now you should upload content of your public key file (usualy ~/.ssh/id_rsa.pub) to the [digital ocean web site](https://cloud.digitalocean.com/settings/security) remembering key name.

NOTE: After cluster will be created you will be able to login into the droplets: ```ssh -i <path to your private key part> <user name>@<machine ip>``` 

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
