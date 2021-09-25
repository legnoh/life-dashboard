#!/bin/bash

PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

# https://github.com/grafana/grafana-kiosk#installing-on-linux
ARCH="armv7"

# install some utilities
sudo apt-get -y install \
    chromium-browser \
    jq

# install latest grafana-kiosk
latest_info=$(curl -s https://api.github.com/repos/grafana/grafana-kiosk/releases/latest)
download_url=$(echo ${latest_info} | jq -r '.assets[] | select(.name | contains("${ARCH}")) | .browser_download_url')
curl -OL ${url}
sudo cp -p grafana-kiosk.linux.${ARCH} /usr/bin/grafana-kiosk
sudo chmod 755 /usr/bin/grafana-kiosk
