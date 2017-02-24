#!/bin/bash
set -e

CONF=/usr/local/etc/php-fpm.d/zz-docker.conf

# Enable listen override
if [ "$LISTEN_ADDRESS" ]; then
    sed -i -e "s|^listen =.*|listen = $LISTEN_ADDRESS|" $CONF

    if [[ "$LISTEN_ADDRESS" == *.sock ]]; then
        : ${LISTEN_MODE:=0666}
        grep -q listen.mode $CONF && sed -i -e "s|^listen.mode =.*|listen.mode = $LISTEN_MODE|" $CONF || echo "listen.mode = $LISTEN_MODE" >> $CONF
    fi
fi
