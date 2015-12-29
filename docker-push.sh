#!/bin/bash

function print_usage (){
  echo "Usage: ./pushDocker.sh image_name"
}

if [ $# = 0 ]; then
  print_usage
  exit
else
  cd infrastructure
  ./docker-build.sh $1 
fi

