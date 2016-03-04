FROM pintostack/pintostack-base

MAINTAINER Yuri Vlasov (yu.vlasov@gmail.com)

# Set the env variable DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update

# Install ubuntu packages.
RUN \
  sudo apt-get install -y docker.io
  
WORKDIR /root

WORKDIR  /root/

COPY ./bootstrap.sh /bootstrap.sh

ENTRYPOINT ./bootstrap.sh
