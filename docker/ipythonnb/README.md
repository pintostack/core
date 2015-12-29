# Example run
```python
import os

spark_home = os.environ.get('SPARK_HOME', None)
text_file = sc.textFile(spark_home + "/README.md")
word_counts = text_file \
    .flatMap(lambda line: line.split()) \
    .map(lambda word: (word, 1)) \
    .reduceByKey(lambda a, b: a + b) 
word_counts.sortBy( lambda (a, b): b , False) \
    .collect()
```
# Example with hadoop
```python
import os

text_file = sc.textFile("hdfs://hdfs.service.consul:<port_here>/README.txt")
word_counts = text_file \
    .flatMap(lambda line: line.split()) \
    .map(lambda word: (word, 1)) \
    .reduceByKey(lambda a, b: a + b)
word_counts.collect()
```
