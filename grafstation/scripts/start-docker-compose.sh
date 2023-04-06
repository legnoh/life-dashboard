#!/bin/bash

set -eu

COMPOSE_FILE="/opt/life-dashboard/docker-compose.yml"

docker compose -f ${COMPOSE_FILE} pull
docker compose -f ${COMPOSE_FILE} stop
if [[ "${DOCKER_COMPOSE_RM}" == 'true' ]]; then
  docker compose -f ${COMPOSE_FILE} rm -f
fi
docker compose -f ${COMPOSE_FILE} up -d
docker ps

docker system prune -f --all --volumes
