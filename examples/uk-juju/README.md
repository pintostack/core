# Overview

PintoStack from DataArt is an open source Docker container system. It is very easy to set-up and to run and it offers an elegant solution for enterprise computing or for Big Data processing.

A new approach to running and managing distributed systems, PintoStack gives you immutable container infrastructure, with service discovery and continuous logging. Simply put, PintoStack is an easy, reliable and complete solution to get your cloud up and running.

This tutorial is based on processing big data from ```http://data.dft.gov.uk``` and extracting valueable infromation from huge amount of publicly available data.

You can download this archive to your local machine and see the file we working with ```Accidents7904.csv```:

```
http://data.dft.gov.uk/road-accidents-safety-data/Stats19-Data1979-2004.zip
```

## Install JuJu

### Install JuJu on Ubuntu

```bash
sudo apt-get install python-software-properties pip
sudo add-apt-repository ppa:juju/stable
sudo apt-get update
sudo apt-get install juju-quickstart juju-core
sudo pip install charm-tools
```

### Install JuJu on Apple OSX

>IMPORTANT: Before all you need ```Latest Python 3 Release``` installer from [here](https://www.python.org/downloads/mac-osx/) or run ```brew install python3```. In both cases do not forget to close terminal and open a new one after install, to have new settings applied.

To install Juju on OS X without Juju quickstart, follow [the manual install instructions](https://jujucharms.com/docs/getting-started#mac-osx). 

Then run this:

```bash
sudo pip install charm-tools
```

### Install JuJu on Windows

To install Juju on Windows without Juju quickstart, follow [the manual install instructions](https://jujucharms.com/docs/getting-started#windows). 

>IMPORTANT: You need to install Python 3 and run the commabd below in bash shell.

```bash
sudo pip install charm-tools
```

## Configuring EC2 for your cluster

### Region

Before starting the deployment process you might select a region where it would reside we sugest you to use default one from ```config.yaml.tmpl``` file ```AWS_REGION='us-west-2'```. But EC2 allows you to select from number of available regions.
Configuration would require from you the name of region you selected, lilke, us-west-1, or eu-east-2 put in ```source.aws``` file like ```AWS_REGION='us-west-2'```

> IMPORTANT: Remember that AWS_AMI and AWS_SECURITY_GROUPS are region specific.

### SSH Keys or so called in AWS Console ```[Network & Security] > [Key Pairs]```

The keys are used to replace password based authentication. EC2 requires you to setup a keypair in management console. If you do not have keypair, it's easy to create new one open ```[AWS Console] > [EC2]``` then in left pane ```[Network & Security] > [Key Pairs]``` in case there are existing key pairs in your AWS account you can use it as well. We sugest you to name a new key pair ```PintoStack```. And save the key file in save place and put the path to you key file in ```source.aws``` for example it looks like this ```SSH_KEY_FILE='~/Downloads/PintoStack.pem.txt'``` and ```AWS_KEYPAIR_NAME='PintoStack'```.

> IMPORTANT: Please note that keypairs are also region specific and to read more please follow the [this link](http://docs.aws.amazon.com/opsworks/latest/userguide/security-ssh-access.html).

> NOTICE: For more information on AWS Security Groups look [here](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_SecurityGroups.html).


### API Access key and secret

> INFO: If you already have working ```AWS Access Key ID``` and ```AWS Secret Access Key``` you can use it, but make sure it is valid for the ```AWS Region```, and skip this paragraph.

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


### AMI and user name (can skip this if using defaults)

AMI name is the name of image that is used as a source for your virtual instances. So if you chose a different region than we sugested in default ```source.aws``` like ```AWS_REGION='us-west-2'``` you need to change default ```AWS_AMI='ami-5189a661'```. To do so, open this [link](https://cloud-images.ubuntu.com/locator/ec2/) and type for example if you would like to find out the AMI-ID for the latest release of “LTS” Ubuntu to run on a “64″ bit “ebs” instance in the “us-east” region, you would search for ```lts 64 us-east ebs```.

>NOTICE: You can try other options like [archlinux](https://www.uplinklabs.net/projects/arch-linux-on-ec2/), or even [BSD](http://www.daemonology.net/freebsd-on-ec2/) but it was not tested.

## Provisioning your cluster with JUJU

### JuJu environment configuration

Edit ```~/.juju/environments.yaml``` put your ```AWS_KEY_ID``` and ```AWS_KEY``` to ```amazon``` subsection. Below is the example of what you need.

```yaml
default: amazon
environments:
   amazon:
        type: ec2
        # region specifies the EC2 region. It defaults to us-east-1.
        #
        region: us-west-2
        admin-secret: 'nothingButPintostack'
        # access-key holds the EC2 access key. It defaults to the
        # environment variable AWS_ACCESS_KEY_ID.
        #
        access-key: AKIAI5KB5GZEXAMPLE

        # secret-key holds the EC2 secret key. It defaults to the
        # environment variable AWS_SECRET_ACCESS_KEY.
        #
        secret-key: 9MkZ+FvxOSrk2I2SE56zEXAMPLEwW8N8uz

        # image-stream chooses a simplestreams stream from which to select
        # OS images, for example daily or released images (or any other stream
        # available on simplestreams).
        #
        image-stream: "released"
```

Than open terminal window, go to ```examples/uk-juju``` and edit ```config.yaml.tmpl``` and save it to ```config.yaml```. After editing it sould look like this example below:

> REMEMBER: This file below is YAML formated so it is very important to preserv line spaces and leading TABs, you can check your syntax [online](http://www.yamllint.com/).

```yaml
---
pintostack:
    resource-provider-config: |
        AWS_KEY_ID='AKIAI5KB5GZEXAMPLE'
        AWS_ACCESS_KEY='9MkZ+FvxOSrk2I2SE56zEXAMPLEwW8N8uz'
        AWS_KEYPAIR_NAME=PintoStack
        AWS_ROOT_PARTITION_SIZE=20
        AWS_AMI=ami-5189a661
        AWS_INSTANCE_TYPE=t2.medium
        AWS_REGION=us-west-2
        AWS_SECURITY_GROUPS='juju-amazon,juju-amazon-0'
        AWS_SSH_USERNAME=ubuntu
        AWS_TERMINATE_ON_SHUTDOWN=true
    slaves-number: 6
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

### Before begining:

* Make sure you use same ```AWS_REGION``` as in ```~/.juju/environments.yaml```.
* Make sure ```AWS_SECURITY_GROUPS``` contains ```juju-amazon```, ```juju-amazon-0```
* Make sure ```AWS_AMI``` you using is available in this ```AWS_REGION```, if you are not sure use defaults.

### Deploying with JUJU

Open terminal window, go to ```examples/uk-juju``` subfolder and run:

```
$ deploy_uk_demo.sh
```

This will return you an IP of Juju-GUI you can open it with browser. Remember to accept SSL Exception. Login with user: ```admin``` password: ```nothingButPintostack```. And than you can watch while build all charms and deploys all cluster components.

Juju GUI Login

![](images/01-login-juju-gui.jpg)

Juju GUI

![](images/02-juju-gui.jpg)

After all pending items will disapeare go back to the same terminal window.

>INFO: Monitor the status of ```pintostack/0``` unit ```$ juju stat```. To get access to pintostack context use ```$ juju ssh pintostack/0```

### Starting using PintoStack

After all pending items will disapeare in juju-gui go back to the same terminal window and run:
```
./open_webui.sh
```
It will give you the similar reply
```
You are running inside docker could not open browser.
Mesos: http://some-host-1.us-west-2.compute.amazonaws.com:5050
Marathon: http://some-host-1.us-west-2.compute.amazonaws.com:8080
Consul: http://some-host-1.us-west-2.compute.amazonaws.com:8500
Connection to closed.
```
Copy the Consul URL ```http://some-host-1.us-west-2.compute.amazonaws.com:8500``` and open it in your browser.

Consul UI

![](images/03-consul-gui.jpg)

Here you can navigate information about all nodes and services.

* Find the service named ```ipythonnb``` click it and see the node it is running on (```slave-N```). 
* Navigate to node information and find ```WAN Adderess``` below you will see public adress (like this ```ec2-some-slave-host.us-west-2.compute.amazonaws.com```) copy it.
* Open your browser with copied URL with port 31080 (like this ```http://ec2-some-slave-host.us-west-2.compute.amazonaws.com:31080```)

Now you will get a standart iPython NoteBook interface.

### Running Python NoteBook 

Open Marathon URL from previews paragraph (```http://some-host-1.us-west-2.compute.amazonaws.com:8080```) and make sure all applications are in state ```Running``` and there is no application ```/pintostack/upload-uk-data-to-hdfs``` or wait while it finishes.

>INFO: Juju Web UI do nto work well in Safari, so please use ```Mozzila``` based browser under OSX.

![](images/04-ipython-notebook.jpg)

Than go back to the  iPython NoteBook interface we opened in previews paragrath
* Create a notebook
* Put the code below to the cell
* Press ```Run Cell```


```python
import time

start_time = int(round(time.time() * 1000))

import DNS

hdfs_serevice="hdfs-rpc.service.consul"

DNS.ParseResolvConf()
srv_req = DNS.Request(qtype = 'SRV')
srv_result = srv_req.req(hdfs_serevice)
hdfs_port=srv_result.answers[0]['data'][2]

# now we have a file
text_file = sc.textFile("hdfs://"+str(hdfs_serevice)+":"+str(hdfs_port)+"/Accidents7904.csv")

# getting the header as an array
header = text_file.first().split(",")

# getting data
data = text_file \
   .map(lambda line: line.split(",")) \
   .filter(lambda w: w[header.index('Date')] != 'Date')
output = data.filter(lambda row: len(row[header.index('Date')].strip().split("/")) == 3) \
   .map(lambda row: row[header.index('Date')].strip().split("/")[2]) \
   .map(lambda word: (word, 1)) \
   .reduceByKey(lambda a, b: a + b) \
   .sortByKey(True) \
   .collect()
for (line, count) in output:
        print("%s: %i" % (line, count))
print ("Duration is '%i' ms" % (int(round(time.time() * 1000)) - start_time))

%matplotlib inline

import matplotlib
import numpy as np
import matplotlib.pyplot as plt

plt.plot([str(x[0]) for x in output], [str(x[1]) for x in output])
```
> IMPORTANT: You can monitor the execution of tasks in Mesos UI ```Frameworks > pyspark-shell >
Active Tasks```


![](images/05-mesos-pyspark-tasks.jpg)

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

