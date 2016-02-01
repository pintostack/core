#!/usr/bin/env bash
source conf/source.global

ansible-playbook -i ${ANSIBLE_INVENTORY_FILE} provisioning/world-playbook.yml ${ANSIBLE_OPTS}
