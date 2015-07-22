FROM php:5.5-fpm
MAINTAINER Helder Correia <me@heldercorreia.com>

COPY bin/* /usr/local/bin/


# Include composer
RUN apt-install git zlib1g-dev && \
    docker-php-ext-install zip

ENV COMPOSER_HOME /root/composer
ENV COMPOSER_VERSION 1.0.0-alpha10
ENV PATH vendor/bin:$COMPOSER_HOME/vendor/bin:$PATH

RUN curl -sS https://getcomposer.org/installer | php -- \
      --install-dir=/usr/local/bin \
      --filename=composer \
      --version=${COMPOSER_VERSION}

VOLUME /root/composer/cache
RUN echo "phar.readonly = off" > /usr/local/etc/php/conf.d/phar.ini


# Install useful extensions
RUN apt-install \
      libfreetype6-dev \
      libjpeg62-turbo-dev \
      libmcrypt-dev \
      libpng12-dev \
  && docker-php-ext-install \
      mcrypt \
      mysqli \
      pdo_mysql \
      mbstring \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install gd

RUN docker-php-pecl-install uploadprogress-1.0.3.1


# Add configs
COPY etc/*.ini /usr/local/etc/php/
RUN cd /usr/local/etc/php && cp production.ini conf.d/environment.ini
RUN mkdir -p /usr/local/etc/fpm.d && \
    echo "catch_workers_output = yes" > /usr/local/etc/fpm.d/logging.conf && \
    echo "\ninclude=/usr/local/etc/fpm.d/*.conf" >> /usr/local/etc/php-fpm.conf && \
    sed -i -e "s/^pm = dynamic/pm = ondemand/" /usr/local/etc/php-fpm.conf
