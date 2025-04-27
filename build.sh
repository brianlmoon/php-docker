#!/bin/bash

set -e

function build() {
    IMAGE=$1

    echo "Building $IMAGE"

    VERSION=`docker run --rm php:$IMAGE php -r 'echo phpversion();'`

    MINOR=`echo $VERSION | awk -F . {'print $1"."$2'}`

    TAGS=""

    TAGS="$TAGS -t brianlmoon/php:"`echo $VERSION | awk -F . {'print $1"."$2"."$3'}`
    TAGS="$TAGS -t brianlmoon/php:$MINOR"

    if [ "$2" == "latest" ]
    then
        TAGS="$TAGS -t brianlmoon/php:latest"
    fi

    docker buildx build \
        --platform linux/amd64,linux/arm64 \
        -t brianlmoon/php:`echo $VERSION | awk -F . {'print $1"."$2'}`-fpm-alpine \
        $TAGS \
        --build-arg BASEIMAGE=$IMAGE \
        --cache-from brianlmoon/php:$MINOR \
        --push \
        .
}

VERSION81=`curl 'https://raw.githubusercontent.com/docker-library/php/refs/heads/master/8.1/alpine3.21/fpm/Dockerfile' -s | fgrep ' PHP_VERSION ' | awk '{print $3}'`
VERSION82=`curl 'https://raw.githubusercontent.com/docker-library/php/refs/heads/master/8.2/alpine3.21/fpm/Dockerfile' -s | fgrep ' PHP_VERSION ' | awk '{print $3}'`
VERSION83=`curl 'https://raw.githubusercontent.com/docker-library/php/refs/heads/master/8.3/alpine3.21/fpm/Dockerfile' -s | fgrep ' PHP_VERSION ' | awk '{print $3}'`
VERSION84=`curl 'https://raw.githubusercontent.com/docker-library/php/refs/heads/master/8.4/alpine3.21/fpm/Dockerfile' -s | fgrep ' PHP_VERSION ' | awk '{print $3}'`

# build $VERSION81-fpm-alpine && \
build $VERSION82-fpm-alpine && \
build $VERSION83-fpm-alpine && \
build $VERSION84-fpm-alpine latest
