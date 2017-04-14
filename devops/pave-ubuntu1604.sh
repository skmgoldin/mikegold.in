#!/bin/bash

# Install updates
apt-get update && apt-get upgrade -y
# Install Docker:
apt-get remove docker docker-engine
apt-get install -y apt-transport-https ca-certificates curl \
  software-properties-common git
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce

