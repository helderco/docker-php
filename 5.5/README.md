# Docker image with PHP 5.5, running PHP-FPM

Create a Dockerfile based on this one to provide your own configs:

```
FROM helder/php:5.5

# Add overrides
RUN echo "date.timezone = Europe/Lisbon" > /usr/local/etc/php.d/overrides.ini

# Or provide your own php-fpm.conf
ADD php-fpm.conf /usr/local/etc/php-fpm.conf
```

See the output following the end of `make install` so you know where the installed files are:

```
Installing shared extensions:     /usr/local/lib/php/extensions/no-debug-non-zts-20121212/
Installing PHP CLI binary:        /usr/local/bin/
Installing PHP CLI man page:      /usr/local/php/man/man1/
Installing PHP FPM binary:        /usr/local/sbin/
Installing PHP FPM config:        /usr/local/etc/
Installing PHP FPM man page:      /usr/local/php/man/man8/
Installing PHP FPM status page:      /usr/local/php/fpm/
Installing PHP CGI binary:        /usr/local/bin/
Installing PHP CGI man page:      /usr/local/php/man/man1/
Installing build environment:     /usr/local/lib/php/build/
Installing header files:          /usr/local/include/php/
Installing helper programs:       /usr/local/bin/
  program: phpize
  program: php-config
Installing man pages:             /usr/local/php/man/man1/
  page: phpize.1
  page: php-config.1
Installing PEAR environment:      /usr/local/lib/php/
[PEAR] Archive_Tar    - installed: 1.3.12
[PEAR] Console_Getopt - installed: 1.3.1
[PEAR] Structures_Graph- installed: 1.0.4
[PEAR] XML_Util       - installed: 1.2.3
[PEAR] PEAR           - installed: 1.9.5
Wrote PEAR system config file at: /usr/local/etc/pear.conf
You may want to add: /usr/local/lib/php to your php.ini include_path
/tmp/php-5.5.16/build/shtool install -c ext/phar/phar.phar /usr/local/bin
ln -s -f /usr/local/bin/phar.phar /usr/local/bin/phar
Installing PDO headers:          /usr/local/include/php/ext/pdo/
```
