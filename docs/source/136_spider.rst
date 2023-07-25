.. _spider_tool-label:

The spider tool
===============

Lmod provides a tool called *spider* to build the spider cache and
other files that can help a site manage their modulefiles.  The shell
script *update\_lmod\_system\_cache\_files* described in
:ref:`system-spider-cache-label` uses the spider command to build the
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


Dynamic Spider Cache Support
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Lmod 8.7.4+ supports for spidering user modulefiles that
compiler/MPI/cuda modules could support.  Suppose your site uses the
software hierarchy and your site wants to allow users to be able to
use **module spider** to find their modules as well.  To do this
something like this to your compiler/MPI/cuda modules.  Suppose in
your sites gcc/10.3.0 module you have::

    prepend_path("MODULEPATH", "...") -- System compiler dependent modules
    local home_root = pathJoin(os.getenv("HOME"),"myModules")
    local userDir   = pathJoin(home_root,"Compiler/gcc10")
    if (isDir(userDir)) then
      prepend_path("MODULEPATH",userDir)
    end

Where users know to define their personal hierarchical for gcc/10.*
packages in say *$HOME/myModules/Compiler/gcc10/*.

If your site uses a spider cache (and you rebuild this cache with Lmod
8.8+ then Lmod will reread modulefiles that modify $MODULEPATH. This
rereading can be turned with configure time options.

When building the spider cache, Lmod will not find modulefiles that
conditionally add to $MODULEPATH.  Suppose your standard module (say
StdEnv.lua) wants to allow users to have "Core" modules then you might
have::

    local home_root = pathJoin(os.getenv("HOME"),"myModules")
    local userDir = pathJoin(hroot,"Core")
    if (isDir(userDir)) then
       prepend_path("MODULEPATH",userDir)
    end
    haveDynamicMPATH()

The point is that since at the time of building the system spider
cache, the user's home directory won't be known.  In this case, your
StdEnv.lua file will need the **haveDynamicMPATH()** function.  Thus
telling Lmod that the "StdEnv.lua" module will be reread when
performing a "module spider" command and allow any user's Core modules
to be found when spidering.

Software page generation
~~~~~~~~~~~~~~~~~~~~~~~~

Since the package modulefiles are the gold standard of the packages
your sites offers, it should be that information which should be used
to generate the list of software packages.  Lmod provides two kind of
output depending on your sites needs.  Suppose you have the simple
module tree::

    foo
    ├── .2.0.lua
    ├── 1.0.lua
    ├── 1.1.lua
    └── default -> 1.0.lua

Then Lmod can produce the following information in json format::

    $ MODULEPATH=.
    $ spider -o jsonSoftwarePage $MODULEPATH | python  -mjson.tool
    [   
        {
            "defaultVersionName": "1.0",
            "description": "foo description",
            "package": "foo",
            "versions": [
                {
                    "canonicalVersionString": "000000001.*zfinal",
                    "full": "foo/.2.0",
                    "help": "foo v.2.0",
                    "hidden": true,
                    "markedDefault": false,
                    "path": "foo/.2.0.lua",
                    "versionName": "1.0",
                    "wV": "000000000.000000002.*zfinal"
                },
                {
                    "canonicalVersionString": "000000001.000000001.*zfinal",
                    "full": "foo/1.1",
                    "help": "foo v1.1",
                    "markedDefault": false,
                    "path": "foo/1.1.lua",
                    "versionName": "1.1",
                    "wV": "000000001.000000001.*zfinal"
                },
                {
                    "canonicalVersionString": "000000001.*zfinal",
                    "full": "foo/1.0",
                    "help": "foo v1.0",
                    "markedDefault": true,
                    "path": "foo/1.0.lua",
                    "versionName": "1.0",
                    "wV": "^00000001.*zfinal"
                }
            ]
        }
    ]

The versions array block is sorted by the "wV" fields. This a weighted
version of the canonicalVersionString, where the only difference is
that the first character in the string is modified to know that it is
marked default.  Also if a module is hidden then the "hidden" field
will be set to true.

The last entry in the versions array is used to set the description.

Another json output may be of interest.  There is more information but
it will be up to the site build the summarization that
jsonSoftwarePage provides::

    $ MODULEPATH=.
    $ spider -o spider-json $MODULEPATH | python  -mjson.tool
    {
        "foo": {
            "foo/.2.0.lua": {
                "Description": "foo description",
                "Version": "1.0",
                "fullName": "foo/.2.0",
                "help": "foo v.2.0",
                "hidden": true,
                "pV": "000000000.000000002.*zfinal",
                "wV": "000000000.000000002.*zfinal",
                "whatis": [
                    "Description: foo description",
                    "Version: .2.0",
                    "Categories: foo"
                ]
            },
            "foo/1.0.lua": {
                "Description": "foo description",
                "Version": "1.0",
                "fullName": "foo/1.0",
                "help": "foo v1.0",
                "hidden": false,
                "pV": "000000001.*zfinal",
                "wV": "^00000001.*zfinal",
                "whatis": [
                    "Description: foo description",
                    "Version: 1.0",
                    "Categories: foo"
                ]
            },
            "foo/1.1.lua": {
                "Description": "foo description",
                "Version": "1.1",
                "fullName": "foo/1.1",
                "help": "foo v1.1",
                "hidden": false,
                "pV": "000000001.000000001.*zfinal",
                "wV": "000000001.000000001.*zfinal",
                "whatis": [
                    "Description: foo description",
                    "Version: 1.1",
                    "Categories: foo"
                ]
            }
        }
    }   
