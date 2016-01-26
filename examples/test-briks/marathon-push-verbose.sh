#!/usr/bin/env bash

sed -i "/^ANSIBLE_OPTS.*/d" source.global
echo "ANSIBLE_OPTS=\"-vvv\"" >> source.global

./marathon-push.sh $1
