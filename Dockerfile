FROM ubuntu:14.04
MAINTAINER Mike Goldin <skmgoldin@gmail.com>
# Install essentials
RUN apt-get update && apt-get upgrade -y \
&& apt-get install -y git man vim ghc cabal-install curl wget python \
# Install cabal dependencies
&& cabal update \
&& cabal install Network \
# Get repo and compile
&& git clone https://github.com/skmgoldin/mikegold.in.git \
&& ghc mikegold.in/server.hs \
# Install IPFS
&& curl -o go-ipfs.tar.gz http://dist.ipfs.io/go-ipfs/v0.4.0/go-ipfs_v0.4.0_linux-amd64.tar.gz \
&& tar xvfz go-ipfs.tar.gz \
&& mv go-ipfs/ipfs /usr/local/bin/ipfs \
&& rm -rf go-ipfs go-ipfs.tar.gz \
# Update IPFS
# IPFS 0.4.2 breaks the docker build, stick to 0.4.1
&& wget -r https://dist.ipfs.io/ipfs-update/v1.3.0/ipfs-update_v1.3.0_linux-amd64.tar.gz \
&& tar xvfz dist.ipfs.io/ipfs-update/v1.3.0/ipfs-update_v1.3.0_linux-amd64.tar.gz \
&& mv /ipfs-update/ipfs-update /usr/local/bin \
&& rm -rf ipfs-update dist.ipfs.io \
&& ipfs-update install v0.4.1 \
# Initialize and configure IPFS
&& ipfs init \
&& ipfs config "Addresses.Gateway" "/ip4/0.0.0.0/tcp/8080"

# TODO: Purge unneeded packages
