#!/bin/bash

set -eu

cd docker

sudo mkdir -p /var/withings-exporter/tmp

envsubst < ./tpl/openweather.env.tpl > ./openweather.env
envsubst < ./tpl/tado.env.tpl > ./tado.env
envsubst < ./tpl/todoist.env.tpl > ./todoist.env
envsubst < ./tpl/smartmeter.env.tpl > ./smartmeter.env
envsubst < ./tpl/withings.env.tpl > ./withings.env
envsubst < ./tpl/prometheus.yaml.tpl > ./prometheus/prometheus.yaml

sudo docker compose pull
sudo docker compose stop
if [[ "${DOCKER_COMPOSE_RM}" == 'true' ]]; then
  sudo docker compose rm -f
fi
sudo docker compose up -d
sudo docker ps

sudo docker system prune -f --all --volumes

set -x

is_exist_playlist=$(curl -o /dev/null -w '%{http_code}\n' -s "http://localhost:3000/api/playlists/1")
if [[ ${is_exist_playlist} == 404 ]]; then
    curl -X "POST" "http://localhost:3000/api/playlists/" \
        -H 'Content-Type: application/json; charset=utf-8' \
        -d $'{
        "name": "Kiosk playlist",
        "interval": "15m",
        "items": [{
            "value": "2",
            "title": "Service/main dashboard",
            "order": 1,
            "type": "dashboard_by_id"
        }
        ]}'
fi

cd -
