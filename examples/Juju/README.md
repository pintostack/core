# Overview

PintoStack from DataArt is an open source Docker container system. It is very easy to set-up and to run and it offers an elegant solution for enterprise computing or for Big Data processing.

A new approach to running and managing distributed systems, PintoStack gives you immutable container infrastructure, with service discovery and continuous logging. Simply put, PintoStack is an easy, reliable and complete solution to get your cloud up and running.

## Setup juju environment

Edit ```~/.juju/environments.yaml``` 

Than do

```
$ juju bootstrap
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

