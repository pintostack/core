FROM pintostack/pintostack-base

RUN echo "deb http://repos.mesosphere.io/ubuntu/ trusty main" > /etc/apt/sources.list.d/mesosphere.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF

# Fixed version 0.27.0-0.2.190.ubuntu1404, the latest as of Feb 9 2016.
RUN apt-get update && apt-get install -y mesos=0.27.0-0.2.190.ubuntu1404

##
# This image is not supposed to be started as a container
# docker build -t pintostack/pintostack-base .
##