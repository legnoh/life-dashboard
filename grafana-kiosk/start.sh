#!/bin/bash

set -u

cd grafana-kiosk

systemctl is-enabled grafana-kiosk
if [ $? == 0 ]
then
    sudo systemctl stop grafana-kiosk
    sudo systemctl disable grafana-kiosk
fi

envsubst < ./tpl/grafana-kiosk.service.tpl > /tmp/grafana-kiosk.service
sudo cp -r /tmp/grafana-kiosk.service /etc/systemd/system/grafana-kiosk.service
sudo chmod 664 /etc/systemd/system/grafana-kiosk.service

sudo systemctl daemon-reload
sudo systemctl enable grafana-kiosk
sudo systemctl start grafana-kiosk
sudo systemctl status grafana-kiosk

cd -
