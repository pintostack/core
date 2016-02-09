#!/usr/bin/env bash
set -e

CPATH=$(pwd)
cd $CPATH/pintostack-base
docker build -t pintostack-base .

cd $CPATH/pintostack-base-mesos
docker build -t pintostack-base-mesos .

cd $CPATH/pintostack-marathon
docker build -t pintostack-marathon .

cd $CPATH/pintostack-mesos
docker build -t pintostack-mesos .

cd $CPATH/pintostack-zk
docker build -t pintostack-zk .

cd $CPATH

echo "Done"