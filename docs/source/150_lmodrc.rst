.. _lmodrc-label:

The Properties File: lmodrc.lua
===============================

This discussion is under construction.

Notes:

#. The system lmodrc.lua is in init/lmodrc.lua.
#. It is copied to the init directory in the installation directory. 
#. During the install process this file is modified to include the
   location of the system spider cache.
#. Need to explain how the lmodrc table works.
#. Point out that sites (and users) can add properties
#. Explain how the validT and displayT entries work together.
#. Explain how short, long, color, and doc are used.
#. Explain that long is not used at the moment.


Show how module files can be marked::

   propT = {
      state = {
         validT = { experimental = 1, testing = 1, obsolete = 1 },
         displayT = {
            experimental  = { short = "(E)",  long = "(E)",     color = "blue",  doc = "Experimental", },
            testing       = { short = "(T)",  long = "(T)",     color = "green", doc = "Testing", },
            obsolete      = { short = "(O)",  long = "(O)",     color = "red",   doc = "Obsolete", },
         },
      },
   }  




