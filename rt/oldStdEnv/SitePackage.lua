require("strict")
local MName = require("MName")
local hook  = require("Hook")

function load_hook(t)
   local mname = t.mname
   local sn    = mname:sn()

   -- Ignore all other modules besides "StdEnv"

   if (sn ~= "StdEnv") then return end

   local userName = mname:userName()

   local WantedStdEnv = os.getenv("WANTED_STDENV") or "StdEnv/2020"
   if (userName == t.modFullName or WantedStdEnv == t.modFullName ) then return end

   ------------------------------------------------------------
   -- mname:defaultKind()  returns:
   --    none   -> no marked default was set.
   --    system -> Set by system MODULERCFILE
   --    user   -> Set by user ~/.modulerc* file.
   --    marked -> Set by either "default" or .version or .modulerc or .modulerc.lua
   --              in module directory.
   local kind_default = mname:defaultKind()  
   

   if (kind_default == "system") then
      color_banner("red")
      LmodMessage("\nThe default for StdEnv is changing on some day in the future ...\n")
      color_banner("red")
   end
end


hook.register("load",load_hook)

