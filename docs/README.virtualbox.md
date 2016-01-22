# About

This is detailed description on how to deploy cluster using Vagrant installed on your local machine.

## Prerequisites
* Linux, FreeBSD, OSX, or other unix-like OS (Ubuntu 14.04 LTS or OSX 10.9+ recommended)
* Python 2.7
* Fully functioning VirtualBox 4 or later
* Ansible 2.0. Proper version can be installed this way: ```pip install "ansible>=2"``` 
* Vagrant 1.8 or later you can download from [here](https://www.vagrantup.com/downloads.html)

In case you do not have vagrant or virtualbox installed please use instructions below.

```bash
sudo apt-get update && sudo apt-get dist-upgrade
sudo apt-get install virtualbox
``` 

```bash
sudo apt-get isntall virtualbox-dkms
sudo vagrant plugin install vagrant-cachier
```
## Provisioning
Edit source.global file to set the number of ```MASTERS=1``` and ```SLAVES=3``` or whatever you need.
Now it's time to run provisioning
```bash
vagrant up --provider=virtualbox
```

## Infrastructure

Once you finished provisioning virtual resources you can start deploying the cluster on it.
[Please follow instructions](../README.install.md#bootstrap).
