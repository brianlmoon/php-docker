# PHP

This is an image based on the official PHP image with some additions.

## Extensions

Several commonly used extensions are added. The list includes but is not limited to mysql, pgsql, memcached, yaml, pdo, opcache, xhprof, and others. See the Dockerfile or composer.json for a complete list of extensions.

## PHP User

A non-system user is created to run PHP and is the default user for the image. The username defaults to `php` and can be set with the build argument `STDUSER`.

## Timezone

The timezone is explicitly set and defaults to UTC. It can be changed at build time by setting the build argument `TIMEZONE`.

## Dockerize

[Dockerize](https://github.com/jwilder/dockerize) is installed to allow for using environment variables in config files.

## Composer

The latest version of composer is installed at the time of building.

## SSTMP

SSTMP is installed to allow for sending mail inside the container. The config file uses environment variables.

`SMTP_ROOT_ADDRESS`
The user that gets all the mails (UID < 1000, usually the admin)

`SMTP_HOST`
The mail server (where the mail is sent to), both port 465 or 587 should be acceptable. See also http://mail.google.com/support/bin/answer.py?answer=78799

`REWRITE_DOMAIN`
The address where the mail appears to come from for user authentication.

`FQDN`
The full hostname

`USE_TLS`
Use SSL/TLS

`USE_START_TLS`
Use SSL/TLS before starting negotiation

`FROM_LINE_OVERRIDE`
Email 'From header's can override the default domain?

`AUTH_USER`, `AUTH_PASS`, `AUTH_METHOD`
SMTP Auth settings
