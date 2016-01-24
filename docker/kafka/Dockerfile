# Kafka image built on top of  http://github.com/ches/docker-kafka
FROM ches/kafka:0.8.2.1

USER root

# copying config one more time to override settings if needed
ADD config /kafka/config

# installing dependencies for bootstrap script
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y sed jq curl && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ADD bootstrap.sh /bootstrap.sh

USER kafka

# set entrypoint to execute bootstrap script
# and set environment variables with startup options
# Kafka itself will be started by default CMD script
ENTRYPOINT ["/bootstrap.sh"]
WORKDIR ["/kafka"]
CMD ["/start.sh"]
