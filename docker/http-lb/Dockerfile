FROM pintostack/pintostack-base
#FROM ubuntu:14.04

MAINTAINER Yuri Vlasov (yu.vlasov@gmail.com)

#Install required pips
RUN pip install jinja2 simplejson

# Install nginx.
RUN apt-get update && apt-get install -y nginx

ADD ./files /files/

ADD ./bootstrap.sh /

RUN chmod +x bootstrap.sh

WORKDIR /

ENTRYPOINT /bootstrap.sh
