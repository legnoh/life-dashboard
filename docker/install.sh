#!/bin/bash

# https://docs.docker.com/engine/install/debian/

## Update the apt package index and install packages to allow apt to use a repository over HTTPS
sudo apt-get -y update
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

## install docker with official script
## https://docs.docker.com/engine/install/debian/#install-using-the-convenience-script
which docker > /dev/null
if [ $? != 0 ]
then
    sudo curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
fi

# install docker-compose
which docker-compose > /dev/null
if [ $? != 0 ]
then
    sudo pip3 install docker-compose
fi
