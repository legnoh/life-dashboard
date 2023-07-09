#!/bin/bash

set -eu

RECREATE_CONTAINER=${RECREATE_CONTAINER:-"false"}

sudo docker compose pull

if [[ "${RECREATE_CONTAINER}" == 'true' ]]; then
  sudo docker compose down
else
  sudo docker compose stop
fi

sudo docker compose up -d
sudo docker ps

sudo docker system prune -f --all --volumes
