#!/usr/bin/env bash
source .env

MASTER_1="$(sed -n "/^master-1\s/p" ${ANSIBLE_INVENTORY_FILE} | grep -Po 'ansible_ssh_host=\K[^ ]*')"

if [ "x$MASTER_1" == "x127.0.0.1" ]; then
    echo "
To open web ui use vagrant ssh master-1 and run ifconfig to findout IP address,
than open http://MASTER_IP:8080  and http://MASTER_IP:5050"
    exit 0
fi
echo "Mesos: http://${MASTER_1}:5050"
echo  "Marathon: http://${MASTER_1}:8080"
echo  "Consul: http://${MASTER_1}:8500"
python -m webbrowser -t "http://${MASTER_1}:5050"
python -m webbrowser -t "http://${MASTER_1}:8080"
python -m webbrowser -t "http://${MASTER_1}:8500"
