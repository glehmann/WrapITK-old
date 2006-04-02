#!/usr/bin/env python

import sys, commands

segfaultFile = file(sys.argv[1], "w")

ret = 1
while ret != 0:
  (ret, output) = commands.getstatusoutput("python returnedTypeCoverage.py -v5 --exclude "+sys.argv[1])
  if ret != 0:
    # find last args (the ones which caused the segfault)
    for l in reversed(output.splitlines()):
      if l.startswith('('):
        faultyArgs = l
        break
    print faultyArgs
    segfaultFile.write(faultyArgs+"\n")
    segfaultFile.flush()
    