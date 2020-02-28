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
    if [[ $version == 7.* ]]; then
      sed -i '' -e '/uploadprogress/ s/^#*/#/' versions/$version/Dockerfile
      sed -i '' -e 's/\(ENV XDEBUG_VERSION\) .*/\1 2.9.1/g' versions/$version/Dockerfile
      sed -i '' -e 's/libpng12-dev/libpng-dev/g' -e '/mcrypt/ d'  versions/$version/Dockerfile
      sed -i '' -e '/; track_errors/ { N;N;N;N;N;d; }' versions/$version/etc/php/{dev,prod}.ini
    fi
done

echo "Fix PHP 5.3"
(
  set -x;
  sed -i '' \
      -e '1s|.*|FROM helder/php-5.3|' \
      -e '/--with-freetype-dir/i\
        \  && mkdir /usr/include/freetype2/freetype \\ \
        \  && ln -s /usr/include/freetype2/freetype.h /usr/include/freetype2/freetype/freetype.h \\' \
      -e 's/\(ENV XDEBUG_VERSION\) .*/\1 2.2.7/g' \
    versions/5.3/Dockerfile
  cp fpm-env.sh versions/5.3/init.d/
)
