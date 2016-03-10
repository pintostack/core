#!/usr/bin/env bash
source .env

NEW_SLAVES=$[ ${SLAVES} + 1 ];
sed -i.bak "/^SLAVES=.*/d" .env
echo "SLAVES=${NEW_SLAVES}" >> .env

source .env

touch .vagrant_provision_disable
vagrant up slave-$SLAVES --provider=${RESOURCE_PROVIDER}
rm -f .vagrant_provision_disable

ansible-playbook -i ${ANSIBLE_INVENTORY_FILE} provisioning/add-slave.yml -e add_number=${SLAVES} ${ANSIBLE_OPTS}
