provider = :virtualbox

tokens=ARGV[1].split("=") rescue []
provider = tokens[1].to_sym if tokens[1]

vpc_if = provider == :aws ? "eth0" : "eth1"

# .env is actually `env > .env` so we will just read this file. But remember to update this file eachtime you make changes,
CONFIG = File.new(".env").read.split("\n").map{ |t| x=t.index("="); [t[0..x-1], t[x+1..-1] ]}.inject({}) {|r, a| r[a[0]] = a[1].strip;r}

puts %Q(
Detected provider "#{provider}"
Setting VPC interface '#{vpc_if}'
)

SLAVES = CONFIG["SLAVES"]
MASTERS = CONFIG["MASTERS"]

ALL_HOSTS=[]
(1..MASTERS.to_i).each {|i| ALL_HOSTS.push "master-#{i}"}
(1..SLAVES.to_i).each {|i| ALL_HOSTS.push "slave-#{i}"}

Vagrant.configure(2) do |config|
  config.vm.network "private_network", type: :dhcp
  config.vm.hostname = 'default-host-delete-me'
  config.vm.box = "ubuntu/trusty64"
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.provider :digital_ocean do |digital_ocean, override|
          digital_ocean.token = CONFIG["DO_TOKEN"]
          digital_ocean.image = CONFIG["DO_IMAGE"]
          digital_ocean.region = CONFIG["DO_REGION"]
          digital_ocean.size = CONFIG["DO_SIZE"]
          digital_ocean.private_networking = true
          override.ssh.private_key_path = CONFIG["SSH_KEY_FILE"]
          override.vm.box = 'digital_ocean'
          override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
  end
  config.vm.provider :aws do |aws, override|
          aws.access_key_id = CONFIG["AWS_KEY_ID"]
          aws.secret_access_key = CONFIG["AWS_ACCESS_KEY"]
          aws.keypair_name = CONFIG["AWS_KEYPAIR_NAME"]
          aws.ami = CONFIG["AWS_AMI"]
          aws.instance_type = CONFIG["AWS_INSTANCE_TYPE"]
          aws.region = CONFIG["AWS_REGION"]
          aws.security_groups = CONFIG["AWS_SECURITY_GROUPS"].split(",") rescue ""
          aws.block_device_mapping = [{ 'DeviceName' => '/dev/sda1', 'Ebs.VolumeSize' => CONFIG["AWS_ROOT_PARTITION_SIZE"] }]
          aws.terminate_on_shutdown = CONFIG["AWS_TERMINATE_ON_SHUTDOWN"]
          override.ssh.username = CONFIG["AWS_SSH_USERNAME"]
          override.vm.box = 'aws'
          override.vm.box_url ="https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
          override.ssh.private_key_path = CONFIG["SSH_KEY_FILE"]
  end
  config.vm.provider :virtualbox do |virtualbox|
          virtualbox.gui = false
          virtualbox.memory = CONFIG["VBOX_SIZE"]
          virtualbox.cpus = 2
  end

  ALL_HOSTS.each do |i|
    name = "#{i}"
    config.vm.define name do |instance|
	    instance.vm.hostname = name # Name in web console DO
	    instance.vm.provider :aws do |aws, override|
        aws.tags={ 'Name' => name }
      end
      instance.vm.provider :virtualbox do |virtualbox|
          virtualbox.name = name
      end
      if name == "slave-#{SLAVES}" # Run ansible after last host provision
        instance.vm.provision :ansible do |ansible|
          ansible.playbook = "provisioning/world-playbook-fast.yml"
          ansible.limit = 'all'
          ansible.force_remote_user = true
          ansible.host_vars={}
          ALL_HOSTS.each do |each_host|
            ansible.host_vars["#{each_host}"] = {"vpc_if" => "#{vpc_if}"}
          end
          ansible.groups = {
              "masters" => ["master-[1:#{MASTERS.to_i}]"],
              "slaves" => ["slave-[1:#{SLAVES.to_i}]"],
              "all-hosts" => ["master-[1:#{MASTERS.to_i}]","slave-[1:#{SLAVES.to_i}]"]
          }
        end
        instance.vm.provision :ansible do |ansible|
          ansible.playbook = "provisioning/containers.yml"
          ansible.limit = 'all'
          ansible.force_remote_user = true
          ansible.host_vars={}
          ALL_HOSTS.each do |each_host|
            ansible.host_vars["#{each_host}"] = {"vpc_if" => "#{vpc_if}"}
          end
          ansible.groups = {
              "masters" => ["master-[1:#{MASTERS.to_i}]"],
              "slaves" => ["slave-[1:#{SLAVES.to_i}]"],
              "all-hosts" => ["master-[1:#{MASTERS.to_i}]","slave-[1:#{SLAVES.to_i}]"]
          }
        end
      end
    end
  end
#END
end


ANSIBLE_INVENTORY_FILE = CONFIG["ANSIBLE_INVENTORY_FILE"]

puts %Q(
Done!
You can run open_webui.sh to open browser with mesos and marathon.
You can run reansible.sh to bootstrap all host one more time in case
of network errors.
)
