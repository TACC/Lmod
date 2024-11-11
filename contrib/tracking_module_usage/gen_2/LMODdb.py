from __future__ import print_function
from time       import sleep
import os, sys, re, base64, time, json, traceback
dirNm, execName = os.path.split(os.path.realpath(sys.argv[0]))
sys.path.append(os.path.realpath(dirNm))

try:
  input = raw_input
except:
  pass

try:
  import configparser
except:
  import ConfigParser as configparser

import mysql.connector, getpass
import warnings, inspect
from BeautifulTbl import BeautifulTbl
warnings.filterwarnings("ignore", "Unknown table.*")
def __LINE__():
    try:
        raise Exception
    except:
        return sys.exc_info()[2].tb_frame.f_back.f_lineno

def __FILE__():
    return inspect.currentframe().f_code.co_filename

#print ("file: '%s', line: %d" % (__FILE__(), __LINE__()), file=sys.stderr)

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
  moduleT         = {}

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

    self.__host   = input("Database host:")
    self.__user   = input("Database user:")
    self.__passwd = getpass.getpass("Database pass:")
    self.__db     = input("Database name:")

  def __readConfig(self):
    """ Read database access info from config file. (private)"""
    confFn = self.__confFn
    try:
      config=configparser.ConfigParser()
      config.read(confFn)
      self.__host    = config.get("MYSQL","HOST")
      self.__user    = config.get("MYSQL","USER")
      self.__passwd  = base64.b64decode(config.get("MYSQL","PASSWD")).decode()
      self.__db      = config.get("MYSQL","DB")
    except configparser.NoOptionError as err:
      sys.stderr.write("\nCannot parse the config file\n")
      sys.stderr.write("Switch to user input mode...\n\n")
      print(traceback.format_exc())
      self.__readFromUser()

  def connect(self):
    """
    Public interface to connect to DB.
    @param db:  If this exists it will be used.

    """
    if(os.path.exists(self.__confFn)):
      self.__readConfig()
    else:
      self.__readFromUser()

    try: 
      self.__conn = mysql.connector.connect(
        host     = self.__host,
        user     = self.__user,
        password = self.__passwd,
        database = self.__db,
        charset  ="utf8",
        connect_timeout=120)

      cursor = self.__conn.cursor()
      
      cursor.execute("SET SQL_MODE=\"NO_AUTO_VALUE_ON_ZERO\"")
      cursor.execute("USE "+self.__db)

      #self.__conn.set_character_set('utf8')
      cursor.execute("SET NAMES utf8;") #or utf8 or any other charset you want to handle
      cursor.execute("SET CHARACTER SET utf8;") #same as above
      cursor.execute("SET character_set_connection=utf8;") #same as above
    except Exception as e:
      print ("XALTdb: Error: %s %s" % (e.args[0], e.args[1]))
      print(traceback.format_exc())
      raise
    return self.__conn

  def db(self):
    """ Return name of db"""
    return self.__db



  def data_to_db(self, debug, dataInA):
    """
    Store data into database.
    @param dataA: An array of dataT entries
    """

    dataA = []
    
    for dataT in dataInA:
      user    = dataT.get('user')
      module  = dataT.get('module')
      path    = dataT.get('path')
      syshost = dataT.get('syshost')
      dateStr = dataT.get('date')
      if (not (user and module and path and syshost and dateStr)):
        continue
      user    = user[:64].encode("ascii","ignore")
      module  = module[:64].encode("ascii","ignore")
      path    = path[:1024].encode("ascii","ignore")
      syshost = syshost[:32].encode("ascii","ignore")
      dateStr = dateStr.encode("ascii","ignore")
      dateTm  = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(float(dateStr)))
      a = [ user,  module, path,  syshost, dateTm ]
      dataA.append(a)

    query = ""
    try:
      if (debug): print("  --> Trying to connect to database")
      conn   = self.connect()
      cursor = conn.cursor()
      query  = "USE "+self.db()
      cursor.execute(query)
      query  = "START TRANSACTION"
      cursor.execute(query)

      
      query   = "INSERT INTO moduleT (id, user, module, path, syshost, date) VALUES(NULL, %s,  %s,  %s,  %s,  %s)"
      cursor.executemany(query, dataA)
      conn.commit()
      conn.close()

    except Exception as e:
      print("query: ",query)
      print("data_to_db(): ",e)
      sys.exit(1)

  def build_dateTest(self, startDate, endDate):
    dateTest = ""
    if (startDate != "unknown"):
      dateTest = " and date >= '" + startDate + "'"
      
    if (endDate != "unknown"):
      dateTest = dateTest + " and date < '" + endDate + "'"
    return dateTest
    

  def counts(self, sqlPattern, syshost, startDate, endDate, allmodulesFn):
    query = ""
    try:
      conn   = self.connect()
      cursor = conn.cursor()
      query  = "USE "+self.db()
      cursor.execute(query)

      dateTest = self.build_dateTest(startDate, endDate)

      if (sqlPattern == "") :
        sqlPattern == "%"

      query = "SELECT path, count(distinct(user)) as counts from moduleT " +\
              "where path like %s and syshost like %s " + dateTest + " group by path order by counts desc"


      cursor.execute(query, (sqlPattern, syshost))
      myResultA = cursor.fetchall()

      resultT = {}
      sT      = {}

      if (allmodulesFn):
        with open(allmodulesFn) as fp:
          lineA = fp.readlines()
          for moduleNm in lineA:
            moduleNm          = moduleNm.strip()
            resultT[moduleNm] = { 'syshost' : syshost, 'nUsers' : 0 }
            sT[moduleNm]      = 0
      

      for row in myResultA:
        moduleNm = row[0]
        resultT[moduleNm] = { 'syshost' : syshost, 'nUsers' : row[1] }
        sT[moduleNm]      = row[1]
  
      resultA = []
      resultA.append(["Module path", "Syshost", "Distinct Users" ])
      resultA.append(["-----------", "-------", "--------------"])
      sT_view = [ (v,k) for k,v in sT.items() ]
      sT_view.sort(reverse=True)
      for v,k in sT_view:
        resultA.append([k, resultT[k]['syshost'], resultT[k]['nUsers'] ])

      conn.close()

      return resultA
      
    except Exception as e:
      print("counts(): ",e)
      sys.exit(1)


  def usernames(self, sqlPattern, syshost, startDate, endDate):
    query = ""
    try:
      conn   = self.connect()
      cursor = conn.cursor()
      query  = "USE "+self.db()
      cursor.execute(query)

      dateTest = self.build_dateTest(startDate, endDate)

      if (sqlPattern == "") :
        sqlPattern == "%"

      query = "SELECT path, user from moduleT where path like %s and syshost like %s " +\
        dateTest + " group by user, path order by path"

      cursor.execute(query, (sqlPattern, syshost))
      myResultA = cursor.fetchall()

      resultA = []
      resultA.append(["Module path", "Syshost", "User Name"])
      resultA.append(["-----------", "-------", "---------"])

      for row in myResultA:
        resultA.append([row[0],syshost,row[1]])

      conn.close()
      return resultA

    except Exception as e:
      print("usernames(): ",e)
      sys.exit(1)

  def modules_used_by(self, username, syshost, startDate, endDate):
    query = ""
    try:
      conn   = self.connect()
      cursor = conn.cursor()
      query  = "USE "+self.db()
      cursor.execute(query)

      dateTest = self.build_dateTest(startDate, endDate)

      query = "SELECT path, user from moduleT where user = %s and syshost like %s " +\
              dateTest + " group by user,path order by path"

      cursor.execute(query, ( username, syshost ))
      myResultA = cursor.fetchall()

      resultA = []
      resultA.append(["Module path", "Syshost", "User Name"])
      resultA.append(["-----------", "-------", "---------"])


      for row in myResultA:
        resultA.append([row[0],syshost,row[1]])

      conn.close()

      return resultA


    except Exception as e:
      print("modules_used_by(): ",e)
      sys.exit(1)

  def delete_old_records(self, debug, syshost, startDate, endDate):
    query = ""
    try:
      conn   = self.connect()
      cursor = conn.cursor()
      query  = "USE "+self.db()
      cursor.execute(query)

      dateTest = self.build_dateTest(startDate, endDate)
    
      query = "DELETE FROM moduleT where syshost like %s  " + dateTest
      print(query)
      cursor.execute(query, [syshost])
      conn.commit()
      print(cursor.rowcount, "record(s) deleted")

    except Exception as e:
      print("delete_old_records(): ",e)
      sys.exit(1)
