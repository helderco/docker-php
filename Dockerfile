FROM debian:jessie
MAINTAINER Helder Correia <me@heldercorreia.com>

# Get PHP 5.5
ADD http://php.net/get/php-5.5.16.tar.bz2/from/this/mirror /tmp/php-5.5.16.tar.bz2

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        bzip2 \
        libbz2-dev \
        libc-client-dev \
        libcurl4-openssl-dev \
        libfreetype6-dev \
        libicu-dev \
        libjpeg-dev \
        libltdl-dev \
        libmcrypt-dev \
        libmhash-dev \
        libmysqlclient-dev \
        libpcre3-dev \
        libpng-dev \
        libpng12-dev \
        libreadline-dev \
        libssl-dev \
        libxml2-dev \
        libxpm-dev \
        make \
        mcrypt \
    && apt-get clean

# Install PHP
RUN tar xjf /tmp/php-5.5.16.tar.bz2 -C /tmp && \
    cd /tmp/php-5.5.16 && \
    ./configure \
        --enable-bcmath \
        --enable-calendar \
        --enable-exif \
        --enable-fpm \
        --enable-ftp \
        --enable-gd-native-ttf \
        --enable-libxml \
        --enable-mbstring \
        --enable-opcache \
        --enable-pcntl \
        --enable-soap \
        --enable-sockets \
        --enable-wddx \
        --enable-zip \
        --with-bz2 \
        --with-config-file-path=/etc/php5 \
        --with-config-file-scan-dir=/etc/php5/conf.d \
        --with-curl \
        --with-fpm-group=www-data \
        --with-fpm-user=www-data \
        --with-gd \
        --with-gettext \
        --with-jpeg-dir \
        --with-libdir=/lib/x86_64-linux-gnu \
        --with-mcrypt \
        --with-mhash \
        --with-mysql \
        --with-mysql-sock \
        --with-mysqli \
        --with-openssl \
        --with-pcre-regex \
        --with-pdo-mysql \
        --with-pdo-sqlite \
        --with-png-dir \
        --with-readline \
        --with-zlib \
    && make && make install \
    && mkdir -p /etc/php5/conf.d \
    && cp php.ini-production /etc/php5/php.ini  \
    && cp /usr/local/etc/php-fpm.conf.default /etc/php5/php-fpm.conf \
    && rm -rf /tmp/* /var/tmp/*

# Tweak config a bit
RUN sed -i -e "s/^listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/" /etc/php5/php-fpm.conf && \
    sed -i -e "s/^;daemonize = yes/daemonize = no/" /etc/php5/php-fpm.conf && \
    sed -i -e "s/^pm = dynamic/pm = ondemand/" /etc/php5/php-fpm.conf && \
    sed -i -e "s|^;error_log = php_errors.log|error_log = /var/log/php_errors.log|" /etc/php5/php.ini

# Run php-fpm
EXPOSE 9000

CMD ["php-fpm", "--fpm-config", "/etc/php5/php-fpm.conf"]
