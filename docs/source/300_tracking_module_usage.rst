.. _tracking_usage:

Tracking Module Usage
=====================

    **NOTE**
    This section describe the new version of the Lmod database for Lmod
    version (8.7.54+).  If your site has been using the previous version
    please see :ref:`convert_gen1_gen2-label` if you wish to convert the old
    generation (gen_1) to this version (gen_2).  The reasons why this
    version is better is discussed in the referenced section.  The
    tldr is that this new version stores much much less data.  At TACC
    we are seeing over 100 times less data stored.  It is also easier to
    remove older data.

    **NOTE**
    Please use the programs describe here that are found in
    contrib/tracking_module_usage/gen_2 


Once you have a module system, it can be important to know what
modules your users are using or not.  This ability collect in some
fashion has existed for a long time.  What is new here is a complete
solution: Using syslog to track module usage.  Then collect this data
into a database.

There are a number of steps but all are easy.  The following is an
overview.  I am going to explain our setup and point out where you
site may be different.  In this setup I will be assuming that you are
using a MySQL database (version 8.0+) and Rsyslog (version 8+)

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

   local function l_load_hook(t)
      -- the arg t is a table:
      --     t.modFullName:  the module full name: (i.e: gcc/4.7.2)
      --     t.fn:           The file name: (i.e /apps/modulefiles/Core/gcc/4.7.2.lua)
      --     t.mname:        The Module Name object. 

      local isVisible = t.mname:isVisible()


      -- use syshost from configuration if set
      -- otherwise extract 2nd name from hostname: i.e. login1.stampede2.tacc.utexas.edu
      -- Please modify the following code to match your site.
      local host        = syshost 
      if (not host) then
         local i,j, first
         host             = uname("%n")
         if (host:find("%.")) then
            i,j, first, host = host:find("([^.]*)%.([^.]*)%.")
         end
      end

      if (mode() ~= "load") then return end
      local msg         = string.format("user=%s module=%s path=%s host=%s time=%f",
                                        os.getenv("USER"), t.modFullName, t.fn, uname("%n"),
					epoch())
      s_msgT[t.modFullName] = msg                                        
   end

   hook.register("load", l_load_hook)

   local function l_report_loads()
      local openlog
      local syslog
      local closelog
      local logInfo
      if (posix.syslog) then
         if (type(posix.syslog) == "table" ) then
            -- Support new style posix.syslog table
            openlog  = posix.syslog.openlog
            syslog   = posix.syslog.syslog
            closelog = posix.syslog.closelog
            logInfo  = posix.syslog.LOG_INFO
         else
            -- Support original style posix.syslog functions
            openlog  = posix.openlog
            syslog   = posix.syslog
            closelog = posix.closelog
            logInfo  = 6
         end

         openlog("ModuleUsageTracking")
         for k,msg in pairs(s_msgT) do
            syslog(logInfo, msg)
         end
         closelog()
      else
         for k,msg in pairs(s_msgT) do
            lmod_system_execute("logger -t ModuleUsageTracking -p local0.info " .. msg)
         end
      end
   end

   ExitHookA.register(l_report_loads)

This code uses two "hook" functions.  The first is load_hook. This means that every load will
saved.  The second hook is called at exit.  If there were no errors then any module loads are
reported by sending a syslog message with the tag
"ModuleUsageTracking".  The **l_report_loads** () function shows how
to the luaposix interface to syslog if it is available.

Please read the file src/SitePackage.lua to see how to use the environment variable
LMOD_PACKAGE_PATH to point to your own SitePackage.lua or /etc/lmod/lmod_config.lua

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
   & stop

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

The above commands are in the language of rsyslog version 8+.  What
this says is accept outside syslog messages on port 514 and if any are
tagged with "ModuleUsageTracking" then write them to
/var/log/moduleUsage.log 

Remember to restart the rsyslog daemon on the "module_usage_tracking" machine.

Step 4
------

Sites may have firewall rules that will prevent master from
connecting.  After completing step 3, try sending syslog message from
your cluster to your "module_usage_tracking" machine with the command
`logger`::

   $ logger  -t ModuleUsageTracking -p local0.info -n 192.168.4.8 "Some test message"

where you have replaced 192.168.4.8 with the correct ip address of the
"module_usage_tracking" machine.  If the above message does not appear
on "module_usage_tracking" machine in /var/log/moduleUsage.log then
talk with your network team to fix the firewall rules.


Step 5
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
the second day before the log is rotated.  On our machines, it seems that the log rotate happens at about 3am.

Step 6
------

a) Install the pymysql via pip3 or your package manager

a) Create a mysql root password.  Then create an account in the database like this::

       $ mysql -u root -p
       Enter password:

       mysql> CREATE DATABASE lmodV2;

       mysql> CREATE USER 'lmodUser'@'localhost' IDENTIFIED WITH mysql_native_password BY 'test623';

       mysql> GRANT ALL ON lmodV2.* TO 'lmodUser'@'localhost';

       mysql> flush privileges;

       mysql> quit;

   You will want to change 'test623' to some other password.  You'll also probably want to allow access
   to this database from outside machines as well.

b) Use the "conf_create" program from the contrib/tracking_module_usage
   directory to create a file containing the access information for the db:: 

       $ ./conf_create
         Database host: localhost
         Database user: lmodUser
         Database pass:
         Database name: lmodV2

   Where you'll have to fill in the correct password.   This creates a file named
   lmodV2_db.conf which is used by createDB.py, analyzeLmodDB and other programs to access the database.


c) Make sure your python knows about the mysql.connector.python
   module. Please use pip or something similar if it is not already available.

d) Create the database by running the createDB.py program.::

      $ ./createDB.py

   Note that createDB.py support --drop to remove the old database.     


Step 7
------

a) If you have more than one cluster and you want to store them in the
   same database then make sure that your load_hook correctly sets the
   name of the cluster.

b) We use a cron job to load the moduleUsage.log-* files.   Here is the
   entry we use to record data.  This assumes that the account on
   "module usage machine" is swtools::

       13 4 * * * /home/swtools/load_module_usage/store_module_data --delete --confFn /home/swtools/load_module_usage/lmodV2_db.conf /var/log/moduleUsage.log-* > /home/swtools/load_module_usage/store.log 2>&1

Step 8
------

Setup a crontab entry to remove data older than a year on the
"module_usage_tracking" machine at the beginning of the month at 12:11 midnight::

     0 11 1 * * /home/swtools/load_module_usage/delete_old_records --keepMonths 12 --yes --confFn /home/swtools/load_module_usage/lmodV2_db.conf > /home/swtools/load_module_usage/delete.log 2>&1

Step 9
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
