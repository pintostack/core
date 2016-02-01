#!/usr/bin/env bash
set -e

PROVIDER=virtualbox
if [ $# -eq 1 ]; then
  PROVIDER=$1
fi
cat ./conf/source.$PROVIDER | while read line; do
    declare -x $line
done
echo "Provider is ${PROVIDER}"
env > .env
vagrant up --provider=$PROVIDER
