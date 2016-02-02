#!/usr/bin/env bash

sed -i "/^ANSIBLE_OPTS.*/d" conf/source.global
echo "ANSIBLE_OPTS=\"-vvv\"" >> conf/source.global

./marathon-push.sh $1
