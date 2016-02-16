FROM pintostack/pintostack-base-mesos

## MARATHON ##
ADD http://downloads.mesosphere.com/marathon/v0.15.0/marathon-0.15.0.tgz /tmp/marathon.tgz
RUN mkdir -p /opt/marathon && tar xzf /tmp/marathon.tgz -C /opt/marathon --strip=1 && rm -f /tmp/marathon.tgz

EXPOSE 8080
WORKDIR /opt/marathon
CMD ["--help"]
ENTRYPOINT ["/opt/marathon/bin/start"]