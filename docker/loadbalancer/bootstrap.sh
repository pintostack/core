#!/usr/bin/env bash
CONSUL_URL="http://consul.service.consul:8300"
JSON_CACHE="/files/json-cache"
CONSUL_SERVICE_NAME="redis"
HTTP_VHOST_NAME="default"
REFRESH=30
NGNX_HTTP_PORT=$PORT_0
mkdir -p ${JSON_CACHE}/last
mkdir -p ${JSON_CACHE}/running
rm -f /etc/nginx/sites-enabled/default

touch ${JSON_CACHE}/running/${HTTP_VHOST_NAME}-consul.json
while true; do
#Get data from consul
curl -s ${CONSUL_URL}/v1/catalog/service/$CONSUL_SERVICE_NAME > ${JSON_CACHE}/last/${HTTP_VHOST_NAME}-consul.json
#If data changed
RUNNING_MD5=$(md5sum ${JSON_CACHE}/running/${HTTP_VHOST_NAME}-consul.json)
LAST_MD5=$(md5sum ${JSON_CACHE}/last/${HTTP_VHOST_NAME}-consul.json)
if ["x$RUNNING_MD5" != "x$LAST_MD5"]; then
    ## move last to runing nginx has a symlink to it
    if [ -d ${JSON_CACHE}/running.bak ]; then
    	rm -rf ${JSON_CACHE}/running.bak
    fi
    mv ${JSON_CACHE}/running ${JSON_CACHE}/running.bak
    mv ${JSON_CACHE}/last ${JSON_CACHE}/running
    ## Generate new configs with update-ngnx-form.consul.py
    update-ngnx-form.consul.py
    if [ $? ]; then
	## Notify nginx
        /etc/init.d/nginx status
        if [ $? ]; then
		  /etc/init.d/nginx reload
        else
            /etc/init.d/nginx start
        fi
	else
		rm -rf ${JSON_CACHE}/running ${JSON_CACHE}/running
		mv ${JSON_CACHE}/running ${JSON_CACHE}/running.bak ${JSON_CACHE}/running ${JSON_CACHE}/running
        update-ngnx-form.consul.py
	fi
else
	#remove last
	mkdir -p ${JSON_CACHE}/last/
fi
## Notify nginx
sleep $REFRESH
# wait n -time do it onceagain
done