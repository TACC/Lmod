.. _lmod_code_conventions:

Lmod Code Conventions
^^^^^^^^^^^^^^^^^^^^^

This section is meant to be a secret decoder ring,  a trail map when traveling through the code of Lmod. 

Variable Naming 
~~~~~~~~~~~~~~~

The key data structure in Lua is table which can implement both a
dictionary or an array.  In Lmod, when a table is used as an array it
is decorated with a trailing A (e.g. moduleA, argA).  When a table is
used as a hash table (aka a dictionary) then it has a trailing T
(e.g. varT, spiderT).  Note that temporary loop variable typically do
not follow this convention.  Names like a, aa, b, c are used for
temporary arrays and t, tt are used for temporary tables.

Class names are written in camel case that starts with a uppercase
letter (e.g MName, Cosmic, FrameStk) and an instance start with a
lowercase letter (e.g mname, cosmic, frameStk)

Function Naming and location
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Functions named ``l_something`` () like ``l_lazyEval`` () are local functions 
and can only be called from inside that \*.lua file.  This helps in tracking 
where changes to a function.  Names without a leading ``l_`` are global in scope.
If they are not in a separate file like collectFileA.lua or loadModuleFile.lua 
they are typically found in src/util.lua

Design Pattern usage in Lmod
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Three design patterns are used in Lmod:

  1. Singletons:  Reference a single object instance no matter how many time a class is contructed.  This is used extensively throughout the code base.

  2. Factories:  Factories are used build the derived objects from a base case.  Examples include building ``mcp`` and  ``shell`` instances. 

  3. Template pattern: In l_lazyEval routine, Lmod loops over derived functions complete the search for a modulefile from the module name given.

..  Local Variables:
..  fill-column: 12345
..  End:
     
