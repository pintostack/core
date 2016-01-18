# Ansible Consul Role

> `consul` is an [ansible](http://www.ansible.com) role which: 
> 
> * installs consul
> * configures consul
> * installs consul ui
> * configures consul ui
> * optionally installs dnsmasq
> * optionally install consulate
> * configures consul service(s)

# Ports

This is a nested object that allows setting the bind ports for the following keys:

dns - The DNS server, -1 to disable. Default 8600.

http - The HTTP API, -1 to disable. Default 8500.

https - The HTTPS API, -1 to disable. Default -1 (disabled).

rpc - The RPC endpoint. Default 8400.

serf_lan - The Serf LAN port. Default 8301.

serf_wan - The Serf WAN port. Default 8302.

server - Server RPC address. Default 8300.


## Installation

Using `ansible-galaxy`:

```
$ ansible-galaxy install savagegus.consul
```

Using `arm` ([Ansible Role Manager](https://github.com/mirskytech/ansible-role-manager/)):

```
$ arm install savagegus.ansible-consul
```

Using `git`:

```
$ git clone https://github.com/jivesoftware/ansible-consul.git
```

## Variables

Here is a list of all the default variables for this role, which are also available in `defaults/main.yml`.

```
# default version and download locations
consul_version: 0.3.1
consul_archive: "{{ consul_version }}_linux_amd64.zip"
consul_ui_archive: "{{ consul_version }}_web_ui.zip"
consul_download: "https://dl.bintray.com/mitchellh/consul/{{ consul_archive }}"
consul_ui_download: "https://dl.bintray.com/mitchellh/consul/{{ consul_ui_archive }}"
# default directories
consul_download_folder: /tmp
consul_home: /opt/consul
consul_config_dir: /etc/consul.d
consul_config_file: /etc/consul.conf
consul_log_file: /var/log/consul
consul_data_dir: "{{ consul_home }}/data"
consul_ui_dir: "{{ consul_home }}/dist"
consul_binary: consul
# default settings
consul_user: consul
consul_group: consul
# configure consul as a server
consul_is_server: "false"
# configure consul as a ui
consul_is_ui: "false"
# configure consul to start in bootstrap mode
consul_bootstrap: "false"
consul_bootstrap_expect: 3
# configure service
consul_servers: ['127.0.0.1']
consul_log_level: "INFO"
consul_rejoin_after_leave: "true"
consul_leave_on_terminate: "false"
```

An instance might be defined through:

```
# enable ui
consul_is_ui: "true"
# start as a server
consul_is_server: "true"
# name datacenter
consul_datacenter: "test"
# bootstrap
consul_bootstrap: "true"
# name the node
consul_node_name: "vagrant"
# bind to ip
consul_bind_address: "{{ ansible_default_ipv4['address'] }}"
# encrypt using string from consul keygen
consul_encrypt: "X4SYOinf2pTAcAHRhpj7dA=="
```

## Handlers

These are the handlers that are defined in `handlers/main.yml`.

* `restart consul` 
* `restart dnsmasq` 

## Example playbook

```
---

- hosts: all
  roles:
    - ansible-consul
  vars:
    consul_is_ui: "true"
    consul_is_server: "true"
    consul_datacenter: "test"
    consul_bootstrap: "true"
    consul_node_name: "vagrant"
    consul_bind_address: "{{ ansible_default_ipv4['address'] }}"
```

## Testing

```
$ git clone https://github.com/jivesoftware/ansible-consul.git
$ cd ansible-consul
$ vagrant up
```

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests and examples for any new or changed functionality.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License
Copyright (c) Jive Software under the Apache license.
=======
# ansible-consul
>>>>>>> 5037c53ffcc131195248e3f587e14c5c3fb6f05d
