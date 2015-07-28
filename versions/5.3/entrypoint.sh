#!/bin/bash
set -e

: ${DEV_LOG_TARGET:=/var/run/rsyslog/dev/log}

# Use rsyslog socket if available
if [ -S "$DEV_LOG_TARGET" ]; then
    ln -sf "$DEV_LOG_TARGET" /dev/log
fi

# PHP 5.3 does not have "clear_env = no", so we need to copy the environment to php-fpm.conf 
# (see https://github.com/docker-library/php/issues/74). 
env | sed "s/\(.*\)=\(.*\)/env[\1]='\2'/" > /usr/local/etc/fpm.d/env.conf 

exec "$@"
