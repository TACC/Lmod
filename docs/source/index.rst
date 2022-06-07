
Lmod: A New Environment Module System
=====================================

Monthly Zoom Meeting
====================

      **NOTE**
      Lmod is holding Monthly Zoom meeting to discuss various topics.
      Typically the first Tuesday of the Month at 9:30 U.S. Central. Which
      is 14:30 UTC or 15:30 UTC in the winter months.

      See: https://github.com/TACC/Lmod/wiki for details


PURPOSE
^^^^^^^

Lmod is a Lua based module system that easily handles the MODULEPATH
Hierarchical problem. Environment Modules provide a convenient way to
dynamically change the users' environment through modulefiles. This
includes easily adding or removing directories to the PATH environment
variable. Modulefiles for Library packages provide environment
variables that specify where the library and header files can be
found.

OVERVIEW
^^^^^^^^

This guide is written to explain what Environment Modules are and why
they are very useful for both users and system administrators. Lmod is
an implementation of Environment Modules, much of what is said here is
true for any environment modules system but there are many features
which are unique to Lmod.

Environment Modules provide a convenient way to dynamically change the
users' environment through modulefiles. This includes easily adding or
removing directories to the PATH environment variable.

A modulefile contains the necessary information to allow a user to run
a particular application or provide access to a particular
library. All of this can be done dynamically without logging out and
back in. Modulefiles for applications modify the user's path to make
access easy. Modulefiles for Library packages provide environment
variables that specify where the library and header files can be
found.

Packages can be loaded and unloaded cleanly through the module
system. All the popular shells are supported: bash, ksh, rc, csh, tcsh,
fish, zsh.  Also available for perl, python, lisp, cmake, and R.

It is also very easy to switch between different versions of a package
or remove it.

Lmod Web Sites
^^^^^^^^^^^^^^

    * Documentation:          https://lmod.readthedocs.io/en/latest/
    * GitHub:                 https://github.com/TACC/Lmod
    * SourceForge:            https://lmod.sf.net
    * TACC Homepage:          https://www.tacc.utexas.edu/research-development/tacc-projects/lmod
    * Lmod Test Suite:        https://github.com/rtmclay/Lmod_test_suite
    * Join Lmod Mailing list: https://sourceforge.net/projects/lmod/lists/lmod-users

The most up-to-date source is at github. There is a secondary git repo
found at SourceForge. Both repos are the same. Stable releases in the
form of tar files can be found at Sourceforce. All label versions found
at the git repos have passed Lmod's regression test suite.


Introduction to Lmod
^^^^^^^^^^^^^^^^^^^^

If you are new to Lmod then please read the User Guide and possibly
the Frequently Asked Questions Guide.   Users who wish to read about
how to have their own personal modules should read the Advanced User Guide.

.. toctree::
   :maxdepth: 1

   010_user
   015_writing_modules
   040_FAQ
   020_advanced
   025_new

Installing Lmod
^^^^^^^^^^^^^^^

Anyone wishing to install Lmod on a personal computer or for a system
should read the Installation Guide as well as the Transitioning to
Lmod Guide.  The rest of the guides can be read as needed.

.. toctree::
   :maxdepth: 1

   030_installing
   045_transition
   050_lua_modulefiles
   051_tcl_modulefiles
   052_Environment_Variables
   055_module_names
   060_locating
   070_standard_modules
   073_tmod_to_lmod

Advanced Topics
^^^^^^^^^^^^^^^

.. toctree::
   :maxdepth: 1
   
   075_bug_reporting
   077_ref_counting
   080_hierarchy
   090_configuring_lmod
   093_modulerc
   095_tcl2lua
   098_dependent_modules
   100_modulefile_examples
   110_lmod_mpi_parallel_filesystem
   120_shared_home_directories
   125_personal_spider_cache
   130_spider_cache
   135_module_spider
   136_spider
   140_deprecating_modules
   145_properties
   160_debugging_modulefiles
   170_hooks
   185_localization
   190_Integration_of_EasyBuild_and_Lmod
   200_avail_custom
   210_load_storms
   220_tracing
   240_sticky_modules
   250_site_package
   260_sh_to_modulefile
   300_tracking_module_usage
   310_settarg
   320_improving_perf
   330_extensions
   340_inherit
   350_community

Internal Structure of Lmod
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. toctree::
   :maxdepth: 1

   400_code_conventions


Topics yet to be written
^^^^^^^^^^^^^^^^^^^^^^^^

#. Optional Software layout, two digit rule
#. Advanced Topics: priority path,



Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
