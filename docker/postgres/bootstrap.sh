#!/usr/bin/env bash

/usr/lib/postgresql/9.3/bin/postgres -p $PORT0 -D /var/lib/postgresql/9.3/main -c config_file=/etc/postgresql/9.3/main/postgresql.conf
