#!/bin/bash
set -e

cd versions
versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
    versions=( */ )
fi
versions=( "${versions[@]%/}" )
cd ..

function version {
    echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'
}

for version in "${versions[@]}"; do
    echo "Updating $version"
    (
        set -x
        rm -rf versions/$version/*
        cp -r README.md template/* versions/$version/
        sed -i '' -e 's/{{ version }}/'$version'/g' versions/$version/Dockerfile
        if [ $(version $version) -ge $(version "7.4") ]; then
            sed -i '' -e 's|-dir=/usr/include/||g' versions/$version/Dockerfile
        fi
    )
done
