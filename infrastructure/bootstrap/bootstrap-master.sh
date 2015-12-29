#!/bin/bash

ansible-playbook -i __inv_file bootstrap/master.yml -e user=__username -e local_iface=__iface __adds
