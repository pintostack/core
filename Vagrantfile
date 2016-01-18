#!/usr/bin/env ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

print "
==================================================================
To change provisioning options please use source.[provider] files.
For more information refere to https://github.com/pintostack/core"
system("ls source.*")
print "Usage:
vagrant up --provider=[virtualbox|aws|digital_ocean]

More information on vagrant it self you can find
here http://docs.vagrantup.com/v2/cli/index.html
==================================================================
"
SLAVES = %x( bash -c "source source.global && echo \\$SLAVES" ).strip
MASTERS = %x( bash -c "source source.global && echo \\$MASTERS" ).strip
#Vagrant.require_plugin 'vagrant-aws'
#Vagrant.require_plugin 'vagrant-digital_ocean'
#Vagrant.require_plugin 'vagrant-cachier'

#puts MASTERS.to_i
#exit
ALL_HOSTS=[]
(1..MASTERS.to_i).each do |i|
   m_host = "master-#{i}"
   ALL_HOSTS.push("#{m_host}")
end
(1..SLAVES.to_i).each do |i|
    s_host = "slave-#{i}"
    ALL_HOSTS.push("#{s_host}")
end
ALL_HOSTS.push("docker-registry")

Vagrant.configure(2) do |config|
  config.vm.network "private_network", type: :dhcp
  config.vm.hostname = 'default-host-delete-me'
  config.vm.box = "ubuntu/trusty64"
  config.vm.synced_folder ".", "/vagrant", disabled: true


  config.vm.provider :digital_ocean do |digital_ocean, override|
          digital_ocean.token = %x( bash -c "source source.digital_ocean && echo \\$DO_TOKEN").strip
          digital_ocean.image = %x( bash -c "source source.digital_ocean && echo \\$DO_IMAGE").strip
          digital_ocean.region = %x( bash -c "source source.digital_ocean && echo \\$DO_REGION").strip
          digital_ocean.size = %x( bash -c "source source.digital_ocean && echo \\$DO_SIZE").strip
          digital_ocean.private_networking = true
          override.ssh.private_key_path = %x( bash -c "source source.digital_ocean && echo \\$SSH_KEY_FILE").strip
          override.vm.box = 'digital_ocean'
          override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
  end
  config.vm.provider :aws do |aws, override|
          aws.access_key_id = %x( bash -c "source source.aws && echo \\$AWS_KEY_ID").strip
          aws.secret_access_key = %x( bash -c "source source.aws && echo \\$AWS_ACCESS_KEY").strip
          aws.keypair_name = %x( bash -c "source source.aws && echo \\$AWS_KEYPAIR_NAME").strip
          aws.ami = %x( bash -c "source source.aws && echo \\$AWS_AMI").strip
          aws.instance_type = %x( bash -c "source source.aws && echo \\$AWS_INSTANCE_TYPE").strip
          aws.region = %x( bash -c "source source.aws && echo \\$AWS_REGION").strip
          aws.security_groups = %x( bash -c "source source.aws && echo \\$AWS_SEQURITY_GROUPS").strip
          override.ssh.username = %x( bash -c "source source.aws && echo \\$AWS_SSH_USERNAME").strip
          override.vm.box = aws
          override.vm.box_url ="https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
          override.ssh.private_key_path = %x( bash -c "source source.aws && echo \\$SSH_KEY_FILE").strip
  end
  config.vm.provider :virtualbox do |virtualbox|
          virtualbox.gui = false
          virtualbox.memory = %x( bash -c "source source.virtualbox && echo \\$VBOX_SIZE").strip
          virtualbox.cpus = 2
  end

  ALL_HOSTS.each do |i|
    name = "#{i}"
    config.vm.define name do |instance|
	instance.vm.hostname = name # Name in web console DO
	if name == "docker-registry"
	instance.vm.provision :ansible do |ansible|
	    ansible.playbook = "provisioning/world-playbook.yml"
    	    ansible.limit = 'all'
    	    ansible.force_remote_user = true
    	    ansible.host_vars={}
    	    ALL_HOSTS.each do |each_host|
        	ansible.host_vars["#{each_host}"] = {"vpc_if" => "eth1"}
    	    end
    	    ansible.groups = {
              "masters" => ["master-[1:#{MASTERS.to_i}]"],
              "slaves" => ["slave-[1:#{SLAVES.to_i}]"],
              "dockers" => ["docker-registry"],
              "all-hosts" => ["master-[1:#{MASTERS.to_i}]","slave-[1:#{SLAVES.to_i}]","docker-registry"]
    	    }
	end
	end
       instance.vm.provider :aws do |aws, override|
         aws.tags={ 'Name' => name }
	 if name == "docker-registry"
	 override.vm.provision :ansible do |ansible|
            ansible.playbook = "provisioning/world-playbook.yml"
            ansible.limit = 'all'
            ansible.force_remote_user = true
            ansible.host_vars={}
            ALL_HOSTS.each do |each_host|
              ansible.host_vars["#{each_host}"] = {"vpc_if" => "eth0"}
            end
            ansible.groups = {
              "masters" => ["master-[1:#{MASTERS.to_i}]"],
              "slaves" => ["slave-[1:#{SLAVES.to_i}]"],
              "dockers" => ["docker-registry"],
              "all-hosts" => ["master-[1:#{MASTERS.to_i}]","slave-[1:#{SLAVES.to_i}]","docker-registry"]
            }
         end
	 end
       end
       instance.vm.provider :virtualbox do |virtualbox|
          virtualbox.name = name
       end
    end
  end
#END
end
