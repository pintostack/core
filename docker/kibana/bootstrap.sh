#!/bin/bash
#Print environment
env

/kibana/bin/kibana --host 0.0.0.0 --port $PORT0 --elasticsearch "http://elasticsearch.service.consul:31000"
