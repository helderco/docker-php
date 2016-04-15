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
      -e '/pecl-install xdebug/ a\
        \ \ \ \ echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20090626/xdebug.so" > /usr/local/etc/php/conf.d/docker-php-pecl-xdebug.ini && \\ \' \
      -e 's/\(ENV XDEBUG_VERSION\) .*/\1 2.2.7/g' \
    versions/5.3/Dockerfile
  cp fpm-env.sh versions/5.3/init.d/
)
