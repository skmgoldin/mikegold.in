#!/bin/bash

git pull
ghc server.hs
./server > server.log
