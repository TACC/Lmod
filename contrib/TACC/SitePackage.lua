require("strict")
require("serializeTbl")
require("myGlobals")
local hook   = require("Hook")
local getenv = os.getenv
local posix  = require("posix")

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

buildHostsT = {
   ["build.stampede.tacc.utexas.edu"]    = 1,
   ["c560-904.stampede.tacc.utexas.edu"] = 1,
   ["build.ls4.tacc.utexas.edu"]         = 1,
   ["build.longhorn"]                    = 1,
}
   
function buildCache_hook(t)

   local userName = getenv("USER")
   local host     = posix.uname("%n")

   if (buildHostsT[host]) then
      t.dontWriteCache = true
   end
end

hook.register("buildCache",buildCache_hook)
hook.register("load",load_hook)


