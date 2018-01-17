#!/bin/bash
set -e

# Source docker-entrypoint.sh:
# https://github.com/docker-library/postgres/blob/master/9.4/docker-entrypoint.sh
# https://github.com/kovalyshyn/docker-freeswitch/blob/vanilla/docker-entrypoint.sh

if [ "$1" = 'freeswitch' ]; then
    ARGS=-nonat

    if [ ! -f "/etc/freeswitch/freeswitch.xml" ]; then
        mkdir -p /etc/freeswitch
        cp -varf /usr/share/freeswitch/conf/vanilla/* /etc/freeswitch/
    fi

    chown -R freeswitch:freeswitch /etc/freeswitch
    chown -R freeswitch:freeswitch /var/{run,lib}/freeswitch
    
    if [ -d /docker-entrypoint.d ]; then
        for f in /docker-entrypoint.d/*.sh; do
            [ -f "$f" ] && . "$f"
        done
        [ -f /docker-entrypoint.d/args ] && ARGS=$(cat /docker-entrypoint.d/args)
    fi
    
    exec gosu freeswitch /usr/bin/freeswitch -u freeswitch -g freeswitch -c $ARGS
fi

exec "$@"
