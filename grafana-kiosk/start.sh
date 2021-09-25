#!/bin/bash

set -eu

cd grafana-kiosk

sudo cp -r ./tpl/grafana-kiosk.service /etc/systemd/system/grafana-kiosk.service
sudo sh -c 'envsubst < ./tpl/grafana-kiosk.yaml.tpl > /etc/grafana-kiosk.yaml'
sudo chmod 664 /etc/systemd/system/grafana-kiosk.service
sudo chmod 664 /etc/grafana-kiosk.yaml

sudo systemctl daemon-reload

sudo systemctl enable grafana-kiosk
sudo systemctl start grafana-kiosk
sudo systemctl status grafana-kiosk

cd -
