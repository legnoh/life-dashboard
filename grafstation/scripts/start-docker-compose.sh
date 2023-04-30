#!/bin/bash

set -e

COMPOSE_FILE="${HOME}/life-dashboard/configs/docker-compose.yml"

docker compose -f ${COMPOSE_FILE} pull
docker compose -f ${COMPOSE_FILE} down
docker compose -f ${COMPOSE_FILE} up -d
docker ps

docker system prune -f --all --volumes
