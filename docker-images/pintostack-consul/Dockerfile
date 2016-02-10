FROM pintostack-base

#########
# Consul
#########

RUN sudo apt-get install -y \
 bind9 \
 bind9utils \
 bind9-doc \
 unzip \
 jq 

RUN sudo pip install \
 tornado \
 consulate

RUN sudo mkdir /opt/src/

RUN sudo curl -L -O https://releases.hashicorp.com/consul/0.5.2/consul_0.5.2_linux_amd64.zip
RUN sudo curl -L -O https://releases.hashicorp.com/consul/0.5.2/consul_0.5.2_web_ui.zip

#consul_download_folder: /tmp
#    dest={{consul_download_folder}}

ENTRYPOINT ["/bin/true"]
