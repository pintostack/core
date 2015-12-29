#!/bin/bash

function print_usage (){
  echo "Usage: ./marathon-push.sh <task-description.json>"
}

if [ $# = 0 ]; then
  print_usage
  exit
else
  cd infrastructure
  ./marathon-deploy.sh $1
fi

