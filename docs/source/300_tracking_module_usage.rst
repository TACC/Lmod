.. _tracking_usage:

Tracking Module Usage
=====================

Once you have a module system, it can be important to know what
modules your users are using or not.  This ability collect in some
fashion has existed for a long time.  What is new here is a complete
solution: Using syslog to track module usage.  Then collect this data
into a database.

There are a number of steps but all are easy.  The following is an
overview.  I am going to explain our setup and point out where you
site may be different.  In this setup I will be assuming that you are
using a MySQL database and Rsyslog (version 5.8)

For a cluster, it is common to have each node in that cluster to send
its syslog messages to a single central machine (called master in this
discussion).  I will be sending the module usage message through syslog
to a separate machine.  That separate machine will collect the module
tracking data into a log file that just contains tracking data.  Finally
this data is written into the database.

Also provided is a script to analyze the data as shown below::

    $ analyzeLmodDB --sqlPattern '%fftw%' counts --start '2015-01-01 --end '2015-02-01'

    Module path                                         Distinct Users
    -----------                                         --------------
    /apps/intel13/mvapich2_1_9/modulefiles/fftw3/3.3.2             151
    /apps/intel13/mvapich2_1_9/modulefiles/fftw2/2.1.5              62
    /apps/intel13/impi_4_1/modulefiles/fftw3/3.3.2                  45
    /apps/intel13/impi_4_1/modulefiles/fftw2/2.1.5                  19

This shows number of users of any fftw module for the first month of 2015.

Detailed Steps
~~~~~~~~~~~~~~

Step 1
------

Use SitePackage.lua to send a message to syslog.::

   --------------------------------------------------------------------------
   -- load_hook(): Here we record the any modules loaded.

   local hook    = require("Hook")
   local uname   = require("posix").uname
   local cosmic  = require("Cosmic"):singleton()
   local syshost = cosmic:value("LMOD_SYSHOST")

   local s_msgT = {}

   local function load_hook(t)
      -- the arg t is a table:
      --     t.modFullName:  the module full name: (i.e: gcc/4.7.2)
      --     t.fn:           The file name: (i.e /apps/modulefiles/Core/gcc/4.7.2.lua)
      --     t.mname:        The Module Name object. 

      local isVisible = t.mname:isVisible()


      -- use syshost from configuration if set
      -- otherwise extract 2nd name from hostname: i.e. login1.stampede2.tacc.utexas.edu
      local host        = syshost 
      if (not host) then
         local i,j, first
         i,j, first, host = uname("%n"):find("([^.]*)%.([^.]*)%.")
      end
      

      if (mode() ~= "load") then return end
      local msg         = string.format("user=%s module=%s path=%s host=%s time=%f",
                                        os.getenv("USER"), t.modFullName, t.fn, uname("%n"),
					epoch())
      s_msgT[t.modFullName] = msg                                        
   end

   hook.register("load", load_hook)

   local function report_loads()
      for k,msg in pairs(s_msgT) do
         lmod_system_execute("logger -t ModuleUsageTracking -p local0.info " .. msg)      
      end
   end

   ExitHookA.register(report_loads)

This code uses two "hook" functions.  The first is load_hook. This means that every load will
saved.  The second hook is called at exit.  If there were no errors then any module loads are
reported by sending a syslog message with the tag "ModuleUsageTracking"

Please read the file src/SitePackage.lua to see how to use the environment variable
LMOD_PACKAGE_PATH to point to your own SitePackage.lua.

You should check to see that Lmod finds your SitePackage.lua.  If you do::

   $ module --config

and it reports::

   Modules based on Lua: Version X.Y ...
       by Robert McLay mclay@tacc.utexas.edu

   Description                      Value
   -----------                      -----
   ...
   Site Pkg location                standard

Then you haven't set things up correctly.



Step 2
------

Have "master" send the tracking messages to a separate computer.

You can add the following to master's /etc/rsyslog.conf file::

   if $programname contains 'ModuleUsageTracking' then @module_usage_tracking
   &~

Where you change "module_usage_tracking" into a real machine name.
Adding this to rsyslog.conf will direct all syslog messages to be sent
to the "module_usage_tracking" machine. 

Remember to restart the rsyslog daemon on master.

Step 3
------

On the "module_usage_tracking" machine you add to /etc/rsyslog.conf the following::


    # read in include files
    $IncludeConfig /etc/rsyslog.d/*.conf...

Then in /etc/rsyslog.d/moduleTracking.conf::

    $Ruleset remote
    if $programname contains 'ModuleUsageTracking' then /var/log/moduleUsage.log
    $Ruleset RSYSLOG_DefaultRuleset

    # provides UDP syslog reception
    $ModLoad imudp
    $InputUDPServerBindRuleset remote
    $UDPServerRun 514

The above commands are in the language of rsyslog version 5.8.  What
this says is accept outside syslog messages on port 514 and if any are
tagged with "ModuleUsageTracking" then write them to
/var/log/moduleUsage.log 

Remember to restart the rsyslog daemon on the "module_usage_tracking" machine.


Step 4
------

Create the file /etc/logrotate.d/moduleUsage::

    /var/log/moduleUsage.log{
       missingok
       copytruncate
       rotate 4
       daily
       create 644 root root
       notifempty
    }


This will log rotate the moduleUsage.log.  Remember to restart the logrotate daemon.  Note that it will be
the second day before the log is rotated.  On Centos machines, it seems that the log rotate happens at about 3am.

Step 5
------

I found the following site helpful in getting the MySQL database setup::

    http://zetcode.com/db/mysqlpython/

a) Install MySQL db. Create a mysql root password.  Then create an account in the database like this::

       $ mysql -u root -p
       Enter password:

       mysql> CREATE DATABASE lmod;

       mysql> CREATE USER 'lmod'@'localhost' IDENTIFIED BY 'test623';

       mysql> USE lmod;

       mysql> GRANT ALL ON lmod.* TO 'lmod'@'localhost';

       mysql> flush privileges;

       mysql> quit;

   You will want to change 'test623' to some other password.  You'll also probably want to allow access
   to this database from outside machines as well.

b) Use the "conf_create" program from the contrib/tracking_module_usage
   directory to create a file containing the access information for the db:: 

       $ ./conf_create
       Database host:
       Database user: lmod
       Database pass:
       Database name: lmod

   Where you'll have to fill in the correct name for the database host and password.   This creates a file named
   lmod_db.conf which is used by createDB.py, analyzeLmodDB and other programs to access the database.


c) Make sure your python knows about the MySQLdb module. Please use pip or something similar if it is unavailable.


d) Create the database by running the createDB.py program.::

      $ ./createDB.py



Step 6
------

a) If you have more than one cluster and you want to store them in the
   same database you might want to modify the store_module_data
   program found in the contrib/tracking_module_usage directory.  It
   assumes that host names are of the form:
   node_name.cluster_name.something.something and the current
   store_module_data program picks off the second field in the
   hostname.  If your site names things differently you should modify
   that routine to match your needs.


b) I use a cron job to load the moduleUsage.log-* files.   This is the script I use::

       #!/bin/bash

       PATH=<path_to_python3>:$PATH
       cd ~mclay/load_module_usage

       for i in /var/log/moduleUsage.log-*; do
         ./store_module_data $i
         if [ "$?" -eq 0 ]; then
           rm -f $i
         fi
       done

Where <path_to_python3> has a python3 that can also import MySQLdb python module.
If it is not already installed, you can do::

    $ pip3 install mysqlclient
  
Also you'll probably want to change ~mclay/load_module_usage to where ever you have
the store_module_data program and lmod_db.conf files.  

I am running this cron job on the "module_usage_tracking" machine at 5am every morning.
This is after the log rotation has been done.


Step 7
------

Once data is being written to the database you can now start analyzing the data.  You can use SQL commands directly
into the MySQL data base or you can use the supplied script found in
the contrib/tracking_module_usage directory:  analyseLmodDB::

	% ./analyzeLmodDB --help
	usage: analyzeLmodDB [-h] [--dbname DBNAME] [--syshost SYSHOST]
	                     [--start STARTDATE] [--end ENDDATE]
	                     [--sqlPattern SQLPATTERN]
	                     cmdA [cmdA ...]

	positional arguments:
	  cmdA                    commands: counts, usernames, modules_used_by

	optional arguments:
	  -h, --help              show this help message and exit
	  --dbname DBNAME         lmod db name
	  --syshost SYSHOST       system host name
	  --start STARTDATE       start date
	  --end ENDDATE           end date
	  --sqlPattern SQLPATTERN sql pattern for matching

There are three kinds of reports this program will report.  Only one command at a time.

a) counts:  Report the number of distinct users of a particular module::

    $ analyzeLmodDB --sqlPattern '%fftw%' --start '2015-01-01 --end '2015-02-01'  counts

        Module path                                         Distinct Users
        -----------                                         --------------
        /apps/intel13/mvapich2_1_9/modulefiles/fftw3/3.3.2             151
        /apps/intel13/mvapich2_1_9/modulefiles/fftw2/2.1.5              62
        /apps/intel13/impi_4_1/modulefiles/fftw3/3.3.2                  45
        /apps/intel13/impi_4_1/modulefiles/fftw2/2.1.5                  19

   To get all modules loaded in a date range do::

     $ analyzeLmodDB --sqlPattern '%' --start '2015-01-01 --end '2015-02-01'  counts

b) usernames:  Report users of a particular pattern::

     $ ./analyzeLmodDB --sqlPattern '%/apps/modulefiles/settarg%' usernames

     Module path                            User Name
     -----------                            ---------
     /opt/apps/modulefiles/settarg/5.8      user1
     /opt/apps/modulefiles/settarg/5.8      user2
     /opt/apps/modulefiles/settarg/5.8      user3
     /opt/apps/modulefiles/settarg/5.8.1    mclay
     /opt/apps/modulefiles/settarg/5.9.1    user5


c) modules_used_by:  Report the modules used by a particular user::

     $ ./analyzeLmodDB --start '2015-01-01 --end '2015-02-01' --sqlPattern 'mclay' modules_used_by

     Module path                                                            User Name
     -----------                                                            ---------
     /opt/apps/gcc4_9/modulefiles/boost/1.55.0.lua                          mclay
     /opt/apps/gcc4_9/modulefiles/mvapich2/2.1                              mclay
     /opt/apps/gcc4_9/mvapich2_2_1/modulefiles/phdf5/1.8.16.lua             mclay
     /opt/apps/gcc4_9/mvapich2_2_1/modulefiles/pmetis/4.0.2.lua             mclay
     /opt/apps/intel13/modulefiles/boost/1.55.0.lua                         mclay
     /opt/apps/intel13/modulefiles/mvapich2/1.9a2                           mclay


Tracking user loads and not dependent loads
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Some sites would like to track the modules loaded by users
directly and not the dependent loads.  If your site wished to do that
then look at the directory in the source tree:
**contrib/more_hooks**.  In that directory is a SitePackage.lua file
as well as README.md which explains how to just track user loads.
