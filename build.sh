#!/bin/bash

set -e

function build() {
    IMAGE=$1

    docker build -t brianlmoon/php:$IMAGE --build-arg BASEIMAGE=$IMAGE .

    VERSION=`docker run --rm brianlmoon/php:$IMAGE php -r 'echo phpversion();'`

    docker tag brianlmoon/php:$IMAGE brianlmoon/php:`echo $VERSION | awk -F . {'print $1"."$2"."$3'}`
    docker tag brianlmoon/php:$IMAGE brianlmoon/php:`echo $VERSION | awk -F . {'print $1"."$2'}`
    docker tag brianlmoon/php:$IMAGE brianlmoon/php:`echo $VERSION | awk -F . {'print $1'}`

    docker push brianlmoon/php:$IMAGE
    docker push brianlmoon/php:`echo $VERSION | awk -F . {'print $1"."$2"."$3'}`
    docker push brianlmoon/php:`echo $VERSION | awk -F . {'print $1"."$2'}`
    docker push brianlmoon/php:`echo $VERSION | awk -F . {'print $1'}`

    if [ "$2" == "latest" ]
    then
        docker tag brianlmoon/php:$IMAGE brianlmoon/php:latest
        docker push brianlmoon/php:latest
    fi
}

build 8.0-fpm-alpine
build 8.1-fpm-alpine
build 8.2-fpm-alpine latest
