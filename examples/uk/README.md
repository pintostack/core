### RUNNING DATA ANALYTICS BASED ON STATISTICS OF ACCIDENTS IN UK

Please note that ports might be different.

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