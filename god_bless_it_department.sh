
#!/usr/bin/env bash
source .env

ansible-playbook -i ${ANSIBLE_INVENTORY_FILE} provisioning/fix-fuzzy-network.yml ${ANSIBLE_OPTS}
