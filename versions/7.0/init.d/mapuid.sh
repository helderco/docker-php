#!/bin/bash
set -e

# Change uid and gid of www-data so it matches ownership of volume
if [ -d "$MAP_WWW_UID" ]; then
    uid=$(stat -c '%u' "$MAP_WWW_UID")
    gid=$(stat -c '%g' "$MAP_WWW_UID")
    usermod -u $uid www-data 2> /dev/null && {
      groupmod -g $gid www-data 2> /dev/null || usermod -a -G $gid www-data
    }
fi
