#!/bin/bash

set -eu

cd grafana-kiosk

envsubst < ./tpl/grafana-kiosk.yaml.tpl > /tmp/grafana-kiosk.yaml
sudo cp -r /tmp/grafana-kiosk.yaml /etc/grafana-kiosk.yaml
sudo chmod 664 /etc/grafana-kiosk.yaml

mkdir -p /home/pi/.config/lxsession/LXDE-pi/
touch /home/pi/.config/lxsession/LXDE-pi/autostart
echo "/usr/bin/grafana-kiosk -c /etc/grafana-kiosk.yaml" > /home/pi/.config/lxsession/LXDE-pi/autostart

cd -
