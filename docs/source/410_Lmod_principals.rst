Notes for Lmod Principals:

Module Naming
~~~~~~~~~~~~~

FullName -> shortname/version
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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
_ModuleTable001_ and _ModuleTable_Sz_

Other environment variables used by Lmod internally all start with
__LMOD_

Lmod communicates with users via a group of env. vars
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Thing like LMOD_CMD and LMOD_DIR etc.





