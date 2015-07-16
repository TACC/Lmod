How Lmod Picks which Modulefiles to Load
========================================

Lmod uses the following rules to locate a modulefile:

#. It looks for an exact match in all ``MODULEPATH`` directories.
#. If the user requested name is a full name and version, and
   there is no exact match then it stops.
#. If the name doesn't contain a version then Lmod looks for a
   marked default in the first directory that has one.
#. Finally it looks for the "Highest" Version in all ``MODULEPATH``
   directories.


Marked a Version as Default
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Suppose you have several versions of the mythical UCC compiler suite::

      $ module avail ucc
      ---------- /opt/apps/modulefiles/Core -----------
      ucc/8.1   ucc/9.2   ucc/11.1   ucc/12.2 (D)

and you like to make the 11.1 version the default.  Lmod searches 
three different ways to mark a version as a default in the following
order.  The first way is to make a symbolic link between a file named
"``default``" and the desired default version. ::

    $ cd /opt/apps/modulefiles/Core/ucc; ln -s 11.1.lua default


A second way to mark a default is with a .modulerc file: ::
    
    #%Module
    module-version ucc/11.1 default


There is third method to pick the default module.  If you create a
.version file in the ucc that contains::

    #%Module
    set   ModulesVersion   "11.1"

Using any of the above three ways will change the default to version
11.1. ::

    $ module avail ucc
    ---------- /opt/apps/modulefiles/Core -----------
    ucc/8.1   ucc/9.2   ucc/11.1 (D)   ucc/12.2

Highest Version
~~~~~~~~~~~~~~~

If there is no marked default then Lmod chooses the "Highest" version
across all directories::

      $ module avail ucc

      ---------- /opt/apps/modulefiles/Core -----------
      ucc/8.1   ucc/9.2   ucc/11.1   ucc/12.2 

      ---------- /opt/apps/modulefiles/New -----------
      ucc/13.2 (D)

The "Highest" version is by version number sorting.  So Lmod "knows"
that the following versions are sorted from lowest to highest::

   2.4dev1
     2.4a1
  2.4beta2
    2.4rc1
       2.4
   2.4.0.0
     2.4-1
 2.4.0.0.1
     2.4.1
