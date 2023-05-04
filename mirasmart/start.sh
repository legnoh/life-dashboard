#!/bin/bash

set -eu

export SMARTMETER_ID=${SMARTMETER_ID:?}
export SMARTMETER_PASSWORD=${SMARTMETER_PASSWORD:?}
RECREATE_CONTAINER=${RECREATE_CONTAINER:-"false"}

envsubst < docker-compose.yml.tpl > docker-compose.yml

sudo docker compose pull

if [[ "${RECREATE_CONTAINER}" == 'true' ]]; then
  sudo docker compose down
else
  sudo docker compose stop
fi

sudo docker compose up -d
sudo docker ps

sudo docker system prune -f --all --volumes
