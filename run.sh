#!/bin/bash

cd /mikegold.in
git pull
ghc server.hs
nohup ipfs daemon &
nohup ./server > server.log &
