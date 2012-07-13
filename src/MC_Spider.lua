-- -*- lua -*-
require("strict")

Spider            = inheritsFrom(MasterControl)
Spider.my_name    = "MC_Spider"

local M           = Spider

M.append_path  = MasterControl.quiet
M.conflict     = MasterControl.quiet
M.error        = MasterControl.quiet
M.family       = MasterControl.quiet
M.help         = MasterControl.quiet
M.inherit      = MasterControl.quiet
M.load         = MasterControl.quiet
M.message      = MasterControl.quiet
M.mode         = MasterControl.mode_load
M.prepend_path = MasterControl.quiet
M.prereq       = MasterControl.quiet
M.remove_path  = MasterControl.quiet
M.setenv       = MasterControl.quiet
M.try_load     = MasterControl.quiet
M.unload       = MasterControl.quiet
M.unloadsys    = MasterControl.quiet
M.unsetenv     = MasterControl.quiet
M.usrload      = MasterControl.quiet
M.whatis       = MasterControl.quiet

function M.is_spider(self)
   local dbg    = Dbg:dbg()
   dbg.start("MC_Spider:is_spider()")
   dbg.fini()
   return true
end


return M
