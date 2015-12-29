#
# ------------------------------------------------------
#                       Dockerfile
# ------------------------------------------------------
# image:    ansible-scala
# tag:      latest
# name:     ansibleshipyard/ansible-scala
# version:  v0.2.1
# repo:     https://github.com/AnsibleShipyard/ansible-scala
# how-to:   docker build --force-rm -t ansibleshipyard/ansible-scala .
# debug:    docker run -t -i ansibleshipyard/ansible-scala bash
# requires: ansibleshipyard/ansible-java
# authors:  github:@jasongiedymin,
#           github:
# ------------------------------------------------------

FROM ansibleshipyard/ansible-java
MAINTAINER ansibleshipyard

# -----> Env
ENV WORKDIR /tmp/build/roles/ansible-scala
WORKDIR /tmp/build/roles/ansible-scala

# -----> Add assets
ADD ./tasks $WORKDIR/tasks
ADD ./vars $WORKDIR/vars
ADD ./ci $WORKDIR/ci

# -----> Install Galaxy Dependencies

# -----> Execute
RUN ansible-playbook -i $WORKDIR/ci/inventory $WORKDIR/ci/playbook.yml -c local -vvvv

# -----> Cleanup
WORKDIR /
RUN rm -R /tmp/build
