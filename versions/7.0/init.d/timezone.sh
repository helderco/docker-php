#!/bin/bash
set -e

: ${TIMEZONE:=Atlantic/Azores}

sed -i "s|^;date.timezone =$|date.timezone = $TIMEZONE|" /usr/local/etc/php/php.ini
