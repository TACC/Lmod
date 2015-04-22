from __future__ import print_function
from time       import sleep
import os, sys, re, base64
dirNm, execName = os.path.split(os.path.realpath(sys.argv[0]))
sys.path.append(os.path.realpath(dirNm))

import MySQLdb, ConfigParser, getpass
import warnings
warnings.filterwarnings("ignore", "Unknown table.*")

def convertToInt(s):
  """
  Convert to string to int.  Protect against bad input.
  @param s: Input string
  @return: integer value.  If bad return 0.
  """
  try:
    value = int(s)
  except ValueError:
    value = 0
  return value

class LMODdb(object):
  """
  This LMODdb class opens the Lmod database and is responsible for
  all the database interactions.
  """
  def __init__(self, confFn):
    """ Initialize the class and save the db config file. """
    self.__host   = None
    self.__user   = None
    self.__passwd = None
    self.__db     = None
    self.__conn   = None
    self.__confFn = confFn

  def __readFromUser(self):
    """ Ask user for database access info. (private) """

    self.__host   = raw_input("Database host:")
    self.__user   = raw_input("Database user:")
    self.__passwd = getpass.getpass("Database pass:")
    self.__db     = raw_input("Database name:")

  def __readConfig(self):
    """ Read database access info from config file. (private)"""
    confFn = self.__confFn
    try:
      config=ConfigParser.ConfigParser()
      config.read(confFn)
      self.__host    = config.get("MYSQL","HOST")
      self.__user    = config.get("MYSQL","USER")
      self.__passwd  = base64.b64decode(config.get("MYSQL","PASSWD"))
      self.__db      = config.get("MYSQL","DB")
    except ConfigParser.NoOptionError, err:
      sys.stderr.write("\nCannot parse the config file\n")
      sys.stderr.write("Switch to user input mode...\n\n")
      self.__readFromUser()

  def connect(self, databaseName = None):
    """
    Public interface to connect to DB.
    @param db:  If this exists it will be used.
    
    """
    if(os.path.exists(self.__confFn)):
      self.__readConfig()
    else:
      self.__readFromUser()

    n = 100
    for i in xrange(0,n+1):
      try:
        self.__conn = MySQLdb.connect (self.__host,self.__user,self.__passwd)
        if (databaseName):
          cursor = self.__conn.cursor()
          
          # If MySQL version < 4.1, comment out the line below
          cursor.execute("SET SQL_MODE=\"NO_AUTO_VALUE_ON_ZERO\"")
          cursor.execute("USE "+self.db())
        break


      except MySQLdb.Error, e:
        if (i < n):
          sleep(i*0.1)
          pass
        else:
          print ("LMODdb(%d): Error %d: %s" % (i, e.args[0], e.args[1]), file=sys.stderr)
          raise
    return self.__conn


  def db(self):
    """ Return name of db"""
    return self.__db


