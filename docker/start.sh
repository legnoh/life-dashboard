#!/bin/bash

set -eu

cd docker

envsubst < ./tpl/openweather.env.tpl > ./openweather.env
envsubst < ./tpl/tado.env.tpl > ./tado.env
envsubst < ./tpl/todoist.env.tpl > ./todoist.env
envsubst < ./tpl/smartmeter.env.tpl > ./smartmeter.env
envsubst < ./tpl/withings.env.tpl > ./withings.env
envsubst < ./tpl/prometheus.yaml.tpl > ./prometheus/prometheus.yaml

sudo docker-compose pull
sudo docker-compose stop
sudo docker-compose up -d
sudo docker ps

sudo docker system prune -f --all --volumes

cd -
