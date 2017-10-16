# Docker image running PHP-FPM

This image adds common things that I usually need to the official [php (fpm)](https://registry.hub.docker.com/_/php/) image. See that repo for basic usage.


## What was added?

### Extensions

* **PHP**
    * gd
    * intl
    * mbstring
    * mcrypt
    * mysqli
    * pdo_mysql
    * zip

* **PECL**
    * uploadprogress
    * xdebug (disabled by default)

### Tooling

* gosu
* ssmtp
* composer
* git
* rsync

### Scripts

See the Dockerfile for examples on how to use these:

* `apt-install`: installs packages and cleans up afterwards
* `apt-purge`: uninstalls packages
* `docker-php-pecl-install`: uses `pecl install <package>` but adds the `extension.ini` file for you automatically and cleans up afterwards

### Configuration

#### /usr/local/etc/php/php.ini

Added some common options.

#### /usr/local/etc/php/conf.d/environment.ini

Copy of `prod.ini`:

* `/usr/local/etc/php/prod.ini`: production settings
* `/usr/local/etc/php/dev.ini`: development settings

To use development settings, set `ENVIRONMENT=dev`.

#### /usr/local/etc/php-fpm.d/*.conf

* Changed process manager to `ondemand`;
* Silenced access logs;


### Entrypoint features

The entrypoint runs scripts in `/docker-entrypoint-init.d/*.sh`. Add your own init scripts there or remove existing ones.

#### Development settings

Use `ENVIRONMENT=dev` for development settings (in php.ini).

#### UID and GID mapping

When mounting a volume from the host to a container, the container sees the host's owner for the files, even if it doesn't exist in the container. This image has a feature that allows setting an environment variable (`MAP_WWW_UID`) to use a directory and get www-data to have the same uid and gid as the owner of that directory. It defaults to the current working dir, or set to `no` to disable.

This is useful for example if you're using some tooling in the container to generate files inside the host volume. If this is not used, the host will have files with `uid=33 gid=33` or `uid=0 gid=0`, depending if you're using the www-data user or root.

Note that the container must be run as root, for the permission to change the www-data uid and gid.
Use `gosu` to run a command as www-data in order to use the mapped ownership.

    $ # by default the current dir is used to change www-data's uid
    $ docker run -it --rm -v $PWD:/usr/src/app -w /usr/src/app helder/php gosu www-data id
    uid=1000(www-data) gid=1000(www-data) groups=1000(www-data)

    $ # but you can specify another one
    $ docker run -it --rm -e MAP_WWW_UID=/data -v $PWD:/data helder/php gosu www-data id
    uid=1000(www-data) gid=1000(www-data) groups=1000(www-data)

    $ # or disable it by setting MAP_WWW_UID=no
    $ docker run -it --rm -e MAP_WWW_UID=no -v $PWD:/data -w /data helder/php gosu www-data id
    uid=33(www-data) gid=33(www-data) groups=33(www-data)


#### Listen

You can change the default listen value by using variables `LISTEN_ADDRESS` and `LISTEN_MODE`. The latter is used only when using a socket, and defaults to the value 0666.

    $ docker run -it --rm helder/php grep listen /usr/local/etc/php-fpm.d/zz-docker.conf
    listen = [::]:9000

    $ docker run -it --rm -e 'LISTEN_ADDRESS=[::]:3000' helder/php grep listen /usr/local/etc/php-fpm.d/zz-docker.conf
    listen = [::]:3000

    $ docker run -it --rm -e LISTEN_ADDRESS=/var/run/project.sock helder/php grep listen /usr/local/etc/php-fpm.d/zz-docker.conf
    listen = /var/run/project.sock
    listen.mode = 0666

#### Syslog

The image comes with an entrypoint that checks for a socket in `/var/run/rsyslog/dev/log`. If it exists, it will symlink `/dev/log` to it. This is useful to send logs to syslog.

    $ docker run -d --name syslog helder/rsyslog
    $ docker run -it --rm --volumes-from syslog helder/php logger -p local1.notice "This is a notice!"
    $ docker logs syslog

If you would like to check for another location, set the environment variable `DEV_LOG_TARGET`.

#### SSMTP and Mailhog

This is a neat feature. By default, this image will send any email to an SMTP host `mail` and
port 1025. So if you use `mailhog/mailhog` and link a container with this image to that, you'll
catch all the emails sent by your application in mailhog.

Run mailhog process:

    docker run -d -p 8025:8025 --name mail mailhog/mailhog

Send email:

    docker run -it --rm --link mail helder/php php -r 'mail("to@address.com", "Test", "Testing!", "From: my@example.com");'

Open your browser at http://localhost:8025 to see your emails.

To use other settings, override in your Dockerfile:

    FROM helder/php
    RUN COPY ssmtp.conf /etc/ssmtp/ssmtp.conf

#### Timezone

The default timezone is set with `TIMEZONE=Atlantic/Azores`. Change it with an environment variable.

#### XDebug

The XDebug extension is installed but disabled by default. To enable, set the enviroment variable `USE_XDEBUG=true`.
