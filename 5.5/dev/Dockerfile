FROM helder/php-5.5
MAINTAINER Helder Correia <me@heldercorreia.com>

RUN cd /usr/local/etc/php && cp development.ini conf.d/environment.ini
RUN usermod -u 1000 www-data
