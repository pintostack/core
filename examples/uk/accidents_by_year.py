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