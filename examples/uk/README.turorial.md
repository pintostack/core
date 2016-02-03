# Data analytics

One of classical problems that require massive preparation and infrastructure setup is data analytics.
Typically you spend hours configuring your your environment, setup all services and tools before actually doing some analysis.
With PintoStack you need to setup the cluster, easily deploy already configured components.
As part of this tutorial we will process data set that contains historical information about all accidents in the UK from 1979 to 2004.

# Prerequisites

Please setup your cluster.

# Deploy hdfs, ipythonnb

Open CLI with
```
docker exec -it pintostack-container bash
```
Build and deploy components
```
cd /pintostack
./docker-push.sh hdfs && ./marathon-push.sh hdfs-nn.js 
./docker-push.sh ipythonnb && ./marathon-push.sh ipythonnb.json
./marathon-push.sh hdfs-dn.js
```

# Upload data

The best way is to install hdfs client and configure it to work with hdfs in your cluster.
The easiest is to use hdfs name node. 
Find the node where hdfs name node lives using Marathon UI.
ssh to it with this command:
 
```
vagrant ssh slave-n # n is number of slave
```
find the container where hdfs-nn lives and ssh to it
```
docker ps # find your hdfs node there
docker exec -it <sha> bash
apt-get update
apt-get install -y wget unzip
wget http://data.dft.gov.uk/road-accidents-safety-data/Stats19-Data1979-2004.zip
unzip Stats19-Data1979-2004.zip
hadoop fs -put Accidents7904.csv hdfs://slave-1.node.consul:31851/ # note the port please, it should be from your environment

Please find python scripts in examples/uk folder.

### accidents_by_year.py
This job produces a table with a number of accidents per year.
```
(1979) : 1000
(1980) : 1004
etc.
```
 
### areas_speed_limit.py
This job produces a table describing trend of number of accidents within speed limits 50 and 70.
The output looks similar to:

```
(1979, 50) : 500
(1979, 70) : 400
(1980, 50) : 600
(1980, 70) : 800
etc.
```

### light_conditions.py
This job produces a table describing correlation between light conditions, area type (Urban or Rural) and number of accendts.
The output looks limiar to:

```
(Daylight, 1979, Rural) : 300
(Daylight, 1980, Rural) : 400
```