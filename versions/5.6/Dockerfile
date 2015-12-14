FROM php:5.6-fpm
MAINTAINER Helder Correia <me@heldercorreia.com>

COPY bin/* /usr/local/bin/


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

RUN docker-php-pecl-install uploadprogress

RUN apt-install zlib1g-dev libicu-dev g++ && \
    docker-php-ext-configure intl && \
    docker-php-ext-install intl && \
    apt-purge g++


# Include composer
RUN apt-install git zlib1g-dev && \
    docker-php-ext-install zip

ENV COMPOSER_HOME /root/composer
ENV COMPOSER_VERSION 1.0.0-alpha11
ENV PATH vendor/bin:$COMPOSER_HOME/vendor/bin:$PATH

RUN curl -sS https://getcomposer.org/installer | php -- \
      --install-dir=/usr/local/bin \
      --filename=composer \
      --version=${COMPOSER_VERSION}

VOLUME /root/composer/cache
RUN echo "phar.readonly = off" > /usr/local/etc/php/conf.d/phar.ini


# Add configs
COPY etc/*.ini /usr/local/etc/php/
RUN cd /usr/local/etc/php && cp production.ini conf.d/environment.ini
RUN mkdir -p /usr/local/etc/fpm.d && \
    echo "\ninclude=/usr/local/etc/fpm.d/*.conf" >> /usr/local/etc/php-fpm.conf && \
    sed -i -e "s/^pm = dynamic/pm = ondemand/" /usr/local/etc/php-fpm.conf


# Add entrypoint
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]
