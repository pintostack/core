#!/usr/bin/env bash
PROVIDER=virtualbox
if [ $# -eq 1 ]; then
  PROVIDER=$1
fi
if [ -f conf/source.$PROVIDER ]; then
    source conf/source.$PROVIDER
    echo "$AWS_REGION"
else
    echo "ERROT: No file: conf/source.$PROVIDER"
    exit 1
fi

( set -o posix ; set ) > .env

echo "Provider is ${PROVIDER}"
