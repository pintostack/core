#!/usr/bin/env bash
source .env

vagrant global-status --prune

ansible-playbook -i ${ANSIBLE_INVENTORY_FILE} provisioning/world-playbook.yml -vvv ${ANSIBLE_OPTS}
