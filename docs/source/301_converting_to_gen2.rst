.. _convert_gen1_gen2-label:

Converting to Gen2 of the Lmod database
=======================================

Lmod Version 8.7.54+ now supports a better version of the module
tracking database.  There are several reasons for this change:

1. The old version of the database relied on the MySQLdb python
   package which is no longer supported. This new version uses
   `mysql.connector.python`.  They are similar but not drop in
   replacements.

2. At our site, there are many common modules that almost all users
   load.  It is now possible to block storing these modules.

3. In studying our data, it became clear that many users were
   loading the same modules repeatedly during a day.  We have only
   been interested in distinct users use of modules.  Not how many
   times a user loaded a particular module.  So by default the
   `store_module_data` program only records the first use of a
   modulefile for a particular user on a cluster.  Site can record
   every module load if they chose.  We see over 100 times smaller
   number of rows in our database, which greatly speeds up searching.

4. It is now possible to remove old records.  At the beginning of each
   month we remove all records that are older than 12 months.


Detailed Steps to convert
~~~~~~~~~~~~~~~~~~~~~~~~~

Site can stop using the old data base and create another one.  But if
you want you can transfer data from the old database into the new
one.  You will be using the `dump_db` program from gen_1 and then
switching to the `gen_2` directory.


Step 1
------

Using dump_db program found in contrib/tracking_module_usage/gen_1,
please copy this file to where you have LMODdb.py and lmod_db.conf
then execute:

   $ ./dump_db --dbname lmod --start 2023-11 --Nmonths 13 --parentDir ~/lmod_db

This command assumes that you want to save records from the start of
November 2023 and that you have a directory called ~/lmod_db.  Wherever
~/lmod_db is located, the generated files may be quite large so chose
a directory where you have plenty of space.

This will create files named lmodV2_YYYY_MM_DD.json.

Step 2
------

Place or copy those \*.json files to the appropriate machine or
location where you can load then into the new "module_usage_tracking"
machine.

Step 3
------

Create the new database `lmodV2` as described in :ref:`tracking_usage`
and the lmodV2_db.conf file


Step 4
------

Now load the lmodV2_YYYY_MM_DD.json files into the new database with
the gen_2 version of `store_module_data`::

   $ store_module_data --delete ~/lmod_db/*.json

Step 5
------

Use the gen_2 version of analyzeLmodDB to test if the previous data is
now in lmodV2 database.


