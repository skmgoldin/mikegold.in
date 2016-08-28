#!/bin/bash

# Install updates
apt-get update && apt-get upgrade -y
# Install Docker:
apt-get install -y git python apt-transport-https ca-certificates
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
rm /etc/apt/sources.list.d/docker.list
echo 'deb https://apt.dockerproject.org/repo ubuntu-xenial main' > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get purge lxc-docker
apt-get install -y docker-engine python python-pip python-dev
service docker start
pip install --upgrade pip
pip install docker-compose
shutdown -r now

