#!/usr/bin/env bash

docker image inspect --format '{{index .RepoTags}}' "${docker_service}" 2> /dev/null | grep -q "${docker_service}" && \
    docker rmi --force ${docker_service} || true
docker build --rm --tag ${docker_service} .
