#!/usr/bin/env bash

vagrant ssh master-1 -c "sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' ~/.profile" > /dev/null && echo "INFO: tty fixed"


