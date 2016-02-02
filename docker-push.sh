#!/usr/bin/env bash
source conf/source.global

function print_usage (){
    echo "
Usage: $0 <image_name>
All available images you can find in docker directory
"
    ls docker/
}

if [ $# = 0 ]; then
  print_usage
  exit
else
    ansible-playbook -i $ANSIBLE_INVENTORY_FILE provisioning/docker-build.yml -e name=$1 $ANSIBLE_OPTS
fi
