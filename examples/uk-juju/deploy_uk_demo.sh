#!/usr/bin/env bash
set -e
export JUJU_REPOSITORY=$PWD/juju/

juju set-env "default-series=trusty"
#juju set-constraints "mem=512M"
#juju set-constraints 'instance-type=m1.small'

echo "Starting Juju GUI"

juju deploy juju-gui --to 0
juju expose juju-gui

echo "Stating Pintostack and tutorial components"

if [ ! -f my-config.yaml ]; then
	echo "File: my-config.yaml do not exist, please copy my-config.yaml.tmpl and edit"
	exit 1
else
	echo "File: my-config.yaml found, deploying configuration"
fi

juju deploy local:trusty/pintostack --config my-config.yaml --to 0
juju deploy local:trusty/hdfsnn4pintostack --to 0
juju deploy local:trusty/hdfsdn4pintostack --to 0
juju deploy local:trusty/ipythonnb4pintostack --to 0
juju deploy local:trusty/ukdata4pintostack --to 0

echo "Adding component relations"

juju add-relation pintostack hdfsnn4pintostack
juju add-relation pintostack ipythonnb4pintostack
juju add-relation pintostack hdfsdn4pintostack
juju add-relation pintostack ukdata4pintostack

