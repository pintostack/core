#!/usr/bin/env bash
source .env

if [ "x${1}" == "x" ]; then
    echo "Put the number of slave you want to reprovision in the parameter
Example for slave-4:
$0 4"
    exit 1
fi

ansible-playbook -i ${ANSIBLE_INVENTORY_FILE} provisioning/add-slave.yml -e add_number=${1} ${ANSIBLE_OPTS}
