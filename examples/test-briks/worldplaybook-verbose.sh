#!/usr/bin/env bash
source source.global

ansible-playbook -i ${ANSIBLE_INVENTORY_FILE} provisioning/world-playbook.yml -vvv ${ANSIBLE_OPTS}
