#!/bin/bash

set -eu

DOCKER_COMPOSE_FILE="$HOME/life-dashboard/mirakc/docker-compose.yml"
DOCKER_COMPOSE="docker compose -f ${DOCKER_COMPOSE_FILE} -p tv-recorder"
RECREATE_CONTAINER=${RECREATE_CONTAINER:-"false"}
ACTION=${1:-"up"}

# docker start
if [[ "${ACTION}" == "up" ]]; then

  sudo ${DOCKER_COMPOSE} pull
  if [[ "${RECREATE_CONTAINER}" == 'true' ]]; then
    sudo ${DOCKER_COMPOSE} down
  else
    sudo ${DOCKER_COMPOSE} stop
  fi
  sudo ${DOCKER_COMPOSE} up -d
  sudo ${DOCKER_COMPOSE} ps

# stop/down
elif [[ "${ACTION}" == "stop" ]]; then

  sudo ${DOCKER_COMPOSE} stop

elif [[ "${ACTION}" == "down" ]]; then

  sudo ${DOCKER_COMPOSE} down

# logs/ps
elif [[ "${ACTION}" == "logs" ]]; then

  sudo ${DOCKER_COMPOSE} logs -f

elif [[ "${ACTION}" == "ps" ]]; then

  sudo ${DOCKER_COMPOSE} ps

fi
