FROM pintostack-base

#########
# Beats
#########

RUN sudo apt-get install -y \
 rpm

RUN sudo curl -L -O https://download.elastic.co/beats/filebeat/filebeat-1.0.0-x86_64.rpm \
  && sudo rpm -vi filebeat-1.0.0-x86_64.rpm \
  && rm -f /filebeat-1.0.0-x86_64.rpm

ENTRYPOINT ["/bin/true"]




