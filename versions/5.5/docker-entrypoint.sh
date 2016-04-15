#!/bin/bash
set -e

for f in /docker-entrypoint-init.d/*.sh; do
    . "$f"
done

exec "$@"
