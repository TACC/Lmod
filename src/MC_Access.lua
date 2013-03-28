-- -*- lua -*-
require("strict")

Dbg               = require("Dbg")
MC_Access         = inheritsFrom(MasterControl)
MC_Access.my_name = "MC_Access"
concatTbl         = table.concat

local M           = MC_Access

M.accessT = { help = false, whatis = false}

function M.activate(name, value)
   M.accessT[name] = value
end

function M.help(self, ...)   
   local dbg = Dbg:dbg()
   local arg = { n = select('#', ...), ...}
   if (M.accessT.help == true) then
      for i = 1, arg.n do
         io.stderr:write(tostring(arg[i]))
      end
      io.stderr:write("\n")
   end
   dbg.fini()
end

function M.whatis(self, msg)
   if (M.accessT.whatis) then
      local nm     = ModuleName or ""
      local l      = nm:len()
      local nblnks
      if (l < 20) then
         nblnks = 20 - l
      else
         nblnks = l + 2
      end
      local prefix = nm .. string.rep(" ",nblnks) .. ": "
      io.stderr:write(prefix, msg, "\n")
   end
end


M.report               = MasterControl.warning
M.always_load          = MasterControl.quiet
M.always_unload        = MasterControl.quiet
M.add_property         = MasterControl.quiet
M.append_path          = MasterControl.quiet
M.conflict             = MasterControl.quiet
M.error                = MasterControl.quiet
M.family               = MasterControl.quiet
M.inherit              = MasterControl.quiet
M.load                 = MasterControl.quiet
M.message              = MasterControl.quiet
M.myFileName           = MasterControl.myFileName
M.prepend_path         = MasterControl.quiet
M.prereq               = MasterControl.quiet
M.prereq_any           = MasterControl.quiet
M.remove_path          = MasterControl.quiet
M.remove_property      = MasterControl.quiet
M.setenv               = MasterControl.quiet
M.set_alias            = MasterControl.quiet
M.set_shell_function   = MasterControl.quiet
M.stack                = MasterControl.quiet
M.try_load             = MasterControl.quiet
M.unload               = MasterControl.quiet
M.unloadsys            = MasterControl.quiet
M.unsetenv             = MasterControl.quiet
M.unset_shell_function = MasterControl.quiet
M.usrload              = MasterControl.quiet

return M
