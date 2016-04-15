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
    * xdebug (disabled by default)

* **PECL**
    * uploadprogress

### Tooling

* gosu
* Composer (1.0.0)

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


### Entrypoint features

The entrypoint runs scripts in `/docker-entrypoint-init.d/*.sh`. Add your own init scripts there or remove existing ones.

#### UID and GID mapping

When mounting a volume from the host to a container, the container sees the host's owner for the files, even if it doesn't exist in the container. This image has a feature that allows setting an environment variable (`MAP_WWW_UID`) to use a directory and get www-data to have the same uid and gid as the owner of that directory.

This is useful for example if you're using some tooling in the container to generate files inside the host volume. If this is not used, the host will have files with `uid=33 gid=33` or `uid=0 gid=0`, depending if you're using the www-data user or root.

Note that the container must be run as root, for the permission to change the www-data uid and gid.
Use `gosu` to run a command as www-data in order to use the mapped ownership.

    $ # default behavior
    $ docker run -it --rm helder/php gosu www-data id
    uid=33(www-data) gid=33(www-data) groups=33(www-data)

    $ # use a host volume to change www-data's uid
    $ docker run -it --rm -e MAP_WWW_UID=/usr/src/app -v $PWD:/usr/src/app helder/php gosu www-data id
    uid=501(www-data) gid=33(www-data) groups=33(www-data),20(dialout)

Notice that in a Mac, since the default group is `20(staff)`, it matches an already existing group in the container (`20(dialout)`). In that case, we can't change www-data's gid, so it gets added as a secondary group.

In GNU/Linux you should have something like:

    $ docker run -it --rm -e MAP_WWW_UID=/usr/src/app -v $PWD:/usr/src/app helder/php gosu www-data id
    uid=1000(www-data) gid=1000(www-data) groups=1000(www-data)

Now, if you create a file with www-data in the container to the host volume, the host should have the correct owner set.

#### Syslog

The image comes with an entrypoint that checks for a socket in `/var/run/rsyslog/dev/log`. If it exists, it will symlink `/dev/log` to it. This is useful to send logs to syslog.

    $ docker run -d --name syslog helder/rsyslog
    $ docker run -it --rm --volumes-from syslog helder/php logger -p local1.notice "This is a notice!"
    $ docker logs syslog

If you would like to check for another location, set the environment variable `DEV_LOG_TARGET`.

#### XDebug

The XDebug extension is installed but disabled by default. To enable, set the enviroment variable `USE_XDEBUG=true`.
