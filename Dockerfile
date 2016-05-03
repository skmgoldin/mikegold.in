FROM ubuntu:14.04
MAINTAINER Mike Goldin <skmgoldin@gmail.com>
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y git man vim ghc cabal-install
RUN cabal update
RUN cabal install Network
RUN git clone https://github.com/skmgoldin/mikegold.in.git
RUN ghc mikegold.in/server.hs
