FROM ubuntu:14.04

MAINTAINER Yuri Vlasov (yu.vlasov@gmail.com)

# Set the env variable DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update

# Install ubuntu packages.
RUN \
  sudo apt-get install -y openjdk-7-jdk git npm wget curl jq && \
	sudo apt-get install -y autoconf libtool && \
	sudo apt-get install -y build-essential python-dev python-boto libcurl4-nss-dev libsasl2-dev \
	libapr1-dev libsvn-dev ipython-notebook \
	ipython-notebook-common python-pip \
	python-mathgl python-igraph python-matplotlib python-mpmath \
	python-plplot python-pychart python-sciscipy  python-scipy python-scitools


# Install Mesos
RUN echo "deb http://repos.mesosphere.io/ubuntu trusty main" | sudo tee /etc/apt/sources.list.d/mesosphere.list
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
RUN apt-get update && \
    apt-get install -y --fix-missing --force-yes mesos && \
    echo manual > /etc/init/mesos-slave.override && \
    echo manual > /etc/init/mesos-master.override
#	rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

WORKDIR /root

# Scala
RUN curl -SL http://downloads.typesafe.com/scala/2.11.7/scala-2.11.7.tgz \
	| tar -xzC /root
ENV SCALA_HOME /root/scala-2.11.7
ENV PATH $PATH:$SCALA_HOME/bin

# Scala sbt
RUN curl -SL https://dl.bintray.com/sbt/native-packages/sbt/0.13.9/sbt-0.13.9.tgz \
	| tar -xzC /root
ENV PATH $PATH:/root/sbt-0.13.9/bin

# Spark 1.5.2
RUN curl -SL http://mirror.cogentco.com/pub/apache/spark/spark-1.5.2/spark-1.5.2-bin-hadoop2.6.tgz \
	| tar -xzC /usr/lib && \
	ln -s /usr/lib/spark-1.5.2-bin-hadoop2.6 /usr/lib/spark
ENV SPARK_HOME /usr/lib/spark

VOLUME ["/data"]
VOLUME ["/log"]

#Create Worck directory for iPython
RUN mkdir -p /root/ipithon ; \
	mkdir -p /root/.ipython/profile_pyspark/startup/

WORKDIR  /root/

COPY ./bootstrap.sh /root/bootstrap.sh

#ENTRYPOINT ./bootstrap.sh
