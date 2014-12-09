FROM debian:squeeze
MAINTAINER Helder Correia <me@heldercorreia.com>

# This OS comes with a new autoconf tool version, which is
# not compatible with PHP, that’s why for successful compilation
# you need to temporarily install autoconf2.13 package.
RUN apt-get update \
    && apt-get install -y \
        autoconf2.13 \
        libbz2-dev \
        libcurl4-openssl-dev \
        libltdl-dev \
        libmcrypt-dev \
        libevent-dev \
        libmhash-dev \
        libmysqlclient-dev \
        libpcre3-dev \
        libpng12-dev \
        libxml2-dev \
        make \
        patch \
        xmlstarlet \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download PHP 5.2.16, Suhosin patch, PHP-FPM patch
#  - http://museum.php.net/php5/php-5.2.16.tar.bz2
#  - http://download.suhosin.org/suhosin-patch-5.2.16-0.9.7.patch.gz
#  - http://php-fpm.org/downloads/php-5.2.16-fpm-0.5.14.diff.gz
ADD tmp/ /tmp
RUN gunzip /tmp/*.gz && tar xf /tmp/php-5.2.16.tar -C /tmp
WORKDIR /tmp/php-5.2.16

# Apply patches
RUN patch -p1 -i ../php-5.2.16-fpm-0.5.14.diff && \
    patch -p1 -i ../suhosin-patch-5.2.16-0.9.7.patch

# Configure
RUN ./buildconf --force
RUN ./configure \
    --enable-fastcgi \
    --enable-fpm \
    --enable-mbstring \
    --enable-sockets \
    --with-config-file-path=/etc/php \
    --with-curl \
    --with-fpm-conf=/etc/php/php-fpm.conf \
    --with-fpm-log=/var/log/php/php_errors.log \
    --with-fpm-pid=/var/run/php/php-fpm.pid \
    --with-gd \
    --with-gettext \
    --with-libdir \
    --with-libdir=lib64 \
    --with-mcrypt \
    --with-mhash \
    --with-mysql \
    --with-mysql-sock \
    --with-mysqli \
    --with-openssl \
    --with-pcre-regex \
    --with-png-dir \
    --with-zlib \
    --without-sqlite

# Install
RUN make && make install

# Uninstall autoconf2.13 after compilation.
RUN apt-get remove -y autoconf2.13

# Clean up
RUN rm -rf /tmp/* /var/tmp/*

# Get out of /tmp
WORKDIR /

# Add entrypoint
COPY init.sh /init
ENTRYPOINT ["/init"]

# Run php-fpm
EXPOSE 9000
CMD ["php-cgi", "--fpm"]
