Providing Custom Labels for Avail
=================================

Lmod writes out the modules in alphabetical for each directory in
MODULEPATH in order::

     $ module avail 

     --------------- /opt/apps/modulefiles/Common ----------------
     abc/8.1   def/11.1   ghi/2.3

     --------------- /opt/apps/modulefiles/Core ------------------
     xyz/8.1   xyz/11.1 (D)   

     --------------- /opt/apps/modulefiles/Compilers -------------
     gcc/6.3  intel/17.0


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
           ['/Common$']    = "Core Modules",
        },
        fr_grouped = {
           ['/Compilers$'] = "Compilateurs",
           ['/Core$']      = "Modules de base",
           ['/Common$']    = "Modules de base",
        },
     }


     function avail_hook(t)
        local availStyle = masterTbl().availStyle
        dbg.print{"avail hook called: availStyle: ",availStyle,"\n"}
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

And then set the LMOD_AVAIL_STYLE variable to be::

   export LMOD_AVAIL_STYLE="system:<en_grouped>:fr_grouped"
  
The angle brackets define the default which in this case is
en_grouped.  A user can set::

   export LMOD_AVAIL_STYLE="fr_grouped"

to change to the french labels.
