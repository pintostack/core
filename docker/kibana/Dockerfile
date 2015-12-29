FROM ubuntu:14.04

MAINTAINER Sergii Suchkov (srg.suchkov@gmail.com)

RUN apt-get update && \
    apt-get install -y \
    curl \
    jq

RUN curl -s https://download.elastic.co/kibana/kibana/kibana-4.2.0-linux-x64.tar.gz | \
    tar -xzC / && \
    mv /kibana-4.2.0-linux-x64 /kibana
VOLUME ["/data"]
WORKDIR /data 
ADD bootstrap.sh /data/bootstrap.sh


