#!/bin/sh
# -*- python -*-

################################################################################
# This file is python 2/3 bilingual. 
# The line """:" starts a comment in python and is a no-op in shell.
""":"
# Shell code to find and run a suitable python interpreter.
for cmd in python3 python python2; do
   command -v > /dev/null $cmd && exec $cmd $0 "$@"
done

echo "Error: Could not find a valid python interpreter --> exiting!" >&2
exit 2
":""" # this line ends the python comment and is a no-op in shell.
################################################################################

from __future__ import print_function
import os, sys, re, json

def main():
  print ("Hello World! from ", sys.version)
  fn = "/abc/def/modules.new.json"
  baseNm, extension = os.path.splitext(fn)
  print(baseNm, extension)
  if (extension == ".json"):
    print("found")
  s = '{ "user": "ahberrington1", "module" : "py-setuptools/63.4.3", \
"path" : "/work2/06809/jpark217/frontera/202403/spack-stack/envs/unified-dev.frontera/install/modulefiles/intel/23.1.0/py-setuptools/63.4.3.lua", \
"host" : "frontera",         "time" : 1724746142.926165}'
 
  dataT = json.loads(s)
  print(dataT)
  
  print (dataT['user'])
  v = dataT.get('foo')
  if (not v):
    print('no v')
    
  v = dataT.get('user')
  if (v):
    print('have user')
    
  



if ( __name__ == '__main__'): main()
