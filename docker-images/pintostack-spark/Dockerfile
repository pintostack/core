FROM pintostack/pintostack-mesos-slave

RUN cp -R /usr/lib/spark/bin/* /bin/
RUN cp -R /usr/lib/spark/sbin/* /sbin/
RUN cp -R /usr/lib/spark/conf /conf
RUN cp -R /usr/lib/spark/data /data
RUN cp -R /usr/lib/spark/ec2 /ec2
RUN cp -R /usr/lib/spark/lib/* /lib/
RUN cp -R /usr/lib/spark/python /python
RUN cp -R /usr/lib/spark/RELEASE /RELEASE

ENV SPARK_HOME /
ENV SCALA_HOME /usr/share/scala/scala-2.11.5
WORKDIR /
