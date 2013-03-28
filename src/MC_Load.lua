-- -*- lua -*-
require("strict")

local MC_Load          = inheritsFrom(MasterControl)
local M                = MC_Load
local Dbg              = require("Dbg")
local format           = string.format
local getenv           = os.getenv
M.my_name              = "MC_Load"
M.always_load          = MasterControl.load
M.always_unload        = MasterControl.unload
M.add_property         = MasterControl.add_property
M.append_path          = MasterControl.append_path
M.conflict             = MasterControl.conflict
M.family               = MasterControl.family
M.help                 = MasterControl.quiet
M.inherit              = MasterControl.inherit
M.load                 = MasterControl.load
M.myFileName           = MasterControl.myFileName
M.prepend_path         = MasterControl.prepend_path
M.prereq               = MasterControl.prereq
M.prereq_any           = MasterControl.prereq_any
M.remove_path          = MasterControl.remove_path
M.remove_property      = MasterControl.remove_property
M.report               = MasterControl.error
M.setenv               = MasterControl.setenv
M.set_alias            = MasterControl.set_alias
M.set_shell_function   = MasterControl.set_shell_function
M.stack                = MasterControl.stack_push
M.try_load             = MasterControl.try_load
M.unload               = MasterControl.unload
M.unloadsys            = MasterControl.unloadsys
M.unsetenv             = MasterControl.unsetenv
M.unset_alias          = MasterControl.unset_alias
M.unset_shell_function = MasterControl.unset_shell_function
M.usrload              = MasterControl.usrload
M.whatis               = MasterControl.quiet

return M
