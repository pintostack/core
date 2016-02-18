FROM pintostack/jmeter

MAINTAINER Yuri G

RUN apt-get install -y npm
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN npm install -g consul-lookup
ADD test.jmx test.jmx