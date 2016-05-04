FROM ubuntu:14.04
MAINTAINER Mike Goldin <skmgoldin@gmail.com>
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y git man vim ghc cabal-install curl
RUN cabal update
RUN cabal install Network
RUN git clone https://github.com/skmgoldin/mikegold.in.git
RUN ghc mikegold.in/server.hs
RUN curl -o go-ipfs.tar.gz http://dist.ipfs.io/go-ipfs/v0.4.0/go-ipfs_v0.4.0_linux-amd64.tar.gz
RUN tar xvfz go-ipfs.tar.gz 
RUN mv go-ipfs/ipfs /usr/local/bin/ipfs
RUN ipfs init
RUN ipfs config "Addresses.Gateway" "/ip4/0.0.0.0/tcp/8080"
