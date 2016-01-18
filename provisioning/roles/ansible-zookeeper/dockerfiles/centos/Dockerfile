# ------------------------------------------------------
#                       Dockerfile
# ------------------------------------------------------
# image:    ansible-zookeeper-centos
# tag:      latest
# name:     ansibleshipyard/ansible-zookeeper-centos
# version:  1.0.0
# repo:     https://github.com/ansibleshipyard/ansible-zookeeper
# how-to:   docker build --force-rm -t ansibleshipyard/ansible-zookeeper-centos .
# requires: centos
# authors:  jason.giedymin@gmail.com
# desc: Zookeeper Docker Deployed by Ansible
# Created via Ansible CI/Docker Playbook Generator
# ------------------------------------------------------

FROM ansibleshipyard/ansible-base:centos
MAINTAINER ansibleshipyard

# -----> Env
ENV WORKDIR /tmp/build/roles/ansible-zookeeper
WORKDIR /tmp/build/roles/ansible-zookeeper

# -----> Add assets
ADD ./defaults $WORKDIR/defaults
ADD ./meta $WORKDIR/meta
ADD ./tasks $WORKDIR/tasks
ADD ./templates $WORKDIR/templates
ADD ./ci $WORKDIR/ci

# -----> Install Galaxy Dependencies

# -----> Execute
RUN ansible-playbook -i $WORKDIR/ci/inventory $WORKDIR/ci/playbook.yml -c local -vvvv

# -----> Cleanup
WORKDIR /
RUN rm -R /tmp/build
