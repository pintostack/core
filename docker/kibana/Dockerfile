FROM alpine:3.3

MAINTAINER Sergii Suchkov (srg.suchkov@gmail.com)

RUN apk add --update sed curl jq bash && \
    rm -rfv /var/cache/apk/*

RUN curl -s https://download.elastic.co/kibana/kibana/kibana-4.2.0-linux-x64.tar.gz | \
    tar -xzC / && \
    mv /kibana-4.2.0-linux-x64 /kibana

VOLUME ["/data"]
WORKDIR /data

ADD bootstrap.sh /data/bootstrap.sh
ENTRYPOINT ["/data/bootstrap.sh"]
