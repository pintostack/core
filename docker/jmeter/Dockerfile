FROM pintostack/pintostack-base

MAINTAINER Yuri G

RUN wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-2.13.tgz
RUN tar -xvf apache-jmeter-2.13.tgz
RUN rm -rf apache-jmeter-2.13.tgz
ADD jmeter.properties /apache-jmeter-2.13/bin/

COPY ./bootstrap.sh /bootstrap.sh
RUN chmod +x /bootstrap.sh

EXPOSE 1099
EXPOSE 60000

CMD /bootstrap.sh