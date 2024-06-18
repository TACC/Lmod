Notes for Lmod Principals:

Module Naming
~~~~~~~~~~~~~

FullName -> shortname/version
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

N/V vs. C/N/V
~~~~~~~~~~~~~
Lmod supports names like gcc/10.1 where gcc is the shortname and 10.1
is the version.  It also supports C/N/V which is
category/name/version.  So a module can be named compiler/gcc/10.1
where the shortname is compiler/gcc and the version is 10.1.  The
number of categories can be as many as a site wants to use.  It is
just more typing.  Internally, Lmod only separates the fullName into a
shortname (sn) and a version.

N/V vs. N/V/V
~~~~~~~~~~~~~

Starting with version 7+, Lmod support two or more levels of versions
(namely N/V/V). So sites might name a module gcc/x86_64/10.1, where the
shortname is gcc and the version is x86_64/10.1. The depth of version
is unlimited as is the number of names. So a site might name a module:
compiler/gcc/x86_64/10.1 where the shortname is compiler/gcc and the
version is x86_64/10.1

See the discussion about consequences of using N/V/V vs. N/V in ...







One Name Rule
~~~~~~~~~~~~~
It is really the one shortname (or sn) rule.  A user can only load one
module named "gcc"

ModuleTable
~~~~~~~~~~~

The current state of modules is stored in a Lua table (The key-value
pairs are stored in a table. In this case it is called the
ModuleTable.  This internal table is written out into the environment
and converted into base64 encoding and stored in blocks of 256
characters.

Load means load
~~~~~~~~~~~~~~~

When a user requests a module to be loaded, it is loaded even if it is
already loaded.  If a user requests "module load foo" and foo is
already loaded, then "foo" is unload and reloaded.


Modules loading other module should use depends_on()
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Unloading a module can never fail
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Even if unloading a module has an error in it, it is unloaded.  The
error is treated as a warning.

Base64 encoding is used a great deal
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Encoding text strings can be converted to base64 encoding.  This
means that all spaces and quotes are hidden from shell interpretation.

The ModuleTable is encoded as:
_ModuleTable_Sz_ and _ModuleTable001_ _ModuleTable002_ ...

Other environment variables used by Lmod internally all start with
__LMOD_

Lmod communicates with users via a group of env. vars
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Thing like LMOD_CMD and LMOD_DIR etc.





