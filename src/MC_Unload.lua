-- -*- lua -*-
require("strict")

Unload            = inheritsFrom(MasterControl)
Unload.my_name    = "unload"

local M           = Unload
local Dbg         = require("Dbg")
local format      = string.format
local getenv      = os.getenv

function M.load(self,...)
   local dbg   = Dbg:dbg()

   dbg.start("Unload.load()")

   dbg.fini()
   return
end

function M.setenv(self,...)
   local dbg   = Dbg:dbg()

   dbg.start("Unload.setenv()")

   dbg.fini()
   return
end

return M
