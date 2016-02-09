#!/usr/bin/env bash
set -e

CPATH=$(pwd)
cd $CPATH/pintostack-base
docker build -t cyberdisk/pintostack-base .

cd $CPATH/pintostack-base-mesos
docker build -t cyberdisk/pintostack-base-mesos .

cd $CPATH/pintostack-marathon
docker build -t cyberdisk/pintostack-marathon .

cd $CPATH/pintostack-mesos
docker build -t cyberdisk/pintostack-mesos .

cd $CPATH/pintostack-zk
docker build -t cyberdisk/pintostack-zk .

cd $CPATH

echo "Done"