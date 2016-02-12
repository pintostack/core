FROM pintostack/pintostack-mesos

RUN mkdir -p /usr/share/scala/scala-2.11.5
ADD http://www.scala-lang.org/files/archive/scala-2.11.5.tgz /tmp/scala-2.11.5.tgz
RUN tar xzf /tmp/scala-2.11.5.tgz -C /usr/share/scala/scala-2.11.5 --strip=1 && rm -f /tmp/scala-2.11.5.tgz
RUN ln -sf /usr/share/scala/scala-2.11.5/bin/scala /usr/bin
RUN ln -sf /usr/share/scala/scala-2.11.5/bin/scalac /usr/bin
RUN ln -sf /usr/share/scala/scala-2.11.5/bin/fsc /usr/bin
RUN ln -sf /usr/share/scala/scala-2.11.5/bin/sbaz /usr/bin
RUN ln -sf /usr/share/scala/scala-2.11.5/bin/sbaz-setup /usr/bin
RUN ln -sf /usr/share/scala/scala-2.11.5/bin/scaladoc /usr/bin
RUN ln -sf /usr/share/scala/scala-2.11.5/bin/scalap /usr/bin

RUN useradd -b /var/lib/ -m spark
RUN mkdir -p /etc/spark
RUN mkdir -p /var/log/spark && chown spark:spark /var/log/spark && chmod 0755 /var/log/spark
RUN mkdir -p /run/spark && chown spark:spark /run/spark && chmod 0755 /run/spark

ADD http://mirror.cogentco.com/pub/apache/spark/spark-1.5.2/spark-1.5.2-bin-hadoop2.6.tgz /usr/local/src/spark-1.5.2-bin-hadoop2.6.tgz
RUN mkdir -p /usr/lib/spark-1.5.2-bin-hadoop2.6
RUN tar xzf /usr/local/src/spark-1.5.2-bin-hadoop2.6.tgz -C /usr/lib/spark-1.5.2-bin-hadoop2.6 --strip=1 && rm -f /usr/local/src/spark-1.5.2-bin-hadoop2.6.tgz
RUN ln -sf /usr/lib/spark-1.5.2-bin-hadoop2.6 /usr/lib/spark
RUN ln -sf /usr/lib/spark/conf /etc/spark/conf
RUN ln -s /usr/lib/spark/spark-class /usr/bin/
RUN ln -s /usr/lib/spark/spark-shell /usr/bin/
RUN ln -s /usr/lib/spark/spark-sql /usr/bin/
RUN ln -s /usr/lib/spark/spark-submit /usr/bin/
RUN echo 'export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/lib/hadoop/lib/native' >> /etc/spark/conf/spark-env.sh
RUN echo 'export HADOOP_CONF_DIR=${HADOOP_CONF_DIR:-/etc/hadoop/conf}' >> /etc/spark/conf/spark-env.sh
RUN echo 'export SPARK_LOG_DIR=${SPARK_LOG_DIR:-/var/log/spark}' >> /etc/spark/conf/spark-env.sh
RUN echo 'export SPARK_PID_DIR=${SPARK_PID_DIR:-/run/spark}' >> /etc/spark/conf/spark-env.sh

RUN echo SPARK_HOME=/var/lib/spark >> /etc/environment
RUN echo SCALA_HOME=/usr/share/scala/scala-2.11.5 >> /etc/environment