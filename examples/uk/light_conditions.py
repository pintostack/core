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