#!/usr/bin/env bash
source .env

sed -i "/^ANSIBLE_OPTS.*/d" .env
echo "ANSIBLE_OPTS=\"-vvv $ANSIBLE_OPTS\"" >> .env

./marathon-push.sh $1
