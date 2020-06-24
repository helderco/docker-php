FROM php:{{ version }}-fpm
LABEL maintainer="helder"

COPY bin/* /usr/local/bin/
RUN mkdir -p /usr/local/etc/php/disabled

# Install useful extensions
RUN apt-install \
      libonig-dev \
      libfreetype6-dev \
      libjpeg62-turbo-dev \
      libpng-dev \
      imagemagick \
      ghostscript \
  && docker-php-ext-install \
      mysqli \
      pdo_mysql \
      mbstring \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install gd

RUN apt-install zlib1g-dev libicu-dev g++ && \
    docker-php-ext-configure intl && \
    docker-php-ext-install intl && \
    apt-purge g++

ENV USE_XDEBUG no
ENV XDEBUG_VERSION 2.9.1
RUN docker-php-pecl-install xdebug-$XDEBUG_VERSION && \
    echo "xdebug.remote_enable=on\nxdebug.remote_connect_back=on" > /usr/local/etc/php/conf.d/xdebug.ini && \
    mkdir -p /usr/local/etc/php/xdebug.d && \
    mv /usr/local/etc/php/conf.d/*xdebug.ini /usr/local/etc/php/xdebug.d/


# Use MSMTP
RUN apt-install msmtp && \
    echo "sendmail_path = /usr/bin/msmtp -t --read-envelope-from" > /usr/local/etc/php/conf.d/sendmail.ini
COPY etc/msmtprc /etc/msmtprc
RUN chown :msmtp /etc/msmtprc && \
    chmod 640 /etc/msmtprc


# Grab gosu for easy step-down from root
ENV GOSU_VERSION 1.11
RUN set -x \
  && curl -sSLo /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
  && chmod +x /usr/local/bin/gosu \
  && gosu nobody true


# Include composer
RUN apt-install git rsync unzip zlib1g-dev libzip-dev && \
    docker-php-ext-install zip

ENV COMPOSER_VERSION 1.9.3
ENV COMPOSER_HOME /var/www/.composer
ENV PATH vendor/bin:$COMPOSER_HOME/vendor/bin:$PATH

RUN curl -sS https://getcomposer.org/installer | php -- \
      --install-dir=/usr/local/bin \
      --filename=composer \
      --version=${COMPOSER_VERSION}

RUN mkdir -p $COMPOSER_HOME/cache && \
    chown -R www-data:www-data /var/www && \
    echo "phar.readonly = off" > /usr/local/etc/php/conf.d/phar.ini
VOLUME $COMPOSER_HOME/cache


# Add configs
COPY etc/php/* /usr/local/etc/php/
RUN cd /usr/local/etc/php && cp prod.ini conf.d/environment.ini
RUN sed -i -e '/^access.log/ s/^/;/' /usr/local/etc/php-fpm.d/docker.conf && \
    sed -i -e '/^listen =/ s/^/;/' /usr/local/etc/php-fpm.d/www.conf && \
    sed -i -e "s/^pm = dynamic/pm = ondemand/" /usr/local/etc/php-fpm.d/www.conf


# Add entrypoint
COPY init.d /docker-entrypoint-init.d/
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["php-fpm"]
