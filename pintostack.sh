#!/usr/bin/env bash
PROVIDER=virtualbox
if [ $# -eq 1 ]; then
  PROVIDER=$1
fi

GLOBAL_VARS_LIST="$( set -o posix ; set | cut -f1 -d= )"

if [ "x$PROVIDER" == "xvirtualbox" ]; then
	if [ -f /.dockerinit ]; then
		echo "Managing VirtualBOX from docker container not supported, please run $0 without docker"
		exit 1
	fi
fi
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
	sed -i.bak "/^${each}/d" .env
done
sed -i.bak "/^GLOBAL_VARS_LIST/d" .env

echo "Provider is ${PROVIDER}"
echo "Setting Vagrant env..."
cat .env
echo "Refreshing Vagrant global status befor begin..."
vagrant global-status --prune
echo "Starting Vagrant.."
vagrant up --provider=${PROVIDER}
if [ "x$PROVIDER" == "xmanaged" ]; then 
    vagrant provision
fi
