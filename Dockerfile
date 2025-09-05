ARG BASEIMAGE=8-fpm-alpine
FROM php:$BASEIMAGE AS base

ARG TIMEZONE=UTC
ARG STDUSER=php
ARG STDUID=1000
ARG STDGID=1000

# Set time zone
RUN apk add --update alpine-conf tzdata && \
    cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime && \
    echo $TIMEZONE > /etc/timezone && \
    apk del alpine-conf tzdata

# Add php user and group
RUN addgroup -S -g $STDGID $STDUSER && \
    adduser -S -u $STDUID -h /home/$STDUSER -s /bin/sh -G $STDUSER $STDUSER

COPY --from=mlocati/php-extension-installer \
    /usr/bin/install-php-extensions \
    /usr/local/bin/

RUN apk add --no-cache \
        # busybox gzip does not act right
        gzip \
        # For sending mail from PHP
        ssmtp \
        # Sometimes you need an editor in a container
        nano \
        # composer needs these
        git \
        zip \
        unzip \
        # Install bash and coreutils to make scripting easier
        bash \
        coreutils

# ANY PHP EXTENSIONS ADDED TO THIS LIST
# SHOULD BE ADDED TO THE COMPOSER.JSON FILE
# TO ENSURE THE BUILD WORKED!!!!
RUN install-php-extensions \
    bcmath \
    bz2 \
    gd \
    gmp \
    igbinary \
    memcached \
    mysqli \
    oauth \
    opcache \
    pcntl \
    pdo_mysql \
    pdo_pgsql \
    pgsql \
    soap \
    sockets \
    tidy \
    xhprof \
    yaml \
    zip

# Install Dockerize used in the entrypoint
ENV DOCKERIZE_VERSION=v0.8.0
RUN curl -L -O https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Set entrypoint and unset CMD
COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD []

# Copy ssmtp config file
COPY etc/ssmtp.conf.tmpl /etc/ssmtp/
RUN rm /etc/ssmtp/ssmtp.conf && chmod 777 /etc/ssmtp

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Ensure the PHP environment is sane
COPY composer.json /tmp
WORKDIR /tmp
RUN composer install && \
    composer check-platform-reqs && \
    rm -rf composer.json composer.lock vendor

WORKDIR /
