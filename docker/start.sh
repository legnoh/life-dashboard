#!/bin/bash

set -eu

cd docker

envsubst < ./tpl/openweather.env.tpl > ./openweather.env
envsubst < ./tpl/tado.env.tpl > ./tado.env
envsubst < ./tpl/todoist.env.tpl > ./todoist.env
envsubst < ./tpl/prometheus.yaml.tpl > ./prometheus/prometheus.yaml

sudo docker-compose down --remove-orphans
sudo service docker restart
sudo docker-compose up -d --force-recreate
sudo docker ps

cd -
