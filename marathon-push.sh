#!/usr/bin/env bash
source .env

function print_usage (){
    echo "
Usage: $0 <task-description.json>
All available tasks you can find in marathon directory
"
    ls marathon/
}

if [ $# = 0 ]; then
  print_usage
  exit
else
    ansible-playbook -i $ANSIBLE_INVENTORY_FILE provisioning/marathon-deploy.yml -e name=$1 $ANSIBLE_OPTS
fi
