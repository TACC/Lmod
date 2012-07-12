-- -*- lua -*-
require("strict")

Show              = inheritsFrom(MasterControl)
Show.my_name      = "show"

local M           = Show
local Dbg         = require("Dbg")
local format      = string.format
local getenv      = os.getenv

function M.load(self,...)
   local dbg   = Dbg:dbg()

   dbg.start("Show.load()")

   dbg.fini()
   return
end

function M.setenv(self,...)
   local dbg   = Dbg:dbg()

   dbg.start("Show.setenv()")

   dbg.fini()
   return
end

return M
