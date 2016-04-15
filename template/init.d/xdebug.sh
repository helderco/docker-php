#!/bin/bash
set -e

# Allow enabling XDebug
if [ "$USE_XDEBUG" = "yes" ]; then
    mv /usr/local/etc/php/disabled/*xdebug.ini /usr/local/etc/php/conf.d/
fi
