FROM php:5.6-fpm

COPY bin/* /usr/local/bin/
COPY etc/production.ini /usr/local/etc/php/conf.d/environment.ini

RUN sed -i -e "s/^pm = dynamic/pm = ondemand/" /usr/local/etc/php-fpm.conf
RUN docker-php-pecl-install uploadprogress-1.0.3.1


# <composer>

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

# </composer>


COPY etc/php.ini /usr/local/etc/php/php.ini
