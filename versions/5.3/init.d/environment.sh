#!/bin/bash
set -e

PREFIX=/usr/local/etc/php

if [ -f "$PREFIX/$ENVIRONMENT.ini" ]; then
    cp $PREFIX/$ENVIRONMENT.ini $PREFIX/conf.d/environment.ini
fi
