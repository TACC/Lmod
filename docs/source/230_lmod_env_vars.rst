Controlling Lmod behavior through Environment Variables
=======================================================

Sites can control the behavior of Lmod via how lmod is configured.
To see all the configuration options you can execute::

  $ ./configure --help

in the Lmod source directory.  All of the configuration options can
also be overridden by environment variables as well as a few behavior
options that do not have a configuration option.

There two kinds of variables: (1) An explicit values; (2) a yes/no
variable.  An example of first kind is `LMOD_SITE_NAME`.  This
variable controls the site name (e.g. TACC). This value of variable is
used directly.  There is no change of case or any other changes.

The second kind of variable is an yes/no variable.  One example of
this is LMOD_IGNORE_CACHE.  When this variable is "yes", Lmod ignores
any cache files and walks MODULEPATH instead.

The following setting are considered "no".  ALL OTHER VALUES are "yes"

#. ""
#. 0
#. no
#. No
#. NO


   
   
