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
      rm -rf versions/$version/*
      cp -r README.md template/* versions/$version/
      sed -i '' -e 's/{{ version }}/'$version'/g' versions/$version/Dockerfile
    )
done

echo "Fix PHP 5.3"
(
  set -x;
  sed -i '' \
      -e '1s|.*|FROM helder/php-5.3|' \
      -e '/--with-freetype-dir/i\
        \  && mkdir /usr/include/freetype2/freetype \\ \
        \  && ln -s /usr/include/freetype2/freetype.h /usr/include/freetype2/freetype/freetype.h \\' \
    versions/5.3/Dockerfile
  sed -i '' \
      -e '/^exec/i\
        \# PHP 5.3 does not have "clear_env = no", so we need to copy the environment to php-fpm.conf \
        \# (see https://github.com/docker-library/php/issues/74). \
        \env | sed "s/\\(.*\\)=\\(.*\\)/env[\\1]='"'"'\\2'"'"'/" > /usr/local/etc/fpm.d/env.conf \
        \' \
    versions/5.3/entrypoint.sh
)
