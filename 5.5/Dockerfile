FROM php:5.5-fpm

# Install dependencies (git is needed for some packages in composer)
RUN apt-get update \
    && apt-get install -y git zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install needed extensions
RUN docker-php-ext-install mysqli pdo_mysql zip

# Tweak php-fpm.conf a bit
RUN sed -i -e "s/^pm = dynamic/pm = ondemand/" /usr/local/etc/php-fpm.conf

# Add own php.ini
COPY php.ini /usr/local/lib/

# Add composer globally
RUN set -x \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer
