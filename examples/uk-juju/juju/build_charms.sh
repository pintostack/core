#!/usr/bin/env bash
set -e
CHARM_LIST="ukdata4pintostack hdfsdn4pintostack hdfsnn4pintostack ipythonnb4pintostack  pintostack"
START_PWD=$(pwd)
JUJU_SERIES="trusty"
if [ ! -d ${JUJU_SERIES} ]; then
    mkdir ${JUJU_SERIES}
fi
for each in $CHARM_LIST; do
	cd $each
	echo "Checking $each charm"
	juju charm proof
	if [ $? -eq 0 ]; then
		echo "Charm $each looks good, building one..."
		juju charm build
	else
		echo "Check $each charm FAILS fix it."
		exit 1
	fi
	ln -s ../${each}/${JUJU_SERIES}/${each} ${START_PWD}/${JUJU_SERIES}/${each}
	cd ${START_PWD}
done
