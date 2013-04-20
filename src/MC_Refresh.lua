-- -*- lua -*-
require("strict")

local MC_Refresh       = inheritsFrom(MasterControl)
local M                = MC_Refresh
M.my_name              = "MC_Refresh"
M.always_load          = MasterControl.quiet
M.always_unload        = MasterControl.quiet
M.add_property         = MasterControl.quiet
M.append_path          = MasterControl.quiet
M.conflict             = MasterControl.quiet
M.family               = MasterControl.quiet
M.help                 = MasterControl.quiet
M.inherit              = MasterControl.quiet
M.load                 = MasterControl.quiet
M.myFileName           = MasterControl.myFileName
M.myModuleName         = MasterControl.myModuleName
M.prepend_path         = MasterControl.quiet
M.prereq               = MasterControl.quiet
M.prereq_any           = MasterControl.quiet
M.pushenv              = MasterControl.quiet
M.remove_path          = MasterControl.quiet
M.remove_property      = MasterControl.quiet
M.report               = MasterControl.quiet
M.setenv               = MasterControl.quiet
M.set_alias            = MasterControl.set_alias
M.set_shell_function   = MasterControl.set_shell_function
M.try_load             = MasterControl.quiet
M.unload               = MasterControl.quiet
M.unloadsys            = MasterControl.quiet
M.unsetenv             = MasterControl.quiet
M.unset_alias          = MasterControl.quiet
M.unset_shell_function = MasterControl.quiet
M.usrload              = MasterControl.quiet
M.whatis               = MasterControl.quiet

return M
