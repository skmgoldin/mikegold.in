#!/bin/python

import sys
import os
from subprocess import call

# Check for valid arguments
if len(sys.argv) != 2 or sys.argv[1] != "prod":
    print("Please run as `python deploy prod`")
else:
    arg = sys.argv[1]
    # Get project directory context as string for second call
    pwd = os.path.dirname(os.path.realpath(__file__))
    # Build and run the container.
    call(["docker", "build", "-t", "mikegold.in", "."])
    if arg == "prod":
        call(["docker", "run", "-it", "-v", pwd + ":/mikegold.in", "-p", \
              "80:80", "mikegold.in", "python", "/mikegold.in/d_deploy.py", arg])

