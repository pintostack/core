# About

This is detailed description on how to deploy cluster using Vagrant installed on your local machine.

## Pre-requisites

System requres vagrant version 1.7.4 or higher. If you are using Ubuntu 14.04 LTS please update vagrant to the latest version. You can get your current version with ```vagrant -v```.
In case you do not have vagrant or virtualbox installed please use instructions below.

```bash
sudo apt-get update && sudo apt-get dist-upgrade
sudo apt-get install virtualbox
sudo apt-get install vagrant
```
(or https://www.vagrantup.com/downloads.html)
```bash
sudo apt-get isntall virtualbox-dkms
sudo vagrant plugin install vagrant-cachier
```
## Provisioning

Now it's time to run provision sh file
```
./provision.sh --target=vagrant --master=3 --slave=11
```

## Infrastructure

Once you finished provisioning virtual resources you can start deploying the cluster on it.
[Please follow instructions](README.md#bootstrap).
