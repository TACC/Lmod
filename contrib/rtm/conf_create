#!/usr/bin/env python
# -*- python -*-
#
# Git Version: @git@

#-----------------------------------------------------------------------
# XALT: A tool that tracks users jobs and environments on a cluster.
# Copyright (C) 2013-2014 University of Texas at Austin
# Copyright (C) 2013-2014 University of Tennessee
# 
# This library is free software; you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation; either version 2.1 of 
# the License, or (at your option) any later version. 
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Lesser  General Public License for more details. 
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free
# Software Foundation, Inc., 59 Temple Place, Suite 330,
# Boston, MA 02111-1307 USA
#-----------------------------------------------------------------------

from __future__ import print_function
import os, sys, re, ConfigParser, getpass, base64

dirNm, execName = os.path.split(sys.argv[0])
sys.path.insert(1,os.path.abspath(os.path.join(dirNm, "../libexec")))
sys.path.insert(1,os.path.realpath(os.path.join(dirNm, "../site")))

import argparse

class CmdLineOptions(object):
  def __init__(self):
    pass
  
  def execute(self):
    parser = argparse.ArgumentParser()
    parser.add_argument("--dbhost",  dest='dbhost',  action="store",  help="db host")
    parser.add_argument("--dbuser",  dest='dbuser',  action="store",  help="db user")
    parser.add_argument("--passwd",  dest='passwd',  action="store",  help="password")
    parser.add_argument("--dbname",  dest='dbname',  action="store",  help="name of db")

    args = parser.parse_args()
    
    return args
class CreateConf(object):
  def __init__(self, args):
    self.__host   = args.dbhost 
    self.__user   = args.dbuser 
    self.__passwd = args.passwd 
    self.__db     = args.dbname 
    
  def __readFromUser(self):
    if (not self.__host):   self.__host   = raw_input("Database host: ")
    if (not self.__user):   self.__user   = raw_input("Database user: ")
    if (not self.__passwd): self.__passwd = getpass.getpass("Database pass: ")
    if (not self.__db):     self.__db     = raw_input("Database name: ")
    
  def __writeConfig(self):
    config=ConfigParser.ConfigParser()
    config.add_section("MYSQL")
    config.set("MYSQL","HOST",self.__host)
    config.set("MYSQL","USER",self.__user)
    config.set("MYSQL","PASSWD",base64.b64encode(self.__passwd))
    config.set("MYSQL","DB",self.__db)

    fn = self.__db + "_db.conf"

    f = open(fn,"w")
    config.write(f)
    f.close()

  def create(self):

    self.__readFromUser()
    self.__writeConfig()
    


def main():
  args = CmdLineOptions().execute()
  createConf = CreateConf(args)
  createConf.create()


if ( __name__ == '__main__'): main()
