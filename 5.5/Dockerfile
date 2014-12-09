FROM php:5.5-fpm

# Install needed extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Tweak php-fpm.conf a bit
RUN sed -i -e "s/^pm = dynamic/pm = ondemand/" /usr/local/etc/php-fpm.conf

# Add own php.ini
COPY php.ini /usr/local/lib/
