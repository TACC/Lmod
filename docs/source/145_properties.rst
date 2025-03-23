.. _lmodrc-label:

Module Properties
=================

Lmod support giving modules properties.  For modules written Lua, the
`add_property()` function looks like::

    add_property("key", "value")

In TCL, it is written as::

    add-property key value

The `key` and `value` are controlled by a file called lmodrc.lua.


The Properties File: lmodrc.lua
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Lmod provides a standard lmodrc.lua which is copied to the
installation directory.  For example Lmod version X.Y.Z is installed
in /apps/lmod/X.Y.Z then lmodrc.lua would be installed in
/apps/lmod/X.Y.Z/init/lmodrc.lua.  During the install process this
file is modified to include the location of the system spider cache. 

Lmod searches the properties in several location in order given
below.   Assuming again that Lmod is installed in /apps/lmod/X.Y.Z
then Lmod searches for the property information in the following order:

#. /apps/lmod/X.Y.Z/init/lmodrc.lua
#. /apps/lmod/etc/lmodrc.lua
#. $LMOD_CONFIG_DIR/lmodrc.lua (default /etc/lmod/lmodrc.lua)
#. /etc/lmodrc.lua
#. $HOME/.lmodrc.lua
#. $LMOD_RC

Where $LMOD_RC is an environment variable that can be set to point to
any file location. If there are more than one of these files exist
then they are merged and not a replacement.  So a site can (and
should) leave the first file as is and create another one to specify
site properties and Lmod will merge the information into one.



The format of this file looks like::

   local i18n = require("i18n")
   propT = {
      arch = {
         validT = { mic = 1, offload = 1, gpu = 1, },
         displayT = {
            ["mic:offload"]     = { short = "(*)",  color = "blue", full_color = false, doc = "built for host, native MIC and offload to the MIC",  },
            ["mic"]             = { short = "(m)",  color = "blue", full_color = false, doc = "built for host and native MIC", },
            ["offload"]         = { short = "(o)",  color = "blue", full_color = false, doc = "built for offload to the MIC only",},
            ["gpu"]             = { short = "(g)",  color = "red" , full_color = false, doc = "built for GPU",},
            ["gpu:mic"]         = { short = "(gm)", color = "red" , full_color = false, doc = "built natively for MIC and GPU",},
            ["gpu:mic:offload"] = { short = "(@)",  color = "red" , full_color = false, doc = "built natively for MIC and GPU and offload to the MIC",},
         },
      }, 
      state = {
         validT = { experimental = 1, testing = 1, obsolete = 1 },
         displayT = {
            experimental  = { short = "(E)", full_color = false,  color = "blue",  doc = i18n("ExplM"), },
            testing       = { short = "(T)", full_color = false,  color = "green", doc = i18n("TstM"), },
            obsolete      = { short = "(O)", full_color = false,  color = "red",   doc = i18n("ObsM"), },
         },
      },
      lmod = {
         validT = { sticky = 1 },
         displayT = {
            sticky = { short = "(S)",  color = "red",    doc = i18n("StickyM"), }
         },
      },
      status = {
         validT = { active = 1, },
         displayT = {
            active = { short = "(L)",  color = "yellow", doc = i18n("LoadedM")},
        },
      },
   }  


This file defines a table called propT.  A table is a generic name for
a hash table or dictionary or associative array.  That is, it stores
key value pairs.  It is an Lmod convention that a table is named with
a trailing T to remind us that it is a table.

In this case propT defines the valid keys and values that are possible
for a modulefile to use with `add_property()`.  In the case of the
above table, the only valid keys in a modulefile would be `arch`, `state`,
`lmod` and `status`.

The value for `state` controls the valid values.  In particular, the
only valid values for `state` are `experimental`, `testing` or
`obsolete`.  Please note that a modulefile can have multiple
properties but each property key can have only one value.  So::

    add_property("state","testing")
    add_property("state","obsolete")

would make the `state` property have a value of `obsolete`.  On the
other hand a modulefile could have two or more properties.::

    add_property("state","testing")
    add_property("lmod","sticky")

Lmod itself depends on the keys `lmod` and `status`.  So as a site, it
is expected that any lmodrc.lua file will contain these properties.

The tables `validT` and `displayT`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The function `add_property()` expects a key and value.  So for the
`state` key, possible value are `experimental`, `testing` or
`obsolete`.  Those strings must appear in two tables: the `validT` and
the `displayT` tables. For example, we can see that `testing` appears
both in the `validT` and `displayT` tables.  This exist for checking
for valid values when the `add_property()` function is called from
modulefiles.

The `displayT` table controls how the property is displayed.  The
fields in the table controls how a property is displayed.  For
example::

   testing = { short = "(T)", full_color = false,  color = "green", doc = i18n("TstM"), },

says that a module with this property will have a '(T)' next to its
name when printed by module avail.  If the terminal display has
"xterm" as part of the environment variable TERM.  then the 'T' will
be in green.  If the field `full_color` is set to `true` then the name
and 'T' will be in green.

The possible color values are: `black`, `red`, `green`, `yellow`,
`blue`, `magenta`, `cyan`, and `white`.  In practice, since users can
use light letters on dark backgrounds or dark letters on light
backgrounds, sites may wish to avoid `black`, `white` and possibly
`yellow`. 

The arch key shows that the the values can be combined.  If the value
is colon separated then each string between the colons have to be
valid keys.
