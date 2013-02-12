require("strict")
require("serializeTbl")
local hook   = require("Hook")
local getenv = os.getenv

function load_hook(t)

   if (getenv("ENVIRONMENT") ~= "BATCH") then
      return
   end

   local moduleInfoT = { modFullName=t.modFullName, fn=t.fn}
   local s           = serializeTbl{name="moduleInfoT", value=moduleInfoT}
   local uuid        = UUIDString(os.time())
   local dirN        = pathJoin(getenv("HOME"), ".lmod.d", ".saveBatch")
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


