#!/bin/bash

: ${DEV_LOG_TARGET:=/var/run/rsyslog/dev/log}

# Use rsyslog socket if available
if [ -S "$DEV_LOG_TARGET" ]; then
    ln -sf "$DEV_LOG_TARGET" /dev/log
fi
