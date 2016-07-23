FROM ubuntu:14.04
MAINTAINER Mike Goldin <skmgoldin@gmail.com>


# Install essentials
RUN apt-get update && apt-get upgrade -y \
&& apt-get install -y ghc cabal-install \
# Install cabal dependencies
&& cabal update \
&& cabal install Network

COPY ./ /site
RUN ghc /site/server.hs

WORKDIR /site
CMD ["./server", ">", "server.log"]
 
# TODO: Purge unneeded packages
