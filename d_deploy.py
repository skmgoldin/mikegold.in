#!/bin/python

import sys
import os
from subprocess import call

# Check for valid arguments
if len(sys.argv) != 2 or sys.argv[1] != "prod":
    print("Please run as `python d_deploy prod`")
else:
    # Get project directory context and move into it
    project_dir = os.path.dirname(os.path.realpath(__file__))
    os.chdir(project_dir)
    # Run as dev or prod
    if sys.argv[1] == "prod":
        call(["ghc", "server.hs"])
        call(["nohup", "ipfs", "daemon", "&"])
        call(["./server", ">", "server.log"])
