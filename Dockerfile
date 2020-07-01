FROM php:7.4.0RC3-fpm-buster

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        unzip && \
    rm -r /var/lib/apt/lists/* && \
    apt autoremove -y

# Install composer
COPY scripts/getcomposer.sh /usr/local/bin/getcomposer.sh
RUN /usr/local/bin/getcomposer.sh && \
    rm /usr/local/bin/getcomposer.sh && \
    mv /var/www/html/composer.phar /usr/local/bin/composer

# Add php user and group and add /app dir owned by php
RUN groupadd -g 1000 php && \
    useradd -m -u 1000 -g 1000 -s /bin/bash -d /home/php php && \
    mkdir /app && \
    chown php:php /app

RUN cp /usr/local/etc/php/php.ini-development \
       /usr/local/etc/php/php.ini
