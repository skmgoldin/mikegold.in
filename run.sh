#!/bin/bash

cd /mikegold.in
git pull
ghc server.hs
nohup ipfs daemon &
./server > server.log
