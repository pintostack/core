FROM ubuntu:14.04

MAINTAINER Sergii Suchkov (srg.suchkov@gmail.com)

RUN apt-get update && \
    apt-get install -y \
    openjdk-7-jre \
    curl

RUN curl -s https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.0.0/elasticsearch-2.0.0.tar.gz | \
    tar -xz && \
    mv elasticsearch-2.0.0 elasticsearch

VOLUME ["/data"]

RUN adduser --disabled-password --gecos '' elastic
RUN chown -R elastic:elastic /elasticsearch

USER elastic
WORKDIR /data
ADD bootstrap.sh /data/bootstrap.sh
