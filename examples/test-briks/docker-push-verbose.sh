#!/usr/bin/env bash
source .env
sed -i.bak "/^ANSIBLE_OPTS.*/d" .env
echo "ANSIBLE_OPTS=\"-vvv $ANSIBLE_OPTS\"" >> .env

./docker-push.sh $1
