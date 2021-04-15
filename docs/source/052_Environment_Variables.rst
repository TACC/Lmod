Lmod Environment variables
==========================

Environment variables defined by Lmod startup files
---------------------------------------------------


**LMOD_CMD** : The path to the installed lmod command.

**LMOD_DIR** : The directory that contains the installed lmod
    command.  This environment variable is usefull for running the
    **spider** command: i.e. $LMOD_DIR/spider.  This is the libexec directory

**LMOD_PKG** : This the path the directory that contains the libexec,
    init etc directories.

**LMOD_ROOT** : the parent directory of LMOD_PKG.

**LMOD_sys**  : Typically what uname -s returns.

**LMOD_VERSION** : The current version of Lmod.

**LMOD_SETTARG_FULL_SUPPORT** : If this environment variable is set
   then when the settarg module is loaded several shell functions are
   defined such as "targ".  See the :ref:`settarg-label` for more details.

Lmod Environment variables defined when evaluating a modulefile
---------------------------------------------------------------

**LMOD_VERSION_MAJOR** : The current major version.  If it is X.Y.Z
     then X is returned (i.e.  10.14.17 -> 10) (exists for Lmod 5.1.5+)

**LMOD_VERSION_MINOR** : The current minor version.  If it is X.Y.Z
     then Y is returned (i.e.  10.14.17 -> 14) (exists for Lmod 5.1.5+)

**LMOD_VERSION_SUBMINOR** : The current subminor version.  If it is X.Y.Z
     then Z is returned (i.e.  10.14.17 -> 17) (exists for Lmod 5.1.5+)

**ModuleTool** : This environment variable is defined to be
     **Lmod**. (exists for Lmod 8.4.7+)  It is defined in Tmod
     version 4.7+ as "Modules"
  
**ModuleToolVersion** :  Current Version of Lmod (exists for Lmod
     8.4.7+). It also reports the version of Tmod as of version 4.7 or
     later. 

Environment variables to change Lmod behavior
---------------------------------------------

See :ref:`env_vars-label` for the list of env. variables that change
the behavior of Lmod.

