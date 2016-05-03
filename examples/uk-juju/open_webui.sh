#!/usr/bin/env bash

juju ssh pintostack/0 sudo docker exec pintostack-container /bin/sh -c "\"cd /pintostack; ./open_webui.sh\""
