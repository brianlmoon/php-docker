FROM php:8.1.3-fpm-buster

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        nano \
        git \
        zip \
        unzip && \
    rm -r /var/lib/apt/lists/* && \
    apt autoremove -y

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Add php user and group and add /app dir owned by php
RUN groupadd -g 1000 php && \
    useradd -m -u 1000 -g 1000 -s /bin/bash -d /home/php php && \
    mkdir /app && \
    chown php:php /app

RUN cp /usr/local/etc/php/php.ini-development \
       /usr/local/etc/php/php.ini
