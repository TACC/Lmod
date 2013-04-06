-- $Id: capture.lua 118 2009-02-16 05:03:36Z mclay $ --

capture = nil
require("strict")

local Dbg   = require("Dbg")
local posix = require("posix")
function capturePOPEN(cmd,level)
   local dbg    = Dbg:dbg()
   level        = level or 1
   local level2 = level or 2
   dbg.start(level, "capture")
   dbg.print("cwd: ",posix.getcwd(),"\n")
   dbg.print("cmd: ",cmd,"\n")
   local p = io.popen(cmd)
   if p == nil then
      return nil
   end
   local ret = p:read("*all")
   p:close()
   dbg.start(level2,"capture output")
   dbg.print(ret)
   dbg.fini()
   dbg.fini()
   return ret
end

function captureFILE(cmd, level)
   local dbg    = Dbg:dbg()
   level        = level or 1
   local level2 = level or 2
   dbg.start(level,"captureFILE")
   dbg.print("cmd: ",cmd,"\n")
   local tmpName = os.tmpname()
   local cmd     = cmd .. " > " .. tmpName
   local results = nil
   os.execute(cmd)
   local f = io.open(tmpName)
   if (f) then
      results = f:read("*all")
      f:close()
      os.remove(tmpName)
      dbg.start(level2,"capture output")
      dbg.print(results)
      dbg.fini()
   end
   dbg.fini()
   return results
end

capture = capturePOPEN
