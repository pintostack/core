# Big Data with PintoStack.
##  Case # 1: Traffic accidents in the UK, 1979-2004.
PintoStack from DataArt is an open source Docker container system. It is very easy to set-up and to run and it offers an elegant solution for Big Data processing. 

Whether you are a journalist or a researcher interested in open data and you are overwhelmed by laborious tasks of setting-up an infrastructure, configuring an environment, learning new unfamiliar tools and coding complicated apps - with PintoStack you can start crunching those numbers within minutes.

PintoStack setups a cluster and deploys already configured components. You don’t need to understand what exactly is happening “under the hood” - just follow the steps in this tutorial.  

Once complete, you will have a running cluster with iPython Notebook, Apache Spark and Hadoop file system (HDFS), ready to tackle any large-scale data processing.

In this first case study we will look into detailed road safety data from Great Britain, 1979-2004.
 
Prerequisites:
- Some familiarity with command line interface.
- [Digital Ocean account](https://cloud.digitalocean.com/login). You can read this [tutorial](https://www.digitalocean.com/community/tutorials/how-to-create-your-first-digitalocean-droplet-virtual-server) to find out more about virtual servers.
- Follow these [instructions](../../README.md) to set-up PintoStack.

###Step # 1 - Build and deploy HDFS and iPython notebook.

Start a Bash session in your container:

```$ docker exec -it pintostack-container bash```

Now deploy HDFS NameNode for you meta data:

```# cd /pintostack```

```# ./marathon-push.sh hdfs-nn.json```

Deploy iPython notebook:

```# ./marathon-push.sh ipythonnb.json```

Deploy HDFS DataNode for your actual data:

```# ./marathon-push.sh hdfs-dn.json```

###Step # 2 - Upload data.

Find out your servers’ IPs from your [Digital Ocean droplets page](https://cloud.digitalocean.com/droplets).

Open up Marathon UI on http://MASTER_IP:8080/ and note where your HDFS NameNode lives.

Connect via SSH to the server with your HDFS NameNode (replace ‘N’ with your server number):

```# vagrant ssh slave-N```

Find out which Docker container is home your HDFS NameNode:

```# docker ps```

Start a Bash session in this container (replace ‘CONTAINER_ID’):

```# docker exec -it CONTAINER_ID bash```

Update its contents and install zip:

```# apt-get update && apt-get install -y wget unzip```

Download data:

```# wget http://data.dft.gov.uk/road-accidents-safety-data/Stats19-Data1979-2004.zip```

Unzip it:

```# unzip Stats19-Data1979-2004.zip```

You need find namenode port in ANSWER SECTION executing dig

```# dig SRV hdfs-rpc.service.consul | grep -A1 ";; ANSWER SECTION:" ```          

Returns

```
;; ANSWER SECTION:
hdfs-rpc.service.consul. 0	IN	SRV	1 1 31245 slave-1.node.dc1.consul.
```

So in our example port is ```31245```

Now place your table with accidents data into your cloud HDFS (replace ‘YOUR_PORT’ with one of the NameNode ports for your server):
```# bin/hadoop fs -put Accidents7904.csv hdfs://hdfs-rpc.service.consul:YOUR_PORT/```

###Step # 3 - iPython and data processing.

Open up iPython Notebook on http://SLAVE_IP_WITH_IPYTHON:PORT/ (remember, those are on your Digital Ocean account and Marathon UI).

Congratulations, you are now all set, and should be back on familiar soil!

Let’s find out how many accidents were reported to the police each year.
Your output should be along these lines:

1979: 254967

1980: 250958

1981: 248276

… 

```python
import time

start_time = int(round(time.time() * 1000))

# now we have a file
text_file = sc.textFile("hdfs://hdfs-rpc.service.consul:31229/Accidents7904.csv")

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

Remember to shut-down the previous iPython notebook before starting a new one.
Now let’s look whether there is a trend in the number of accidents in areas with speed limits 50 and 70.
Your output will be like this:

(1979, 50) : 500 

(1979, 70) : 400 

(1980, 50) : 600 

(1980, 70) : 800

… 


```python
import time

start_time = int(round(time.time() * 1000))

# now we have a file
text_file = sc.textFile("hdfs://hdfs-rpc.service.consul:31229/Accidents7904.csv")

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

As a final example, let’s look into the correlation between the number of accidents and light conditions and area type (Urban or Rural). 
You should get an output like this:

(Daylight, 1979, Rural) : 300 

(Daylight, 1980, Rural) : 400

… 

```python
import time

locations = ["Urban", "Rural", "Unallocated"]

light = ["Daylight", "", "", "Darkness - lights lit", "Darkness - lights unlit", "Darkness - no lighting", "Darkness - lighting unknown"]
start_time = int(round(time.time() * 1000))

# now we have a file
text_file = sc.textFile("hdfs://hdfs-rpc.service.consul:31229/Accidents7904.csv")

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

Thank you for using PintoStack! 
