FROM pintostack/pintostack-mesos-slave

MAINTAINER Yuri Vlasov (yu.vlasov@gmail.com)

# Set the env variable DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update

# Install ubuntu packages.
RUN \
  sudo apt-get install -y autoconf libtool git npm wget curl jq && \
  sudo apt-get install -y build-essential python-dev \
	python-boto libcurl4-nss-dev libsasl2-dev \
	libapr1-dev libsvn-dev ipython-notebook \
	ipython-notebook-common python-pip \
	python-mathgl python-igraph python-matplotlib python-mpmath \
	python-plplot python-pychart python-sciscipy  python-scipy python-scitools

WORKDIR /root


#Create Work directory for iPython
RUN mkdir -p /root/ipython ; \
	mkdir -p /root/.ipython/profile_pyspark/startup/

WORKDIR  /root/

COPY ./bootstrap.sh /root/bootstrap.sh

#ENTRYPOINT ./bootstrap.sh
