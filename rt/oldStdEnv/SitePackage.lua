require("strict")
require("serializeTbl")
local MName = require("MName")
local hook  = require("Hook")

function load_hook(t)
   --io.stderr:write("module name: ",t.modName," full module name: ", t.modFullName, " fn: ", t.fn, "\n")
   local mname = t.mname
   local sn    = mname:sn()

   -- Ignore all other modules besides "StdEnv"

   if (sn ~= "StdEnv") then return end

   local userName = mname:userName()

   local WantedStdEnv = os.getenv("WANTED_STDENV") or "StdEnv/2020"
   if (userName == t.modFullName or WantedStdEnv == t.modFullName ) then return end

   local kind_default = mname:defaultKind()
   if (kind_default == "user") then
      LmodMessage("Using StdEnv default in ~/.modulerc* files to make old StdEnv: Consider updating")
   end
end


hook.register("load",load_hook)

