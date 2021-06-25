.. _avail_style:

Providing Custom Labels for Avail
=================================

Lmod writes out the modules in alphabetical order for each directory in
MODULEPATH in order::

     $ module avail

     --------------- /opt/apps/modulefiles/A-B ----------------
     abc/8.1   def/11.1   ghi/2.3

     --------------- /opt/apps/modulefiles/Core ------------------
     xyz/8.1   xyz/11.1 (D)

     --------------- /opt/apps/modulefiles/Compilers -------------
     gcc/6.3  intel/17.0

This is very useful and informative from the system perspective, but users
might prefer to have more descriptive labels and have the contents of
multiple directories displayed under the same label.

Sites can replace the directory paths with any label they like.
This is implemented by adding a SitePackage.lua file and calling the
avail hook.   See :ref:`hooks` for how to create SitePackage.lua.

Suppose you wish to merge the Common and Core sections above into
a single group named "Core Modules" and change the directory to
"Compiler Modules".  The result would be::

     $ module avail

     --------------- Core Modules -------------------------
     abc/8.1   def/11.1   ghi/2.3   xyz/8.1   xyz/11.1 (D)

     --------------- Compiler Modules ---------------------
     gcc/6.3  intel/17.0


To make this happen you need to do the following.  Create a
SitePackage.lua file containing::

     require("strict")
     local hook = require("Hook")

     local mapT =
     {
        en_grouped = {
           ['/Compilers$'] = "Compilers",
           ['/Core$']      = "Core Modules",
           ['/A%-B$']      = "Core Modules",
        },
        fr_grouped = {
           ['/Compilers$'] = "Compilateurs",
           ['/Core$']      = "Modules de base",
           ['/A%-B$']      = "Modules de base",
        },
     }


     function avail_hook(t)
        local availStyle = masterTbl().availStyle
        local styleT     = mapT[availStyle]
        if (not availStyle or availStyle == "system" or styleT == nil) then
           return
        end

        for k,v in pairs(t) do
           for pat,label in pairs(styleT) do
              if (k:find(pat)) then
                 t[k] = label
                 break
              end
           end
        end
     end


     hook.register("avail",avail_hook)

Sites must specially quote the minus sign ("**-**") with a **%**
because it is a regex character.

The default style for displaying module names is the `system` style.  

To use the new, grouped labeling, set the `LMOD_AVAIL_STYLE` variable to be::

   export LMOD_AVAIL_STYLE="system:<en_grouped>:fr_grouped"

The angle brackets define the default which in this case is
en_grouped.  A user can set::

   export LMOD_AVAIL_STYLE="fr_grouped"

to change to the french labels.

If a site does nothing then the `system` layout will be the result.  Sites
control the behavior by the `LMOD_AVAIL_STYLE` environment variable.  Sites
can set it as follows::

    export LMOD_AVAIL_STYLE=system:grouped

The first word is assumed to be the default.  The word `system` is special
in that Lmod will report the output in the original way.  By changing the
order sites can make the `grouped` output the default.::

   export LMOD_AVAIL_STYLE=grouped:system

To get the original output then users would have to do `module -s system
avail`.  The command `module avail` would use the `grouped` avail style.

Alternately, a user may also `export LMOD_AVAIL_STYLE=system` to get the
original output on all subsequent `module avail` invocations.
