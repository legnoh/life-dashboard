#!/bin/bash

set -eu

cd docker

envsubst < ./tpl/openweather.env.tpl > ./openweather.env
envsubst < ./tpl/tado.env.tpl > ./tado.env
envsubst < ./tpl/todoist.env.tpl > ./todoist.env
envsubst < ./tpl/prometheus.yaml.tpl > ./prometheus/prometheus.yaml

sudo docker-compose stop --remove-orphans
sudo docker-compose up -d
sudo docker ps

cd -
