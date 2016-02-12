#!/usr/bin/env bash
source conf/source.global

ansible-playbook -i ${ANSIBLE_INVENTORY_FILE} provisioning/debugging.yml ${ANSIBLE_OPTS}
