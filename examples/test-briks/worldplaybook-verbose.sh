#!/usr/bin/env bash
source source.global

vagrant global-status

ansible-playbook -i ${ANSIBLE_INVENTORY_FILE} provisioning/world-playbook.yml -vvv ${ANSIBLE_OPTS}
