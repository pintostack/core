#!/usr/bin/env bash
PROVIDER=virtualbox
if [ $# -eq 1 ]; then
  PROVIDER=$1
fi

GLOBAL_VARS_LIST="$( set -o posix ; set | cut -f1 -d= )"

if [ -f conf/source.global ]; then
    source conf/source.global
else
    echo "ERROT: No file: conf/source.global"
    exit 1
fi

if [ -f conf/source.$PROVIDER ]; then
    source conf/source.$PROVIDER
else
    echo "ERROT: No file: conf/source.$PROVIDER"
    exit 1
fi

( set -o posix ; set ) > .env

#Removing old global vars from .env
for each in $GLOBAL_VARS_LIST; do
	sed -i "/^${each}/d" .env
done
sed -i "/^GLOBAL_VARS_LIST/d" .env

GLOBAL_VARS_LIST
echo "Provider is ${PROVIDER}"
echo "Setting Vagrant env..."
cat .env

vagrant up --provider=${PROVIDER}
