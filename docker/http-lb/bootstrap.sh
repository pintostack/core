#!/usr/bin/env bash
CONSUL_URL="http://consul.service.consul:8500"
JSON_CACHE="/files/json-cache"
CONSUL_SERVICE_NAME="${BACKEND_SERVICE_NAME}"
HTTP_VHOST_NAME="default"
DEBUG="false"
REFRESH=30
NGNX_HTTP_PORT=${PORT0}
$DEBUG && echo "$NGNX_HTTP_PORT"
# create zero conf
mkdir -p ${JSON_CACHE}/running
touch ${JSON_CACHE}/running/${HTTP_VHOST_NAME}-consul.json

rm -f /etc/nginx/sites-enabled/default
while true; do
# Get data from consul
mkdir -p ${JSON_CACHE}/last/
curl -s ${CONSUL_URL}/v1/catalog/service/$CONSUL_SERVICE_NAME > ${JSON_CACHE}/last/${HTTP_VHOST_NAME}-consul.json
# If data changed
$DEBUG && echo "JSON-last"
$DEBUG && cat ${JSON_CACHE}/last/${HTTP_VHOST_NAME}-consul.json
$DEBUG && echo ""
RUNNING_MD5=$(md5sum ${JSON_CACHE}/running/${HTTP_VHOST_NAME}-consul.json | cut -f1 -d' ')
LAST_MD5=$(md5sum ${JSON_CACHE}/last/${HTTP_VHOST_NAME}-consul.json | cut -f1 -d' ')
if [ "x$RUNNING_MD5" != "x$LAST_MD5" ]; then
    ## move last to runing nginx has a symlink to it
    $DEBUG && echo "Service discovery information changed"
    $DEBUG && echo "JSON-last RUNNING: $RUNNING_MD5 LAST: $LAST_MD5"
    $DEBUG && cat ${JSON_CACHE}/last/${HTTP_VHOST_NAME}-consul.json
    $DEBUG && echo ""
    if [ -d ${JSON_CACHE}/running.bak ]; then
    	rm -rf ${JSON_CACHE}/running.bak
    fi
    mv ${JSON_CACHE}/running ${JSON_CACHE}/running.bak
    mv ${JSON_CACHE}/last ${JSON_CACHE}/running
    ## Generate new configs with update-ngnx-form.consul.py
    /files/update-ngnx-form.consul.py $NGNX_HTTP_PORT
    if [ $? ]; then
	## Notify nginx
        /etc/init.d/nginx status
        if [ $? ]; then
          $DEBUG && echo "Nginx is not running, fixing..."
          /etc/init.d/nginx stop
          sleep 5
          /etc/init.d/nginx start
        else
          $DEBUG && echo "Gracefully reloading nginx..."
          /etc/init.d/nginx reload
        fi
	else
        $DEBUG && echo "No changes detected..."
		rm -rf ${JSON_CACHE}/running ${JSON_CACHE}/running
		mv ${JSON_CACHE}/running ${JSON_CACHE}/running.bak ${JSON_CACHE}/running ${JSON_CACHE}/running
        /files/update-ngnx-form.consul.py $NGNX_HTTP_PORT
	fi
else
	#remove last
    rm -rf ${JSON_CACHE}/last/*
	mkdir -p ${JSON_CACHE}/last/
fi
## Notify nginx
sleep $REFRESH
# wait n -time do it onceagain
done
