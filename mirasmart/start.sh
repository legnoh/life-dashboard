#!/bin/bash

set -eu

sudo docker compose pull
sudo docker compose stop
if [[ "${DOCKER_COMPOSE_RM}" == 'true' ]]; then
  sudo docker compose rm -f
fi
sudo docker compose up -d
sudo docker ps

sudo docker system prune -f --all --volumes
