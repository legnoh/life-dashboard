#!/bin/bash

# https://docs.docker.com/engine/install/debian/

## Uninstall old versions
sudo apt-get remove \
    docker \
    docker-engine \
    docker.io \
    containerd \
    runc

## Update the apt package index and install packages to allow apt to use a repository over HTTPS
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

## install docker with official script
## https://docs.docker.com/engine/install/debian/#install-using-the-convenience-script
sudo curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# install docker-compose
sudo pip3 install docker-compose
