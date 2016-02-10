FROM pintostack-base


RUN sudo apt-get install -y \
 build-essential \
 libevent-dev \
 libssl-dev \
 liblzma-dev \
 python-dev \
 python-pip \
 python-passlib \
 swig \
 selinux-utils \
 curl \
 docker.io

RUN sudo pip install \
 blinker==1.3 \
 Flask==0.10.1 \
 gevent==1.0.1 \
 gunicorn==19.1.1 \
 PyYAML==3.11 \
 requests==2.3.0 \
 M2Crypto==0.22.3 \
 sqlalchemy==0.9.4 \
 setuptools==5.8 \
 docker-registry 

RUN sudo /bin/mkdir -p /var/docker-registry && sudo /bin/mkdir -p /var/log/docker-registry

ENTRYPOINT ["/bin/true"]




