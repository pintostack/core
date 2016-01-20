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