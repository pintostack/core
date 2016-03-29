# Overview

PintoStack from DataArt is an open source Docker container system. It is very easy to set-up and to run and it offers an elegant solution for enterprise computing or for Big Data processing.

A new approach to running and managing distributed systems, PintoStack gives you immutable container infrastructure, with service discovery and continuous logging. Simply put, PintoStack is an easy, reliable and complete solution to get your cloud up and running.

## Setup juju environment

Edit ```~/.juju/environments.yaml``` 

Than open terminal window, go to ```examples/uk-juju``` and edit ```config.yaml.tmpl``` and save it to ```config.yaml```. After editing it sould look like this example below:
```
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
* Make sure ```AWS_AMI``` you using is available in this ```AWS_REGION```, you you are not sure use defaults.

```
$ deploy_uk_demo.sh
```


Folow  [this](https://jujucharms.com/juju-gui/) instructions to start JuJu GUI
Run 
```
juju deploy juju-gui --to 0
juju expose juju-gui
```
Use ```juju stat``` to find juju-gui address

## Building Pintostack charm

Go to folder conteining this charm and run

```
$ juju charm build pintostack
```
This will create a subfolder ```trusty``` conteining ready pintostck charm

## Deploying Pintostack Charm

Open directory containing this charm and run

```
$ juju deploy --repository=$(pwd) local:trusty/pintostack --to 0
```

> NOTICE: Add ```--to 0``` to deploy on same machine


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

