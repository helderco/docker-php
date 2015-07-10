#!/bin/bash
set -e

cd versions
versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
    versions=( */ )
fi
versions=( "${versions[@]%/}" )
cd ..

for version in "${versions[@]}"; do
    echo "Updating $version"
    (
      set -x
      rsync -auh --delete template/ versions/$version
      cp README.md versions/$version/
      sed -i '' -e 's/{{ version }}/'$version'/g' versions/$version/Dockerfile
    )
done

echo "Fix PHP 5.3 docker hub repository"
(set -x; sed -i '' -e "s|FROM php:5.3|FROM helder/php-5.3|" versions/5.3/Dockerfile)
