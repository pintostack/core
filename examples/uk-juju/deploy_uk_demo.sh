#!/usr/bin/env bash
set -e
export JUJU_REPOSITORY=$PWD/juju/

juju bootstrap

juju set-env "default-series=trusty"

cd juju
./build_charms.sh
cd ..

#juju set-constraints "mem=512M"
#juju set-constraints 'instance-type=m1.small'

echo "Starting Juju GUI"

juju deploy juju-gui --to 0
juju expose juju-gui

echo "Stating Pintostack and tutorial components"

if [ ! -f config.yaml ]; then
	echo "File: config.yaml do not exist, please copy config.yaml.tmpl and edit"
	exit 1
else
	echo "File: config.yaml found, deploying configuration"
fi

juju deploy local:trusty/pintostack --config config.yaml --to 0
juju deploy local:trusty/hdfsnn4pintostack --to 0
juju deploy local:trusty/hdfsdn4pintostack --to 0
juju deploy local:trusty/ipythonnb4pintostack --to 0
juju deploy local:trusty/ukdata4pintostack --to 0

echo "Adding component relations"

juju add-relation pintostack hdfsnn4pintostack
juju add-relation pintostack ipythonnb4pintostack
juju add-relation pintostack hdfsdn4pintostack
juju add-relation pintostack ukdata4pintostack

juju expose ipythonnb4pintostack

echo "System is running, you can watch PintoStack bootstrap on"
juju stat | grep -A 25 juju-gui: | grep public-address:

