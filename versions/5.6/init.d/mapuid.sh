#!/bin/bash
set -e

# Change uid and gid of www-data to match current dir's owner
if [ "$MAP_WWW_UID" != "no" ]; then
    if [ ! -d "$MAP_WWW_UID" ]; then
        MAP_WWW_UID=$PWD
    fi

    uid=$(stat -c '%u' "$MAP_WWW_UID")
    gid=$(stat -c '%g' "$MAP_WWW_UID")

    usermod -u $uid www-data 2> /dev/null && {
      groupmod -g $gid www-data 2> /dev/null || usermod -a -G $gid www-data
    }
fi
