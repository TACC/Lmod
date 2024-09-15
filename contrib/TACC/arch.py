#!/bin/sh
# -*- python -*-

################################################################################
# This file is python bilingual: The next line starts a comment in Python,
# and is a no-op in shell
""":"
# Find a suitable python interpreter (adapt for your specific needs) 
for cmd in python3 python python2; do
   command -v > /dev/null $cmd && exec $cmd $0 "$@"
done

echo "Error: Could not find a valid python interpreter --> exiting!"  >&2
exit 2
":"""
################################################################################

# This program reports the (uname -m) and cpu family and the model from /proc/cpuinfo
# On chips that support AVX2 the model is replaced with "avx2".

# Robert McLay 2016-08-11 12:33



from __future__ import print_function
import os, sys, re, platform

def main():
  osName       = platform.system()
  machName     = platform.machine()
  machDescript = ""
  cpuFamily    = False
  model        = False

  if (osName == "Linux" and machName == "x86_64"):
    f = open("/proc/cpuinfo","r")

    count = 0
    avx2  = False
    for line in f:
      if (line.find("cpu family") != -1):
        A         = re.findall(r'\d+',line)
        cpuFamily = "%02x" %( int(A[0]) )
        count    += 1
      elif (line.find("model name") != -1):
        A            = re.findall(r'.*: *(.*)',line)
        machDescript = A[0]
        count       += 1
      elif (line.find("model") != -1):
        A      = re.findall(r'.*: *(.*)',line)
        model  = "%02x" % ( int(A[0]) ) 
        count += 1
      elif (line.find("flags") != -1):
        A       = re.findall(r'.*: *(.*)',line)
        flagStr = A[0]
        if (flagStr.find("avx2") != -1):
          model = "avx2"
        count += 1
      if (count > 3):
        break

    f.close()
  A = []
  A.append(machName)
  if (cpuFamily):
    A.append(cpuFamily)
  if (model):
    A.append(model)

  machName = "_".join(A)
  print(machName)
  

if ( __name__ == '__main__'): main()
