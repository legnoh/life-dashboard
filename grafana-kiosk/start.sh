#!/bin/bash

set -eu

cd grafana-kiosk

envsubst < ./tpl/grafana-kiosk.yaml.tpl > /tmp/grafana-kiosk.yaml
sudo cp -r /tmp/grafana-kiosk.yaml /etc/grafana-kiosk.yaml
sudo chmod 664 /etc/grafana-kiosk.yaml

sudo cp -r ./tpl/grafana-kiosk.service /etc/systemd/system/grafana-kiosk.service
sudo chmod 664 /etc/systemd/system/grafana-kiosk.service

sudo systemctl daemon-reload
sudo systemctl enable grafana-kiosk
sudo systemctl start grafana-kiosk
sudo systemctl status grafana-kiosk

cd -
