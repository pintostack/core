FROM ubuntu:14.04

MAINTAINER Artyom Astafurov (artyom.astafurov@gmail.com)

# Set the env variable DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND noninteractive


# Buiding mesos locally for now
# From: https://open.mesosphere.com/getting-started/datacenter/install/
# Setup
# RUN apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
# Add the repository 
# RUN export DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]') && \
#	export CODENAME=$(lsb_release -cs) && \
#	echo "deb http://repos.mesosphere.com/${DISTRO} ${CODENAME} main" | tee /etc/apt/sources.list.d/mesosphere.list

RUN apt-get -y update

# Install ubuntu packages.
RUN \
  sudo apt-get install -y openjdk-7-jdk git npm wget curl jq && \
	sudo apt-get install -y autoconf libtool && \
	sudo apt-get install -y build-essential python-dev python-boto libcurl4-nss-dev libsasl2-dev libapr1-dev libsvn-dev && \
	rm -rf /var/lib/apt/lists/*
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

# Maven 3.3.3 (Required by zeppelin build script)
RUN curl -SL http://apache.mirrors.tds.net/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz \
	| tar -xzC /root
ENV PATH $PATH:/root/apache-maven-3.3.3/bin

# Spark 1.4.1
RUN curl -SL http://d3kbcqa49mib13.cloudfront.net/spark-1.4.1-bin-hadoop2.6.tgz \
	| tar -xzC /root
ENV SPARK_HOME /root/spark-1.4.1-bin-hadoop2.6

# Build Zeppelin
# RUN git clone https://github.com/apache/incubator-zeppelin.git /root/incubator-zeppelin && \
#	cd /root/incubator-zeppelin && \
#	mvn clean package -Pspark-1.4 -Dspark.version=1.4.1 -Dhadoop.version=2.6.0 -Phadoop-2.6 -P build-distr -DskipTests && \
#	mv zeppelin-distribution/target/zeppelin-0.6.0-incubating-SNAPSHOT.tar.gz /root && \
#	cd /root && \
#	tar -xvzf zeppelin-0.6.0-incubating-SNAPSHOT.tar.gz && \
#	rm zeppelin-0.6.0-incubating-SNAPSHOT.tar.gz
# RUN rm -rf /root/incubator-zeppelin

# use pre-built Zeppelin
RUN curl -SL d1e4cwyo3j98xy.cloudfront.net/zeppelin-0.6.0-incubating-SNAPSHOT.tar.gz \
	| tar -xzC /root

# Clone and build Mesos (Possibly create a separate mesos image?)
# RUN git clone https://github.com/apache/mesos.git /root/mesos && \
#	cd /root/mesos && \
#	./bootstrap && \
#	mkdir build && \
#	cd build && \
#	../configure && \
#	make -j 4 V=0
# RUN cp /root/mesos/build/src/.libs/libmesos-0.25.0.so /usr/lib && \
#	cp /root/mesos/build/src/.libs/libfixed_resource_estimator-0.25.0.so /usr/lib && \
#	cp /root/mesos/build/src/libfixed_resource_estimator.la  /usr/lib && \
#	cp /root/mesos/build/src/libmesos.la /usr/lib

# Temporarily use pre-built libmesos instead of building it from scratch
RUN curl -SL d1e4cwyo3j98xy.cloudfront.net/libmesos-0.25.0.tgz \
	| tar -xzC /root
	
RUN cp /root/libmesos-0.25.0/* /usr/lib && \
	rm -rf /root/libmesos-0.25.0

# Create symlinks for libmesos
RUN	ln -s /usr/lib/libmesos-0.25.0.so /usr/lib/libmesos.so && \
	ln -s /usr/lib/libfixed_resource_estimator-0.25.0.so /usr/lib/libfixed_resource_estimator.so && \
	ln -s /usr/lib/libmesos-0.25.0.so /usr/local/lib/libmesos-0.25.0.so && \
	ln -s /usr/lib/libmesos.so /usr/local/lib/libmesos.so && \
	ln -s /usr/lib/libfixed_resource_estimator-0.25.0.so /usr/local/lib/libfixed_resource_estimator-0.25.0.so && \
	ln -s /usr/lib/libfixed_resource_estimator.so /usr/local/lib/libfixed_resource_estimator.so

VOLUME ["/data"]
VOLUME ["/log"]

WORKDIR /root/zeppelin-0.6.0-incubating-SNAPSHOT

COPY ./conf/zeppelin-env.sh /root/zeppelin-0.6.0-incubating-SNAPSHOT/conf/
COPY ./bootstrap.sh /root/zeppelin-0.6.0-incubating-SNAPSHOT/
#ENTRYPOINT ./bootstrap.sh
