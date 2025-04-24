#!/bin/bash

set -e

function build() {
    IMAGE=$1

    echo "Building $IMAGE"

    VERSION=`docker run --rm php:$IMAGE php -r 'echo phpversion();'`

    TAGS=""

    TAGS="$TAGS -t brianlmoon/php:"`echo $VERSION | awk -F . {'print $1"."$2"."$3'}`
    TAGS="$TAGS -t brianlmoon/php:"`echo $VERSION | awk -F . {'print $1"."$2'}`

    if [ "$2" == "latest" ]
    then
        TAGS="$TAGS -t brianlmoon/php:latest"
    fi

    docker buildx build \
        --platform linux/amd64,linux/arm64 \
        -t brianlmoon/php:$IMAGE \
        $TAGS \
        --build-arg BASEIMAGE=$IMAGE \
        --cache-from brianlmoon/php:$IMAGE \
        --push \
        .
}

build 8.1-fpm-alpine && \
build 8.2-fpm-alpine && \
build 8.3-fpm-alpine && \
build 8.4-fpm-alpine latest
