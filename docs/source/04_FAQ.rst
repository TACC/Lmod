Frequently Asked Questions
==========================

Why doesn't  % ``module avail |& grep ucc``  work under tcsh and works under bash?

    It is a bug in the way tcsh handles evals. This works::

       % (module avail) |& grep ucc.

    However, in all shells it is better use::

       % module avail ucc
    
    instead as this will only output modules that have "ucc" in
    their name. 

Why are messages printed to standard error and not standard out

    The module command is an alias under tcsh and a shell routine under
    all other shells. There is an lmod command which writes out commands
    such as export FOO="bar and baz" and message are written to standard
    error. The text written to standard out is evaluated so that the text
    strings make changes to the current environment. 

Can I disable the pager output?

   Yes, you can.  Just set the environment variable ``LMOD_PAGER`` to
   **none**.

Can I force the output of list, avail and spider to go to stdout
instead of stderr?

   Bash and Zsh user can set the environment variable
   ``LMOD_REDIRECT`` to **yes**.  Sites can configure Lmod to work
   this way by default.  No matter how Lmod is set-up however, this
   will not work with Tcsh/csh. 

Can I ignore the spider cache files when doing ``module avail``?

   Yes you can:

      module --ignore_cache avail


Why doesn't the module command work in shell scripts?

 First the script must be a bash script and not a shell script, so
 start the script with #!/bin/bash. The second is that the environment
 variable BASH_ENV must point to a file which defines the module
 command. The simpliest way to is to have BASH_ENV point to
 /opt/apps/lmod/lmod/setup/bash or where ever this file is located on
 your system. This is done by the standard install.  Finally Lmod
 exports the module command for Bash shell users.  

How to I use the initializing shell script that comes with this application with Lmod?

 The short answer is you don't. Among the many problems is that there
 is no way to unload that shell script. If the script is simple you
 can read it through and create a modulefile. To simplify this task,
 Lmod provides the ``sh_to_modulefile`` script to convert shell
 scripts to modulefiles.

