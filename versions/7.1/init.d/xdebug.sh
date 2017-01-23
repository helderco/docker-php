#!/bin/bash
set -e

# Enable/disable xdebug
if [ "$USE_XDEBUG" = "yes" ]; then
    cp -n /usr/local/etc/php/xdebug.d/* /usr/local/etc/php/conf.d/
else
    find /usr/local/etc/php/conf.d -name '*xdebug*' -delete
fi
