-- -*- lua -*-
require("strict")

local Dbg              = require("Dbg")
MC_Spider              = inheritsFrom(MasterControl)
MC_Spider.my_name      = "MC_Spider"

local M                = MC_Spider

M.always_load          = MasterControl.quiet
M.always_unload        = MasterControl.quiet
M.conflict             = MasterControl.quiet
M.error                = MasterControl.quiet
M.family               = MasterControl.quiet
M.inherit              = MasterControl.quiet
M.load                 = MasterControl.quiet
M.message              = MasterControl.quiet
M.prereq               = MasterControl.quiet
M.prereq_any           = MasterControl.quiet
M.pushenv              = MasterControl.quiet
M.remove_path          = MasterControl.quiet
M.report               = MasterControl.warning
M.set_alias            = MasterControl.quiet
M.set_shell_function   = MasterControl.quiet
M.try_load             = MasterControl.quiet
M.unload               = MasterControl.quiet
M.unloadsys            = MasterControl.quiet
M.unsetenv             = MasterControl.quiet
M.unset_alias          = MasterControl.quiet
M.unset_shell_function = MasterControl.quiet
M.usrload              = MasterControl.quiet
M.warning              = MasterControl.warning

function M.myFileName(self)
   local masterTbl   = masterTbl()
   local moduleStack = masterTbl.moduleStack 
   local iStack      = #moduleStack
   return moduleStack[iStack].fn
end


function M.myModuleFullName(self)
   local masterTbl   = masterTbl()
   local moduleStack = masterTbl.moduleStack 
   local iStack      = #moduleStack
   return moduleStack[iStack].full
end

function M.myModuleName(self)
   local masterTbl   = masterTbl()
   local moduleStack = masterTbl.moduleStack 
   local iStack      = #moduleStack
   local full        = moduleStack[iStack].full
   local i,j         = full:find(".*/")
   if (j) then
      return full:sub(1,j-1)
   end
   return full
end

function M.myModuleVersion(self)
   local masterTbl   = masterTbl()
   local moduleStack = masterTbl.moduleStack 
   local iStack      = #moduleStack
   local full        = moduleStack[iStack].full
   local i,j         = full:find(".*/")
   if (j) then
      return full:sub(j+1,-1)
   end
   return ""
end

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

function M.add_property(self,...)
   local dbg    = Dbg:dbg()
   dbg.start("MC_Spider:add_property(...)")
   Spider_add_property(...)
   dbg.fini()
   return true
end

function M.remove_property(self,...)
   local dbg    = Dbg:dbg()
   dbg.start("MC_Spider:remove_property(...)")
   Spider_remove_property(...)
   dbg.fini()
   return true
end

return M
