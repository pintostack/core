#!/usr/bin/env bash
set -e

PROVIDER=virtualbox
if [ $# -eq 1 ]; then
  PROVIDER=$1
fi
source conf/source.$PROVIDER
echo "Provider is ${PROVIDER}"
env > .env
vagrant up --provider=$PROVIDER