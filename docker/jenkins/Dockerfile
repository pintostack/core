FROM pintostack/pintostack-base-mesos

MAINTAINER Yuri G

RUN wget http://mirrors.jenkins-ci.org/war/latest/jenkins.war -O /tmp/jenkins.war

RUN apt-get update && apt-get -y install libcurl4-nss-dev libsasl2-dev maven libapr1-dev libsvn-dev jq

COPY ./bootstrap.sh /tmp/bootstrap.sh
RUN chmod +x /tmp/bootstrap.sh

EXPOSE 8080

CMD /tmp/bootstrap.sh