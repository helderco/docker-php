FROM helder/php-5.6-base
MAINTAINER Helder Correia <me@heldercorreia.com>

RUN apt-install \
      libfreetype6-dev \
      libjpeg62-turbo-dev \
      libmcrypt-dev \
      libpng12-dev

RUN docker-php-ext-install \
        mcrypt \
        pdo_mysql \
        mbstring \
 && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
 && docker-php-ext-install gd

RUN docker-php-pecl-install uploadprogress-1.0.3.1
