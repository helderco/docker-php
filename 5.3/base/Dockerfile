FROM debian:jessie
MAINTAINER Helder Correia <me@heldercorreia.com>

# Based on official repo when PHP 5.3 was dropped:
# https://github.com/docker-library/php/commit/8814c6a7888ffa521de4d8d06454e29992b87dc7

RUN apt-get update && apt-get install -y \
        autoconf \
        build-essential \
        ca-certificates \
        curl \
        imagemagick \
        libbz2-dev \
        libcurl4-openssl-dev \
        libevent-dev \
        libffi-dev \
        libglib2.0-dev \
        libjpeg-dev \
        liblzma-dev \
        libmagickcore-dev \
        libmagickwand-dev \
        libmysqlclient-dev \
        libncurses-dev \
        libpq-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        libxml2-dev \
        libxslt-dev \
        libyaml-dev \
        zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV PHP_VERSION 5.3.29
ENV PHP_INI_DIR /usr/local/etc/php

RUN gpg --keyserver pgp.mit.edu --recv-keys 0B96609E270F565C13292B24C13C70B87267B52D 0A95E9A026542D53835E3F3A7DEC4E69FC9C83D7

# php 5.3 needs older autoconf
RUN set -x \
    && apt-get update && apt-get install -y autoconf2.13 && apt-get clean && rm -r /var/lib/apt/lists/* \
    && curl -SLO http://launchpadlibrarian.net/140087283/libbison-dev_2.7.1.dfsg-1_amd64.deb \
    && curl -SLO http://launchpadlibrarian.net/140087282/bison_2.7.1.dfsg-1_amd64.deb \
    && dpkg -i libbison-dev_2.7.1.dfsg-1_amd64.deb \
    && dpkg -i bison_2.7.1.dfsg-1_amd64.deb \
    && rm *.deb \
    && curl -SL "http://php.net/get/php-$PHP_VERSION.tar.bz2/from/this/mirror" -o php.tar.bz2 \
    && curl -SL "http://php.net/get/php-$PHP_VERSION.tar.bz2.asc/from/this/mirror" -o php.tar.bz2.asc \
    && gpg --verify php.tar.bz2.asc \
    && mkdir -p /usr/src/php \
    && tar -xf php.tar.bz2 -C /usr/src/php --strip-components=1 \
    && rm php.tar.bz2* \
    && cd /usr/src/php \
    && ./buildconf --force \
    && ./configure --disable-cgi \
        --with-config-file-path="$PHP_INI_DIR" \
        --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
        --enable-mbstring \
        --enable-fpm \
        --with-fpm-user=www-data \
        --with-fpm-group=www-data \
        --with-curl \
        --with-gd \
        --with-mysql \
        --with-mysqli \
        --with-pdo-mysql \
        --with-pcre \
        --with-png-dir \
        --with-zlib \
    && make -j"$(nproc)" \
    && make install \
    && dpkg -r bison libbison-dev \
    && apt-get purge -y --auto-remove autoconf2.13 \
    && rm -r /usr/src/php

WORKDIR /var/www/html
COPY php-fpm.conf /usr/local/etc/

EXPOSE 9000
CMD ["php-fpm"]


COPY bin/* /usr/local/bin/
COPY etc/*.ini /usr/local/etc/php/
RUN cd /usr/local/etc/php && cp production.ini conf.d/environment.ini
