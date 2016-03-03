FROM pintostack/pintostack-mesos-slave

EXPOSE 7077
EXPOSE 8081

RUN apt-get install -y jq

WORKDIR /usr/lib/spark-1.5.2-bin-hadoop2.6

ADD bootstrap.sh /usr/lib/spark-1.5.2-bin-hadoop2.6/s.sh
RUN chmod +x s.sh

ENTRYPOINT "./s.sh"

