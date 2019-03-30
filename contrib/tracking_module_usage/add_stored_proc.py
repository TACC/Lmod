#!/usr/bin/env python
# -*- python -*-

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

def strDate2dA(s):
  dA = re.split(r'[-_/.]', s)
  dA = [ int(dA[0]), int(dA[1]) ]
  return dA

def add_month(dA):
  dA[1] += 1
  if (dA[1] > 12):
    dA[0] += 1
    dA[1]  = 1

  return dA

def substract_month(dA):
  dA[1] -= 1
  if (dA[1] < 1):
    dA[0] -= 1
    dA[1]  = 12

  return dA

  
class CmdLineOptions(object):
  """ Command line Options class """

  def __init__(self):
    """ Empty Ctor """
    pass

  def execute(self):
    """ Specify command line arguments and parse the command line"""
    dA     = add_month(strDate2dA(time.strftime('%Y-%m-%d', time.localtime(time.time()))))
    partNm = "%04d-%02d" % (dA[0], dA[1])

    parser = argparse.ArgumentParser()
    parser.add_argument("--dbname",    dest='dbname',    action="store",      default = "lmod", help="lmod")
    parser.add_argument("--startPart", dest='firstPart', action="store",      default = partNm, help="first partition date")
    args = parser.parse_args()
    return args


def main():
  """
  This program creates the Database used by Lmod.
  """

  args     = CmdLineOptions().execute()
  configFn = dbConfigFn(args.dbname)

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
    idx    = 1

    cursor.execute("USE "+lmod.db())

    print("(%d) create join_link_object table" % idx); idx += 1

    sqlCommands = """
       create procedure CreateDataPartition (newPartValue DATETIME, tbName VARCHAR(50))
       begin
       DECLARE keepStmt VARCHAR(2000) DEFAULT @stmt;
       SET @stmt = CONCAT('ALTER TABLE ', tbName ,' ADD PARTITION (PARTITION p',
                            DATE_FORMAT(newPartValue, '%Y_%m'),
                            ' VALUES LESS THAN (TO_DAYS(\\'',
                            DATE_FORMAT(newPartValue, '%Y-%m-01'),
                            '\\')))');
       PREPARE pStmt FROM @stmt;
       execute pStmt;
       DEALLOCATE PREPARE pStmt;
       set @stmt = keepStmt;
       END 
    """


    cursor.execute(sqlCommands)
    print("(%d) Create stored procedure CreateDataPartition" % idx); idx += 1

    sqlCommands = """
       CREATE EVENT eventCreatePartition
       ON SCHEDULE EVERY 1 MONTH
       STARTS '2016-02-01 00:00:00'
       DO
       BEGIN
        call CreateDataPartition(NOW() + interval 1 MONTH,'join_user_module');
       END 
    """
    cursor.execute(sqlCommands)
    print("(%d) Create event eventCreatePartition" % idx); idx += 1

    dA  = strDate2dA(args.firstPart)
    dA  = add_month(dA)
    now = time.strftime('%Y-%m-%d', time.localtime(time.time()))
    eA  = add_month(strDate2dA(now))

    while ((dA[0] < eA[0]) or (dA[0] == eA[0] and dA[1] <= eA[1])):
      partNm  = "p%04d_%02d"   % (dA[0], dA[1])
      dateStr = "%04d-%02d-01" % (dA[0], dA[1])
      query   = "ALTER TABLE join_user_module ADD PARTITION (PARTITION " +\
               partNm + " VALUES LESS THAN (TO_DAYS('"+dateStr+"')))"

      print("query:",query)
      cursor.execute(query)

      dA = add_month(dA)

    cursor.close()

  except  MySQLdb.Error, e:
        print ("Error %d: %s" % (e.args[0], e.args[1]))
        sys.exit (1)

if ( __name__ == '__main__'): main()
