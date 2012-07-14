-- -*- lua -*-
require("strict")

Spider            = inheritsFrom(MasterControl)
Spider.my_name    = "MC_Spider"

local M           = Spider

M.conflict     = MasterControl.quiet
M.error        = MasterControl.quiet
M.family       = MasterControl.quiet
M.inherit      = MasterControl.quiet
M.load         = MasterControl.quiet
M.message      = MasterControl.quiet
M.mode         = MasterControl.mode_load
M.prereq       = MasterControl.quiet
M.try_load     = MasterControl.quiet
M.unload       = MasterControl.quiet
M.unloadsys    = MasterControl.quiet
M.unsetenv     = MasterControl.quiet
M.usrload      = MasterControl.quiet

function M.help(self,...)
   local dbg    = Dbg:dbg()
   dbg.start("MC_Spider:help(...)")
   Spider_help(...)
   dbg.fini()
   return true
end   

function M.whatis(self,...)
   local dbg    = Dbg:dbg()
   dbg.start("MC_Spider:whatis(...)")
   Spider_whatis(...)
   dbg.fini()
   return true
end   

function M.setenv(self,...)
   local dbg    = Dbg:dbg()
   dbg.start("MC_Spider:setenv(...)")
   Spider_setenv(...)
   dbg.fini()
   return true
end

function M.prepend_path(self,...)
   local dbg    = Dbg:dbg()
   dbg.start("MC_Spider:prepend_path(...)")
   Spider_append_path("prepend",...)
   dbg.fini()
   return true

end

function M.append_path(self,...)
   local dbg    = Dbg:dbg()
   dbg.start("MC_Spider:append_path(...)")
   Spider_append_path("append",...)
   dbg.fini()
   return true
end

function M.is_spider(self)
   local dbg    = Dbg:dbg()
   dbg.start("MC_Spider:is_spider()")
   dbg.fini()
   return true
end


return M
