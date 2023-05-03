#!/bin/bash

set -e

COMPOSE_FILE="${HOME}/life-dashboard/configs/docker-compose.yml"

docker compose -f ${COMPOSE_FILE} pull

if [[ "${RECREATE_CONTAINER}" == 'true' ]]; then
  docker compose -f ${COMPOSE_FILE} down
  rm -rf /tmp/terraform.tfstate*
else
  docker compose -f ${COMPOSE_FILE} stop
fi

docker compose -f ${COMPOSE_FILE} up -d --remove-orphans
docker ps

docker system prune -f --all --volumes
