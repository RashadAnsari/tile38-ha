#!/bin/bash
TILE38_VERSION=1.17.6
if [ "${TRAVIS_BRANCH}" == "master" ]; then
    echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
    docker push rashadansari/tile38:${TILE38_VERSION}
    docker tag rashadansari/tile38:${TILE38_VERSION} rashadansari/tile38:latest
    docker push rashadansari/tile38:latest
fi
