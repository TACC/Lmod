require("strict")
require("serializeTbl")
local hook = require("Hook")

function load_hook(t)
   --io.stderr:write("module name: ",t.modName," full module name: ", t.modFullName, " fn: ", t.fn, "\n")

   local moduleInfoT = { modFullName=t.modFullName, fn=t.fn}
   local s           = serializeTbl{indent = true, name="moduleInfoT", value=moduleInfoT}
   local uuid        = UUIDString(os.time())
   local dirN        = pathJoin(os.getenv("HOME"), ".lmod.d", ".save")
   local fn          = pathJoin(dirN, uuid .. ".lua")

   if (not isDir(dirN)) then
      mkdir_recursive(dirN)
   end

   local f = io.open(fn,"w")
   if (f) then
      f:write(s)
      f:close()
   end
end


hook.register("load",load_hook)


