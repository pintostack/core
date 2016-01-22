FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install -y wget curl vim
RUN apt-get install -y software-properties-common python-setuptools libffi-dev libssl-dev python-dev  openssh-server
RUN easy_install pip
RUN pip install requests[security]
RUN pip install ansible==2.0.0.2

RUN pip install pyopenssl ndg-httpsclient pyasn1 mock six dopy

RUN wget https://releases.hashicorp.com/vagrant/1.8.1/vagrant_1.8.1_x86_64.deb
RUN dpkg -i vagrant_1.8.1_x86_64.deb
RUN vagrant plugin install aws vagrant-aws

RUN sed -i -- 's/$HOME\/.ansible\/cp/\/tmp/g' /usr/local/lib/python2.7/dist-packages/ansible/plugins/connection/ssh.py

ADD . /pintostack
RUN rm -rf /pintostack/conf
RUN rm -rf /pintostack/.vagrant


