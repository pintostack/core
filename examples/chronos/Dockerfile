FROM pintostack/pintostack-spark

RUN mkdir -p /mnt/mesos/sandbox
ADD https://s3-us-west-1.amazonaws.com/ygpublic/simple-project_2.10-1.0.jar /mnt/mesos/sandbox/simple-project_2.10-1.0.jar
ENV LIBPROCESS_IP "0.0.0.0"

ADD libproc.sh /tmp/libproc.sh
RUN cat /bin/spark-submit > /tmp/spark-submit-original
RUN cat /tmp/libproc.sh > /bin/spark-submit
RUN cat /tmp/spark-submit-original >> /bin/spark-submit