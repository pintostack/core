FROM alpine:3.3

RUN apk add --update bash curl 'redis<3.1' \
    && rm -rf /var/cache/apk/*

ENV REDISDATA /data
VOLUME /data
WORKDIR /data

ADD bootstrap.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/redis-server"]

EXPOSE 6379
