FROM php:7.4.28-fpm-buster

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        nano \
        git \
        zip \
        unzip && \
    rm -r /var/lib/apt/lists/* && \
    apt autoremove -y

RUN curl -sSLf \
        -o /usr/local/bin/install-php-extensions \
        https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && \
    chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions mysqli pdo_mysql pdo_pgsql pgsql

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Add php user and group and add /app dir owned by php
RUN groupadd -g 1000 php && \
    useradd -m -u 1000 -g 1000 -s /bin/bash -d /home/php php && \
    mkdir /app && \
    chown php:php /app

RUN cp /usr/local/etc/php/php.ini-development \
       /usr/local/etc/php/php.ini
