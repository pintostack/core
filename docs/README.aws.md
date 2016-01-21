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
> IMPORTANT: Remember that AMI_NAME and SEQURITY_GROUPS are region specific.

### SSH Keys or so called in AWS Console Network & Security Key Pairs

The keys are used to replace password based authentication. EC2 requires you to setup a keypair in management console, to read more please follow the [this link](http://docs.aws.amazon.com/opsworks/latest/userguide/security-ssh-access.html). If you do not have keypair, it's easy to create new one from AWS Console then Network & Security then Key Pairs; in case there are existing key pairs in your AWS account you can use it as well. We sugest you to name a new key pair ```PintoStack```. And save the key file in save place and put the path to you key file in ```source.aws``` for example it looks like this ```SSH_KEY_FILE='~/Downloads/PintoStack.pem.txt'```
> IMPORTANT: Please note that keypairs are also region specific.

### Network and Firewall so called in AWS Console ```Network & Security > Security Groups```

Create VPC and subnet for your cluster, or choose of any existing that suits your cluster requirement. Default EC2 settings are good for fresh start, but depending on your resource requirements it could happen that you would need bigger subnet. Please follow the [link](https://us-west-2.console.aws.amazon.com/vpc/home?region=us-west-2#) to open VPC dashboard. Later you would need to enter subnet id, so please remember it, or you can find later get it from dashboard.

### Security group

Create default security group for your cluster with name ```PintoStack```. It's still possible to amend security settings later, once you'll identify fine-grained security constraints for your machines.
> NOTICE: Remember security groups you want to apply to your new instances should be listed in source.digitall_ocean file in ASW_SECURITY_GROUPS

### Access key and secret

Access key ans secret part are used to authenticate scripts on amazon ec2, so you provide key and secret to the script, but not your login name and password. To get keys please read the detailed instruction on aws web [site](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html)

### AMI and user name

AMI name is the name of image that is used as a source for your virtual instances. Name of AMI depends on the region, and there are number of online tools that can help you to find the name, for instance https://cloud-images.ubuntu.com/locator/ec2/ for ubuntu, https://www.uplinklabs.net/projects/arch-linux-on-ec2/ for archlinux, and even bsd http://www.daemonology.net/freebsd-on-ec2/.

## Configure VPC details

```
AWS_KEY_ID='<KEY>'
AWS_ACCESS_KEY='<ACCESS_KEY>'
AWS_KEYPAIR_NAME='<KEY NAME>'
AWS_AMI='<AMI>'
AWS_INSTANCE_TYPE='t2.medium'
AWS_REGION='us-west-1'
AWS_SECURITY_GROUPS="default,<GROUP WHERE SSH IS ALLOWED"
AWS_SSH_USERNAME='<USERNAME TO SSH TO VIRTUAL MACHINE'
SSH_KEY_FILE=<FULL PATH TO PEM FILE>
```

## Provisioning

Open terminal window and run provision sh file
```
vagrant up --provider=aws
```

## Infrastructure

Once you finished provisioning virtual resources you can start deploying the cluster on it.
[Please follow instructions](../README.install.md#bootstrap).
