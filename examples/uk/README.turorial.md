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
```
vagrant ssh master-1

TODO: COMMANDS TO UPLOAD DATA
```

# HOW TO OPEN IPYTHON AND START WORKING
TODO

# Description of examples
TODO

Please refer to https://data.gov.uk/dataset/road-accidents-safety-data and get the biggest archive with information about accidents from 1979 to 2004 years.
Here is the link http://data.dft.gov.uk/road-accidents-safety-data/Stats19-Data1979-2004.zip, please Download it, extract and find Accidents7904.csv 

Deploy HDFS and IPython to run examples.

Extract file:```Accidents7904.csv``` and save it to hdfs.
```bash
 hadoop fs -put Accidents7904.csv hdfs://slave-1.node.consul:31851/
```

When this is done you please find examples in examples/uk directory and change their code to use correct path to the csv file.

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