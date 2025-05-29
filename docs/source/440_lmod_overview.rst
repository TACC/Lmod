Lmod Overview
~~~~~~~~~~~~~

This overview is for developers who wish to understand how Lmod works.   

In Lmod simplist terms takes commands from the user to change the state of the user's environment.  
It does this by loading and unloading modulefiles. When Lmod takes a command, it modifies an internal
table of key value pairs.   
  It also provides a command line interface to the user to query the state of the environment.
