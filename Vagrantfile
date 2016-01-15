#!/usr/bin/env ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :
print "
==================================================================
To change provisioning options please use source.[provider] files.
For more information refere to https://github.com/pintostack/core
"
system("ls source.*")
print "
==================================================================
"

MASTERS = system("source source.global; echo $MASTERS")
SLAVES = system("source source.global; echo $SLAVES")

#Vagrant.require_plugin 'vagrant-aws'
#Vagrant.require_plugin 'vagrant-digital_ocean'
#Vagrant.require_plugin 'vagrant-cachier'

Vagrant.configure(2) do |config|
  config.vm.network "private_network", type: :dhcp
  config.vm.hostname = 'default-host-delete-me'
  config.vm.box = "ubuntu/trusty64"
  config.vm.synced_folder ".", "/vagrant", disabled: true


  (1..MASTERS).each do |i|
    name = "master-#{i}"
    config.vm.define name do |instance|
    instance.vm.hostname = name # Name in web console DO
    instance.vm.provision :ansible do |ansible|
          ansible.playbook = "infrastructure/provision/dummy-playbook.yml"
    end
    instance.vm.provider :digital_ocean do |digital_ocean, override|
          digital_ocean.token = system("source source.digital_ocean; echo $DO_TOKEN")
          digital_ocean.image = system("source source.digital_ocean; echo $DO_IMAGE")
          digital_ocean.region = system("source source.digital_ocean; echo $DO_REGION")
          digital_ocean.size = system("source source.digital_ocean; echo $DO_SIZE")
          digital_ocean.private_networking = true
          override.ssh.private_key_path = system("source source.digital_ocean; echo $SSH_KEY_FILE")
          override.vm.box = 'digital_ocean'
          override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
    end
    instance.vm.provider :aws do |aws, override|
          aws.access_key_id = system("source source.aws; echo $AWS_KEY_ID")
          aws.secret_access_key = system("source source.aws; echo $AWS_ACCESS_KEY")
          aws.keypair_name = system("source source.aws; echo $AWS_KEYPAIR_NAME")
          aws.tags = {
          'Name' => name,
          'Description' => 'This instance is a part of PintoStack installation you can find https://github.com/pintostack/core.'
          }
          aws.ami = system("source source.aws; echo $AWS_AMI")
          aws.instance_type = system("source source.aws; echo $AWS_INSTANCE_TYPE")
          aws.region = system("source source.aws; echo $AWS_REGION")
          aws.security_groups = system("source source.aws; echo $AWS_SEQURITY_GROUPS")
          override.ssh.username = system("source source.aws; echo $AWS_SSH_USERNAME")
          override.vm.box = aws
          override.vm.box_url ="https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
          override.ssh.private_key_path = system("source source.aws; echo $SSH_KEY_FILE")
    end
    instance.vm.provider :virtualbox do |virtualbox|
          virtualbox.name = name
          virtualbox.gui = false
          virtualbox.memory = system("source source.virtualbox; echo $VBOX_MEMORY")
          virtualbox.cpus = 2
    end
   end
 end


  (1..SLAVES).each do |i|
    name = "slave-#{i}"
    config.vm.define name do |instance|
    instance.vm.hostname = name # Name in web console DO
    instance.vm.provision :ansible do |ansible|
          ansible.playbook = "infrastructure/provision/dummy-playbook.yml"
    end
    instance.vm.provider :digital_ocean do |digital_ocean, override|
          digital_ocean.token = system("source source.digital_ocean; echo $DO_TOKEN")
          digital_ocean.image = system("source source.digital_ocean; echo $DO_IMAGE")
          digital_ocean.region = system("source source.digital_ocean; echo $DO_REGION")
          digital_ocean.size = system("source source.digital_ocean; echo $DO_SIZE")
          digital_ocean.private_networking = true
          override.ssh.private_key_path = system("source source.digital_ocean; echo $SSH_KEY_FILE")
          override.vm.box = 'digital_ocean'
          override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
    end
    instance.vm.provider :aws do |aws, override|
          aws.access_key_id = system("source source.aws; echo $AWS_KEY_ID")
          aws.secret_access_key = system("source source.aws; echo $AWS_ACCESS_KEY")
          aws.keypair_name = system("source source.aws; echo $AWS_KEYPAIR_NAME")
          aws.tags = {
          'Name' => name,
          'Description' => 'This instance is a part of PintoStack installation you can find https://github.com/pintostack/core.'
          }
          aws.ami = system("source source.aws; echo $AWS_AMI")
          aws.instance_type = system("source source.aws; echo $AWS_INSTANCE_TYPE")
          aws.region = system("source source.aws; echo $AWS_REGION")
          aws.security_groups = system("source source.aws; echo $AWS_SEQURITY_GROUPS")
          override.ssh.username = system("source source.aws; echo $AWS_SSH_USERNAME")
          override.vm.box = aws
          override.vm.box_url ="https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
          override.ssh.private_key_path = system("source source.aws; echo $SSH_KEY_FILE")
    end
    instance.vm.provider :virtualbox do |virtualbox|
          virtualbox.name = name
          virtualbox.gui = false
          virtualbox.memory = system("source source.virtualbox; echo $VBOX_MEMORY")
          virtualbox.cpus = 2
    end
   end
 end

    name = "docker-registry"
    config.vm.define name do |instance|
    instance.vm.hostname = name # Name in web console DO
    instance.vm.provision :ansible do |ansible|
          ansible.playbook = "infrastructure/provision/dummy-playbook.yml"
    end
    instance.vm.provider :digital_ocean do |digital_ocean, override|
          digital_ocean.token = system("source source.digital_ocean; echo $DO_TOKEN")
          digital_ocean.image = system("source source.digital_ocean; echo $DO_IMAGE")
          digital_ocean.region = system("source source.digital_ocean; echo $DO_REGION")
          digital_ocean.size = system("source source.digital_ocean; echo $DO_SIZE")
          digital_ocean.private_networking = true
          override.ssh.private_key_path = system("source source.digital_ocean; echo $SSH_KEY_FILE")
          override.vm.box = 'digital_ocean'
          override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
    end
    instance.vm.provider :aws do |aws, override|
          aws.access_key_id = system("source source.aws; echo $AWS_KEY_ID")
          aws.secret_access_key = system("source source.aws; echo $AWS_ACCESS_KEY")
          aws.keypair_name = system("source source.aws; echo $AWS_KEYPAIR_NAME")
          aws.tags = {
          'Name' => name,
          'Description' => 'This instance is a part of PintoStack installation you can find https://github.com/pintostack/core.'
          }
          aws.ami = system("source source.aws; echo $AWS_AMI")
          aws.instance_type = system("source source.aws; echo $AWS_INSTANCE_TYPE")
          aws.region = system("source source.aws; echo $AWS_REGION")
          aws.security_groups = system("source source.aws; echo $AWS_SEQURITY_GROUPS")
          override.ssh.username = system("source source.aws; echo $AWS_SSH_USERNAME")
          override.vm.box = aws
          override.vm.box_url ="https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
          override.ssh.private_key_path = system("source source.aws; echo $SSH_KEY_FILE")
    end
    instance.vm.provider :virtualbox do |virtualbox|
          virtualbox.name = name
          virtualbox.gui = false
          virtualbox.memory = system("source source.virtualbox; echo $VBOX_MEMORY")
          virtualbox.cpus = 2
    end
   end
end