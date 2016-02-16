FROM pintostack/pintostack-base

#RUN echo "deb http://repos.mesosphere.io/ubuntu/ trusty main" > /etc/apt/sources.list.d/mesosphere.list
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF

#Install required pips
RUN pip install jinja2 consulate simplejson curl

# Install nginx.
RUN apt-get update && apt-get install -y nginx

ADD ./files /files/

ADD ./bootstrap.sh /

WORKDIR /

ENTRYPOINT /bootstrap.sh