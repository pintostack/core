FROM ubuntu:14.04

# Install dependencies and tools
RUN apt-get update && apt-get install -y wget telnet curl vim git zip unzip software-properties-common python-dev python-pip

# Install java 8
RUN add-apt-repository ppa:webupd8team/java && apt-get update
RUN (echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections) && apt-get install -y oracle-java8-installer oracle-java8-set-default
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH $JAVA_HOME/bin:$PATH

##
# This image is not supposed to be started as a container
# docker build -t pintostack/pintostack-base .
##