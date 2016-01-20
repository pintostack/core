#!/bin/bash
source source.global

MASTER_1="$(sed -n "/^master-1\s/p" ${ANSIBLE_INVENTORY_FILE} | grep -Po 'ansible_ssh_host=\K[^ ]*')"

python -m webbrowser -t "http://${MASTER_1}:5050"
python -m webbrowser -t "http://${MASTER_1}:8080"

