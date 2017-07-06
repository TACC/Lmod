The spider tool
===============

Lmod provides a tool called *spider* to build the spider cache and
other files that can help a site manage their modulefiles.  The shell
script *update\_lmod\_system\_cache\_files* described in
:ref:`update_cache_sh-label` uses the spider command to build the
spiderT.lua file which is the filename of the spider cache.  The
command *spider* is different from the *module spider* command.  The
first one will be mainly used by system administrators where as the
second command is typically for users.

The *spiderT.lua* file contains information about all the modulefiles
on your system that can be found from $MODULEPATH and is built by
*spider*.  The way this file is built is be evaluating each module and
remembering the help message, the whatis calls and the location of the
modulefile. It also remembers any properties set by the modulefile.
It doesn't remember the module commands inside the modulefile.

When evaluating the modulefiles, Lmod looks for changes in
$MODULEPATH.  Each new directory added to MODULEPATH is also searched
for modulefiles.  This is why this command is called "spider".

There are some important points about Lmod walking the module tree.
Each modulefile is evaluated separately.  This means that any changes
in MODULEPATH need to be static.  That is new path must be defined in
the modulefile.  If the change in MODULEPATH is dynamic or depends on
some environment variable that is dynamic, it is very likely that
Lmod's *module spider* won't know about these dynamic changes to
MODULEPATH.

The spiderT.lua file is used by Lmod to know any properties set in a
modulefile.  This information is used by *module avail*, *module
spider* and *module keyword*.  By default Lmod doesn't use the spider
cache (aka spiderT.lua) to load modulefiles, however a site can
configure Lmod to use cache based loads.  This just means that a site
*must* keep the spider cache up-to-date.

Lmod looks for special whatis calls to know what the description for a
module is.  See :ref:`module_spider_cmd-label` for details.


