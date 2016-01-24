FROM develar/java:8u45

MAINTAINER devicehive

ENV DH_VERSION="2.0.10"

RUN mkdir -p /opt/devicehive

ADD https://github.com/devicehive/devicehive-java-server/releases/download/${DH_VERSION}/devicehive-${DH_VERSION}-boot.jar /opt/devicehive/

RUN apk add --update sed curl jq bash \
    && rm -rf /var/cache/apk/*

#start script
ADD bootstrap.sh /bootstrap.sh
ADD bootstrap.sh /opt/devicehive/bootstrap.sh

VOLUME ["/var/log/devicehive"]

WORKDIR /opt/devicehive/
ENTRYPOINT ["/bin/sh"]
CMD ["/opt/devicehive/bootstrap.sh"]

EXPOSE 80
