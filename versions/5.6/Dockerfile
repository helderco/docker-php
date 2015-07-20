FROM php:5.6-fpm
MAINTAINER Helder Correia <me@heldercorreia.com>

# Add configs
COPY bin/* /usr/local/bin/
COPY etc/*.ini /usr/local/etc/php/
RUN cd /usr/local/etc/php && cp production.ini conf.d/environment.ini
RUN sed -i \
        -e "s/^pm = dynamic/pm = ondemand/" \
        -e "\$a\\" \
        -e "catch_workers_output = yes\n" \
      /usr/local/etc/php-fpm.conf


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
