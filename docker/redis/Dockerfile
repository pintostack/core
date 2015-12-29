FROM ubuntu:15.04

RUN apt-get update
RUN apt-get install -y curl redis-server
RUN mkdir /data

WORKDIR /data

ADD bootstrap.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/redis-server"]

EXPOSE 6379