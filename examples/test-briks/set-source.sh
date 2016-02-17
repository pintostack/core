#!/usr/bin/env bash

function print_usage () {
echo "This script sets variables in source files by postfix, it should be run before ./pitostack.sh
put aws for source.aws file.
Usage:
$0 [global|aws|digital_ocean] <variable name> <value>

Example:
$0 global MASTERS 3		#Sets MASTERS to 3 in conf/source.global file
"
}
if [ $# -lt 1 ]; then
    print_usage
    exit
else
    if [ -f conf/source.$1 ]; then
        sed -i "/^$2.*/d" conf/source.$1
	echo "$2='$3'" >> conf/source.$1
	cat conf/source.$1
    else
	echo "No file conf/source.$1"
	print_usage
	exit
    fi
fi
