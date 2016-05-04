#!/bin/bash

cd /mikegold.in
git pull
ghc server.hs
ipfs init
nohup ipfs daemon &
nohup ./server > server.log &
