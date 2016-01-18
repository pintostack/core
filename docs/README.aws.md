# About

This is detailed description on how to deploy cluster in Amason AWS Cloud.

## Prerequisites 
* Linux, FreeBSD, OSX, or other unix-like OS (Ubuntu 14.04 LTS or OSX 10.9+ recommended)
* Python 2.7
* Digital Ocean account and API key
* Ansible 2.1. At the time of writing of this document, Ansible 2.0 was still in beta. Latest version can be installed directly from master branch: ```pip install git+https://github.com/ansible/ansible.git```). 
* Following dependencies to run Ansible tasks:

## Configuring EC2 for your cluster

### Region

Before starting the deployment process you might select a region where it would reside. EC2 allows you to select from number of available regions.
Configuration would require from you the name of region you selected, lilke, us-west-1, or eu-east-2.

### SSH Keys

The keys are used to replace password based authentication. EC2 requires you to setup a keypair in management console, to read more please follow the [link](http://docs.aws.amazon.com/opsworks/latest/userguide/security-ssh-access.html). If you do not have keypair, it's easy to create new one from AWS Console; in case there are existing key pairs in your aws account you can use it as well.
Please note that keypairs are region specific.

### Network

Create VPC and subnet for your cluster, or choose of any existing that suits your cluster requirement. Default EC2 settings are good for fresh start, but depending on your resource requirements it could happen that you would need bigger subnet. Please follow the [link](https://us-west-2.console.aws.amazon.com/vpc/home?region=us-west-2#) to open VPC dashboard. Later you would need to enter subnet id, so please remember it, or you can find later get it from dashboard.

### Security group

Create default security group for your cluster with name ```PintoStack```. It's still possible to amend security settings later, once you'll identify fine-grained security constraints for your machines.

### Access key and secret

Access key ans secret part are used to authenticate scripts on amazon ec2, so you provide key and secret to the script, but not your login name and password. To get keys please read the detailed instruction on aws web [site](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html)

### AMI and user name

AMI name is the name of image that is used as a source for your virtual instances. Name of AMI depends on the region, and there are number of online tools that can help you to find the name, for instance https://cloud-images.ubuntu.com/locator/ec2/ for ubuntu, https://www.uplinklabs.net/projects/arch-linux-on-ec2/ for archlinux, and even bsd http://www.daemonology.net/freebsd-on-ec2/.

## Configure VPC details

### File ```source.aws```

You can find the file under in source directory.

Here is detailed description of settings available:

AWS_REGION=it's region id for your cluster

AWS_ACCESS_KEY_ID=amazon ec2 console access key id

AWS_SECRET_ACCESS_KEY=amazon ec2 console secret key

AWS_VPC_SUBNET_ID=this is subnet id you created

AWS_AMI=the ami name

AWS_SSH_KEY_NAME=the name of key that should be installed as auth on machine

SSH_KEY_PATH=full path to the key on your local machine
Finally it should look like:
```
### Amazon AWS Account Parametrs
# For more information refere to https://github.com/pintostack/core

source source.global

# All variables add below

#SSH_KEY_FILE='~/Downloads/AWS_KEYPAIR_NAME.pem'

AWS_KEY_ID='Change me'
AWS_ACCESS_KEY='Change me'
AWS_KEYPAIR_NAME='PintoStack'
AWS_AMI='ami-5189a661'
AWS_INSTANCE_TYPE='m4.large'
AWS_REGION='us-west-2'
AWS_SECURITY_GROUPS="'default','allow-ssh'"
AWS_USERNAME='ubuntu'
```
## Provisioning

Open terminal window and run provision sh file
```
vagrant up --provider=aws
```

## Infrastructure

Once you finished provisioning virtual resources you can start deploying the cluster on it.
[Please follow instructions](../README.md#bootstrap).
