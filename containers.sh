#!/usr/bin/env bash
source .env

ansible-playbook -i ${ANSIBLE_INVENTORY_FILE} provisioning/containers.yml ${ANSIBLE_OPTS}
