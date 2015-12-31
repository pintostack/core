# Crunching UK Public Data in Apache Spark and IPython

## About
Querying raw data requires resources and we could benifit from querying data in parallel using Map Reduce running in Apache Spark. At the same time we don't want to spend time setting up the infrasturcture from ground up. Thanks to PintStack you can setup the infrastructure for parallel computing and distributed storage in just a few commands and get into the most exciting part — querying the data.

Completing this tutorial you will get you:
- IPython Notebook capable of running Spark jobs
- HDFS storage so our workers have access to the same data
- Provisioned machines for parallel execution of Spark jobs

This document contains an easy to use solution for Data Scientists, Data Analysts and those curious in data processing to get a disposable environment on-demand. 

> NOTE: This tutorial was verified on PC running Ubuntu 14.0.4 LTS and Mac running OSX 10.9 with Digital Ocean account.

## Prerequisites 
* Linux, FreeBSD, OSX, or other unix-like OS (Ubuntu 14.04 LTS or OSX 10.9+ recommended)
* Python 2.7
* Digital Ocean account and API key
* Ansible 2.0. At the time of writing of this document, Ansible 2.0 was still in beta. Latest version can be installed directly from master branch: ```pip install git+https://github.com/ansible/ansible.git```). 
* Following dependencies to run Ansible tasks:
```bash
apt-get install -y python-pip # You can skip this on your mac
pip install pyopenssl ndg-httpsclient pyasn1
pip install mock --upgrade
pip install six --upgrade
pip install dopy --upgrade
```
> NOTE: Depending on system configuration it might be required to run installation commands as super user. 

## Configuring Digital Ocean Account

### API Key
It's time to open digital ocean management [portal](https://cloud.digitalocean.com/settings/applications). On this page you'll need to create new API key, which will be used later. Simpy copy it into a safe place, we'll use it later.

### SSH Keys
For machines we are going to create we'll need SSH keys. In order to create a new ssh key pair follow [GitHub instructions](https://help.github.com/articles/generating-ssh-keys/). Now you should upload content of your public key file (usualy ~/.ssh/id_rsa.pub) with key name ```soft-cluster-key``` to the [digital ocean web site](https://cloud.digitalocean.com/settings/security).

> NOTE: Veify that you now have API key and SSH keys provisioned into Digital Ocean.

## Deployment
### Getting PintoStack
Getting the snapshot from repository with command line GIT:
```
    $ git clone https://github.com/pintostack/core.git
    $ cd core
```

### Configure VPC details

Edit file ```infrastructure/do.source```:
* ```SSH_KEY_ID=<NUMERIC KEY ID>``` , to get your key id you'll need API token. Run ```./infrastructure/digital_ocean.py --ssh-keys -p -a <ONE LINE API TOKEN> | grep -B1 soft-cluster-key```, searching your key id in a list ``` "id" : 1234567 ```. This numeric key id identifies ssh key that will be using later to login to the droplets.
* ```SSH_KEY_FILE=<FULL PATH TO SSH PRIVATE KEY FILE>``` (ususaly ~/.ssh/id_rsa), containing private key corresponding to the public key uploaded to digital ocean web site.
* ```SIZE=<DROPLET MEMORY SIZE>``` (8gb recomended, but do not use less than 4gb for this tutorial). Available options are listed [here](https://www.digitalocean.com/pricing/)
* ```LOCATION=<PREFERED DATACENTER FOR YOUR DROPLETS>```, (default is ams3 in Amsterdam). Available options are listed [here](https://www.digitalocean.com/features/reliability/) You can also get them by running ```./infrastructure/digital_ocean.py --regions -p -a <API_TOKEN>```.
* ```IMAGE_NAME=<INSTALLATION IMAGE FOR DROPLET>``` Default is ubuntu-14-04-x64. Do not change this until you know what you are doing. 

Here is an example of ```infrastructure/do.source```:
```
# Digital Ocean Account Parametrs
# SSH_KEY_ID=<NUMERIC KEY ID>
SSH_KEY_ID=1234567
# SSH_KEY_FILE=<FULL PATH TO SSH PRIVATE KEY FILE ususaly ~/.ssh/id_rsa>
SSH_KEY_FILE=~/.ssh/id_rsa
# SIZE=<DROPLET MEMORY SIZE do not use less than 4gb for this tutorial>
SIZE=8gb
# LOCATION=<PREFERED DATACENTER FOR YOUR DROPLETS ams3 in EU or nyc3 in US>
LOCATION=ams3
# Do not change this until you know what you are doing
IMAGE_NAME=ubuntu-14-04-x64
```

### Provisioning

Open terminal window and define environment variables for your session:
```
$ export DO_API_TOKEN=<ONE LINE API TOKEN>
```
Now it's time to run provisioning for your droplets:
```
$ cd <SOFTWARE ROOT DIRECTORY>
```
and
```
$ ./provision.sh --target=do --master=1 --slave=11
```

> NOTE: This may take a several minutes but after command completes you should be able to find 13 new droplets in your digital ocean web site [console](https://cloud.digitalocean.com/droplets): 3 masters, 11 slaves, and 1 docker-registry. Also you can try to ssh to one of those new droplets by copying ip addres and running ```ssh -i <PATH TO PRIVATE KEY  usualy /$HOME/.ssh/id_dsa> root@<DROPLET_IP>```

### Bootstraping

From PintoStack home run:
```
$ ./bootstrap-masters.sh && ./bootstrap-slaves.sh && ./bootstrap-docker-registry.sh
```
> NOTE: After successful bootstrap you can find an ip address of master-1 host in your [Digital Ocean web console](https://cloud.digitalocean.com/droplets) and open in browser ```http://<MASTER-1_IP>:5050``` and ```http://<MASTER-1_IP>:8080``` to see the cluster managment interfaces. Now you can proceed installing bundled application on this platform.

### Running IPython Notebook with Spark and HDFS

#### Building Docker Containers
In the docker/ directory you can find various Docker containers wrapping some of the common services. Build and push IPython and HDFS into the registry
```
$ ./docker-push.sh ipythonnb && ./docker-push.sh hdfs
```  

#### Running Containers
To run these containers you'll need to submit JSON job description into Marathon (running on ```http://<master-1_ip>:5050```):
```
$ ./marathon-push.sh ipythonnb.json && ./marathon-push.sh hdfs-nn.json
```
Now wait for HDFS/namenode to get from ```Deploying``` to ```Running``` status in Marathon UI (running on ```http://<master-1_ip>:5050```).
```
$ ./marathon-push.sh hdfs-dn.json
```
Now wait for HDFS/datanode to get from ```Deploing``` to ```Running``` status in Marathon UI (running on ```http://<master-1_ip>:5050```). You can create more HDFS datanodes directly in marathon UI. For this tutorial you should create at least one HDFS datanode.

> NOTE: You can open IPython Notebook web UI by finding ipythonnb on applications tab of marathon web UI ```http://<master-1_ip>:5050``` and geting node name it is running on (usualy slave-1). Now search this node IP in your [Digital Ocean web console](https://cloud.digitalocean.com/droplets), and open in browser ```http://<slave-X-ip>:31080```.

## Doing a Quick Check
First make sure IPython is running by looking up ```ipythonnb``` on applications tab of Marathon UI ```http://<master-1_ip>:5050```

### Uploading data to HDFS
```bash
 hadoop fs -put README.txt hdfs://slave-1.node.consul:31851/
```

### Our First Spark Job
```python
text_file = sc.textFile("hdfs://hdfs.service.consul:31851/README.txt")
word_counts = text_file \
    .flatMap(lambda line: line.split()) \
    .map(lambda word: (word, 1)) \
    .reduceByKey(lambda a, b: a + b)
word_counts.collect()
```

## Crunching UK Car Accidents Data
Please refer to https://data.gov.uk/dataset/road-accidents-safety-data and get the biggest archive with information about accidents from 1979 to 2004 years. Extract file:```Accidents7904.csv``` and save it to hdfs.

### Getting number of accidents by year
```python
import time
start_time = int(round(time.time() * 1000))
# now we have a file
text_file = sc.textFile("hdfs://hdfs.service.consul:31229/Accidents7904.csv")
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
```

### Getting number of accidents within areas with 70 and 50 mph limit
```python
import time
start_time = int(round(time.time() * 1000))
# now we have a file
text_file = sc.textFile("hdfs://hdfs.service.consul:31229/Accidents7904.csv")
# getting the header as an array
header = text_file.first().split(",")
# getting data
data = text_file \
   .map(lambda line: line.split(",")) \
   .filter(lambda w: w[header.index('Date')] != 'Date')
output = data.filter(lambda row: len(row[header.index('Date')].strip().split("/")) == 3) \
   .map(lambda row: (row[header.index('Speed_limit')].strip(), row[header.index('Date')].strip().split("/")[2])) \
   .filter(lambda sl: sl[0] == '50' or sl[0] == '70') \
   .map(lambda x: (x , 1)) \
   .reduceByKey(lambda a, b: a + b) \
   .sortByKey(True) \
   .collect()
for (line, count) in output:
        print("%s: %i" % (line, count))
print ("Duration is '%i' ms" % (int(round(time.time() * 1000)) - start_time))
```

### Getting number of accidents based on light conditions and area (urban or rural)
```python
import time
locations = ["Urban", "Rural", "Unallocated"]
light = ["Daylight", "", "", "Darkness - lights lit", "Darkness - lights unlit", "Darkness - no lighting", "Darkness - lighting unknown"]
start_time = int(round(time.time() * 1000))
# now we have a file
text_file = sc.textFile("hdfs://hdfs.service.consul:31229/Accidents7904.csv")
# getting the header as an array
header = text_file.first().split(",")
# getting data
data = text_file \
   .map(lambda line: line.split(",")) \
   .filter(lambda w: w[header.index('Date')] != 'Date')
def my_map(row):
    t = row[header.index("Time")].strip()
    dtI = int(t.split(":")[0])
    if dtI > 7 and dtI < 20:
      _dt = "day"
    else:
      _dt = "night"
    _lCond = light[int(row[header.index("Light_Conditions")].strip()) - 1]
    _u = locations[abs(int(row[header.index("Urban_or_Rural_Area")].strip())) - 1]
    return (_dt, _lCond, _u)
output = data.filter(lambda row: len(row[header.index('Date')].strip().split("/")) == 3)
output = output.filter(lambda row: len(row[header.index('Time')]) > 0 and row[header.index('Time')] != "NULL" and int(row[header.index('Urban_or_Rural_Area')]) < 3 and int(row[header.index('Light_Conditions')]) > 0)
output = output.map(lambda x: (my_map(x), 1))
output = output.reduceByKey(lambda a, b: a + b)
output = output.sortByKey(True)
output = output.collect()
for (line, count) in output:
        print("Key '%s': '%i'" % (line, count))
print ("Duration is '%i' ms" % (int(round(time.time() * 1000)) - start_time))
```
