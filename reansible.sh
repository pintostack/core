#!/usr/bin/env bash
source .env

ansible-playbook -i ${ANSIBLE_INVENTORY_FILE} provisioning/world-playbook-fast.yml ${ANSIBLE_OPTS}
