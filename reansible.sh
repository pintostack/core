#!/usr/bin/env bash
source conf/source.global

ansible-playbook -i ${ANSIBLE_INVENTORY_FILE} provisioning/world-playbook-fast.yml ${ANSIBLE_OPTS}
