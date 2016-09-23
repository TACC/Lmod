Choices in handling module dependencies
=======================================

One module can depend on another: e.g. package XYZ depends on boost version 1.51.0

What choices does a site have?

Bullet points:

#. Have module XYZ have prereq("boost/1.51.0")
#. Use RPATH to make PACKAGE XYZ know where the right boost 1.51.0
   is.  The boost module doesn't need to be loaded.
#. Use load("boost/1.51.0") in the XYZ module.
#. Use always_load("boost/1.51.0") in the XYZ module.

Discuss.

