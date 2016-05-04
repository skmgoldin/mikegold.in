#!/bin/bash

cd /mikegold.in
git pull
ghc server.hs
./server > server.log
