# Docker image running PHP-FPM

This image adds common things that I usually need to the official [php (fpm)](https://registry.hub.docker.com/_/php/) image. See that repo for basic usage.


## What was added?

### Extensions

* **PHP**
    * gd
    * mbstring
    * mcrypt
    * mysqli
    * pdo_mysql
    * zip

* **PECL**
    * uploadprogress (1.0.3.1)

### Tooling

* Composer (1.0.0-alpha10)

### Scripts

See the Dockerfile for examples on how to use these.

* `apt-install`: installs packages and cleans up afterwards
* `apt-purge`: uninstalls packages
* `docker-php-pecl-install`: uses `pecl install <package>` but adds the `extension.ini` file for you automatically and cleans up afterwards

### Configuration

#### /usr/local/etc/php/php.ini

Added some common options. Notice I've set `date.timezone = Atlantic/Azores`, so you may want to change that.

#### /usr/local/etc/php/conf.d/environment.ini

Copy of `production.ini`:

* `/usr/local/etc/php/production.ini`: production settings
* `/usr/local/etc/php/development.ini`: development settings

To use development settings, in your Dockerfile:

    RUN cd /usr/local/etc/php && cp development.ini conf.d/environment.ini

Or use your own.

#### /usr/local/etc/php-fpm.conf

* Changed process manager to `ondemand`;
* Added `include=/usr/local/etc/fpm.d/*.conf`, so you can add files with FPM configs;
* Added `catch_workers_output = yes` (otherwise couldn't get errors to show up);
