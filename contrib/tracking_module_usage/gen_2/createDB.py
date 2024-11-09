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
import os, sys, re, MySQLdb, time

dirNm, execName = os.path.split(os.path.realpath(sys.argv[0]))
sys.path.append(os.path.realpath(dirNm))

from LMODdb     import LMODdb
import argparse

def dbConfigFn(dbname):
  """
  Build config file name from dbname.
  @param dbname: db name
  """
  return dbname + "_db.conf"

class CmdLineOptions(object):
  """ Command line Options class """

  def __init__(self):
    """ Empty Ctor """
    pass

  def execute(self):
    """ Specify command line arguments and parse the command line"""
    parser = argparse.ArgumentParser()
    parser.add_argument("--drop",        dest='drop',   action="store_true", default = False,     help="lmod")
    parser.add_argument("--confFn",      dest='confFn', action="store",      default = None,      help="lmod")
    parser.add_argument("--dbname",      dest='dbname', action="store",      default = "lmod",    help="lmod")
    args = parser.parse_args()
    return args


def main():
  """
  This program creates the Database used by Lmod.
  """

  args     = CmdLineOptions().execute()
  configFn = dbConfigFn(args.dbname)
  if (args.confFn):
    configFn = args.confFn

  if (not os.path.isfile(configFn)):
    dirNm, exe = os.path.split(sys.argv[0])
    fn         = os.path.join(dirNm, configFn)
    if (os.path.isfile(fn)):
      configFn = fn
    else:
      configFn = os.path.abspath(os.path.join(dirNm, "../site", configFn))

  lmod = LMODdb(configFn)

  try:
    conn   = lmod.connect()
    cursor = conn.cursor()

    # drop db if requested.
    if (args.drop):
      cursor.execute("DROP DATABASE IF EXISTS %s " % lmod.db())

    # If the database does not exist, create it, otherwise, switch to the database.
    cursor.execute("CREATE DATABASE IF NOT EXISTS %s DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci" % lmod.db())
    cursor.execute("USE "+lmod.db())

    idx = 1


    print("start")

    # 1
    cursor.execute("""
        CREATE TABLE `userT` (
          `user_id`       int(11) unsigned NOT NULL auto_increment,
          `user`          varchar(64)      NOT NULL,
          PRIMARY KEY  (`user_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8  COLLATE=utf8_general_ci AUTO_INCREMENT=1
        """)
    print("(%d) create userT table" % idx); idx += 1

    # 2
    cursor.execute("""
        CREATE TABLE `moduleT` (
          `mod_id`        int(11) unsigned NOT NULL auto_increment,
          `path`          varchar(1024)    NOT NULL,
          `module`        varchar(64)      NOT NULL,
          `syshost`       varchar(32)      NOT NULL,
          PRIMARY KEY  (`mod_id`),
          INDEX  `thekey` (`path`(128), `syshost`)

        ) ENGINE=InnoDB DEFAULT CHARSET=utf8  COLLATE=utf8_general_ci AUTO_INCREMENT=1
        """)
    print("(%d) create moduleT table" % idx ); idx += 1;


    # 3
    cursor.execute("""
        CREATE TABLE `join_user_module` (
          `join_id`       int(11) unsigned NOT NULL auto_increment,
          `user_id`       int(11) unsigned NOT NULL,
          `mod_id`        int(11) unsigned NOT NULL,
          `date`          DATETIME         NOT NULL,
          PRIMARY KEY (`join_id`, `date`),
          INDEX `index_date` (`date`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8  COLLATE=utf8_general_ci AUTO_INCREMENT=1
        """)
    print("(%d) create join_link_object table" % idx); idx += 1

    cursor.close()
  except  MySQLdb.Error as e:
    print ("Error %d: %s" % (e.args[0], e.args[1]))
    sys.exit (1)

if ( __name__ == '__main__'): main()
