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
