# Overview

PintoStack from DataArt is an open source Docker container system. It is very easy to set-up and to run and it offers an elegant solution for enterprise computing or for Big Data processing.

A new approach to running and managing distributed systems, PintoStack gives you immutable container infrastructure, with service discovery and continuous logging. Simply put, PintoStack is an easy, reliable and complete solution to get your cloud up and running.

## Setup juju environment

Edit ```~/.juju/environments.yaml``` 

Than do

```
$ juju bootstrap
```

Go to folder conteining this charm


```
$ juju charm build pintostack
```


```
$ juju deploy --repository=$(pwd)/pintostack local:trusty/pintostack
```

Monitor the status of pintostack/0 unit

```
$ juju stat
```

To get access to pintostack use

```
juju ssh pintostack/0
```