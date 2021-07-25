#!/usr/bin/env bash

export DOCKER_BUILDKIT=0
export COMPOSE_DOCKER_CLI_BUILD=0

docker image inspect --format '{{index .RepoTags}}' "docker-service:1.0.0" 2> /dev/null | grep -q "docker-service:1.0.0" && \
    docker rmi --force docker-service:1.0.0 || true
docker build --rm --tag docker-service:1.0.0 .
