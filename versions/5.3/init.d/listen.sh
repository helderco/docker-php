#!/bin/bash
set -e

# Enable listen override
if [ "$LISTEN_ADDRESS" ]; then
    if [[ "$LISTEN_ADDRESS" == *.sock ]]; then
        : ${LISTEN_MODE:=0666}
        sed -i -e "s|^listen.*|listen = $LISTEN_ADDRESS\nlisten.mode = $LISTEN_MODE|" /usr/local/etc/php-fpm.d/zz-docker.conf
    else
        sed -i -e "s|^listen.*|listen = $LISTEN_ADDRESS|" /usr/local/etc/php-fpm.d/zz-docker.conf
    fi
fi
