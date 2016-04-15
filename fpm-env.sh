#!/bin/bash
set -e

# PHP 5.3 does not have "clear_env = no", so we need to copy the environment to php-fpm.conf
# (see https://github.com/docker-library/php/issues/74).
env | sed "s/\(.*\)=\(.*\)/env[\1]='\2'/" > /usr/local/etc/fpm.d/env.conf
