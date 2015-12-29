FROM ubuntu:14.04

MAINTAINER Artyom Astafurov (artyom.astafurov@gmail.com)

# Set the env variable DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update

# Install dependeincies 
RUN sudo apt-get install -y openjdk-7-jre dnsutils jq curl && \
	rm -rf /var/lib/apt/lists/*

VOLUME ["/hadoop", "/conf"]

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV HADOOP_CONF_DIR /conf
ENV HADOOP_PID_DIR /tmp
ENV HADOOP_LOG_DIR /hadoop/log
ENV HADOOP_HEAPSIZE 1024
ENV HADOOP_COMMON /usr/local/hadoop
ENV HADOOP_PREFIX /usr/local/hadoop
ENV HADOOP_HDFS_HOME /usr/local/hadoop

ADD ./conf /conf/
RUN curl -s http://mirror.cogentco.com/pub/apache/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz | \
	tar -xzC /usr/local/ && \
	mv /usr/local/hadoop-2.6.0 /usr/local/hadoop
ADD ./bootstrap.sh /usr/local/hadoop/

WORKDIR /usr/local/hadoop

ENTRYPOINT /bin/bash

