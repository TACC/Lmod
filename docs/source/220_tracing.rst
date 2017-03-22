.. _tracing:

Tracing Lmod
============

Lmod supports a tracing option to report the major steps that Lmod
performs.  It can be set by either setting the ``LMOD_TRACING`` to
``yes`` or using the -T or --tracing option on the command line.  This
can be useful to understand what happens a shell startup.  By setting
``LMOD_TRACING`` to yes for a particular user you can see something
like the following for a user which as a default collection::

    running: module --initial_load restore
      Using collection:      /home/user/.lmod.d/default
      Setting MODULEPATH to :/opt/apps/modulefiles/Linux:/opt/apps/modulefiles/Core
      Loading: unix
      Loading: gcc
      Loading: noweb
      Loading: StdEnv
      Loading: mpich

  
