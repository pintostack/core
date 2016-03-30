# Overview

PintoStack from DataArt is an open source Docker container system. It is very easy to set-up and to run and it offers an elegant solution for enterprise computing or for Big Data processing.

A new approach to running and managing distributed systems, PintoStack gives you immutable container infrastructure, with service discovery and continuous logging. Simply put, PintoStack is an easy, reliable and complete solution to get your cloud up and running.

## Configuring EC2 for your cluster with JUJU

### Region

Before starting the deployment process you might select a region where it would reside we sugest you to use default one from ```config.yaml.tmpl``` file ```AWS_REGION='us-west-2'```. But EC2 allows you to select from number of available regions.
Configuration would require from you the name of region you selected, lilke, us-west-1, or eu-east-2 put in ```source.aws``` file like ```AWS_REGION='us-west-2'```

> IMPORTANT: Remember that AWS_AMI and AWS_SECURITY_GROUPS are region specific.

### SSH Keys or so called in AWS Console ```[Network & Security] > [Key Pairs]```

The keys are used to replace password based authentication. EC2 requires you to setup a keypair in management console. If you do not have keypair, it's easy to create new one open ```[AWS Console] > [EC2]``` then in left pane ```[Network & Security] > [Key Pairs]``` in case there are existing key pairs in your AWS account you can use it as well. We sugest you to name a new key pair ```PintoStack```. And save the key file in save place and put the path to you key file in ```source.aws``` for example it looks like this ```SSH_KEY_FILE='~/Downloads/PintoStack.pem.txt'``` and ```AWS_KEYPAIR_NAME='PintoStack'```.
> IMPORTANT: Please note that keypairs are also region specific and to read more please follow the [this link](http://docs.aws.amazon.com/opsworks/latest/userguide/security-ssh-access.html).

### Network and Firewall so called in AWS Console ```[Network & Security] > [Security Groups]```

We sugest you create two default security groups for your cluster with names ```default``` and ```allow-ssh``` to do so open ```[AWS Console] > [EC2]``` then in left pane ```[Network & Security] > [Security Groups]``` than create one with name ```pintostack```

* After security groups has bin created, chose the one named ```pintostack``` and the same way add three inbound rules to allow ```SSH ,TCP port 5050, TCP port 8080, TCP port 8500``` and save. If you are doing this for first time you can add ```Allow ALL```, but remember it is unsafe.

Remember security groups you want to apply to your new instances should be listed in ```config.yaml``` file in ```AWS_SECURITY_GROUPS='juju-amazon,juju-amazon-0,pintostack'```

>NOTICE: For more information on AWS Security Groups look [here](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_SecurityGroups.html).


### API Access key and secret

 * Open [the IAM console](https://console.aws.amazon.com/iam/home?#home)
 * In the navigation pane, choose Users.
 * Choose your IAM user name (not the check box).
 * Choose the Security Credentials tab and then choose Create Access Key.

To see your access key, choose Show User Security Credentials. Your credentials will look something like this:
```
  Access Key ID: AKIAIOSFODNN7EXAMPLE
  Secret Access Key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```
Choose Download Credentials, and store the keys in the ```config.yaml``` file in ```AWS_KEY_ID='Change me'``` and ```AWS_ACCESS_KEY='Change me'```. 

>NOTICE: For more information on Amazon Access keys look [here](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html)


### AMI and user name

AMI name is the name of image that is used as a source for your virtual instances. So if you chose a different region than we sugested in default ```source.aws``` like ```AWS_REGION='us-west-2'``` you need to change default ```AWS_AMI='ami-5189a661'```. To do so, open this [link](https://cloud-images.ubuntu.com/locator/ec2/) and type for example if you would like to find out the AMI-ID for the latest release of “LTS” Ubuntu to run on a “64″ bit “ebs” instance in the “us-east” region, you would search for ```lts 64 us-east ebs```.

>NOTICE: You can try other options like [archlinux](https://www.uplinklabs.net/projects/arch-linux-on-ec2/), or even [BSD](http://www.daemonology.net/freebsd-on-ec2/) but it was not tested.

## Provisioning


Edit ```~/.juju/environments.yaml``` 

Than open terminal window, go to ```examples/uk-juju``` and edit ```config.yaml.tmpl``` and save it to ```config.yaml```. After editing it sould look like this example below:
```yaml
---
pintostack:
    resource-provider-config: |
        AWS_KEY_ID='AKIsdklfgjkldfsgkljdfQ'
        AWS_ACCESS_KEY='9MkZdfsgdfklsgjdf567klsgjkldfjfl8N8uz'
        AWS_KEYPAIR_NAME=PintoStack
        AWS_ROOT_PARTITION_SIZE=20
        AWS_AMI=ami-5189a661
        AWS_INSTANCE_TYPE=t2.micro
        AWS_REGION=us-west-2
        AWS_SECURITY_GROUPS='juju-amazon,juju-amazon-0,pintostack'
        AWS_SSH_USERNAME=ubuntu
        AWS_TERMINATE_ON_SHUTDOWN=true
    slaves-number: 8
    ssh-private-key: |
      -----BEGIN RSA PRIVATE KEY-----
      MIIEpQIBAAKCAQEA4s9/wZS02ds3AYO2j+riPAxIdD8KTe7Em4okE7VE8P5hwxmT94wFVNs11JP6
      jxb1MLdbcWcKVH4JIBsdYW94C0R2XI7XYJ7Znetxhh0H3R97jQM9TIF6wYKt1FAAfADh0a76mRxq
      C2GfAg+sGHZzzty5ooPnBhpfMuLsWcWLrf3LpCelYzFl1XG+2ZSLX5O1rA5oLV6INHQIOjDhCQ46
      MV1HydJhlBHPMGxhGGtc2X1kBjiyXoMiOTkyGEE+kzLBv9Ea0BxLJmnXbQ5eeWaMcrBPWMm38IgW
      Ehn6owHr+UQPS+qOunI4xhz6Af1p60ahiCP8By52JiQEQY0htrHOCQIDAQABAoIBAQCTqJb5xgA/
      vJlTxFLaaZ/e+kJ4ohJ17cEKoHueN80z3G47yTN25dJmAZjgkr3MGWebJUyMmERki9/doG+bOaD0
      OIfT/6zv8OZ1TOusFHWSJpIgKK80umxOHl7ALGURAIQjc7knTht7btx2Ik+SKlwrmJwFDAE=
      -----END RSA PRIVATE KEY-----

```

> REMEMBER: This file is YAML formated so it is very important to preserv line spaces and leading TABs, you cat check your syntax [online](http://www.yamllint.com/).

### Before begining:

* Make sure you use same ```AWS_REGION``` as in ```~/.juju/environments.yaml```.
* Make sure ```AWS_SECURITY_GROUPS``` contains ```juju-amazon```, ```juju-amazon-0```, ```pintostack``` -last one you have to create your self in AWS Console
* Make sure ```AWS_AMI``` you using is available in this ```AWS_REGION```, if you are not sure use defaults.

### Deploying with JUJU

Open terminal window, go to ```examples/uk-juju``` subfolder and run:

```
$ deploy_uk_demo.sh
```

This will build all charms and deploys all cluster components.

Monitor the status of ```pintostack/0``` unit

```
$ juju stat
```

To get access to pintostack context use

```
$ juju ssh pintostack/0
```

## Using PintoStack actions

```
$ juju action defined  pintostack
docker-push: Push Dockerfile to be build in DockerImage and put to docker-registry.service.consul:5000.
marathon-push: Push JSON task description to marathon.
run: Run any comand in pintostack context.
```

### Docker Push
```
$ juju action do pintostack/0 docker-push dockername="hdfs"
```

### Marathon Push
```
$ juju action do pintostack/0 marathon-push jsonfile="hdfs-nn.json"
```

