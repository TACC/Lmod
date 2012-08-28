-- -*- lua -*-
require("strict")

MC_Unload         = inheritsFrom(MasterControl)
MC_Unload.my_name = "MC_Unload"

local M           = MC_Unload
local Dbg         = require("Dbg")
local format      = string.format
local getenv      = os.getenv

M.always_load     = MasterControl.quiet
M.always_unload   = MasterControl.unload
M.add_property    = MasterControl.remove_property
M.append_path     = MasterControl.remove_path
M.conflict        = MasterControl.quiet
M.family          = MasterControl.unset_family
M.help            = MasterControl.quiet
M.inherit         = MasterControl.inherit
M.load            = MasterControl.unload
M.prepend_path    = MasterControl.remove_path
M.prereq          = MasterControl.quiet
M.prereq_any      = MasterControl.quiet
M.remove_path     = MasterControl.bad_remove_path
M.remove_property = MasterControl.bad_remove_property
M.setenv          = MasterControl.unsetenv
M.set_alias       = MasterControl.unset_alias
M.try_load        = MasterControl.unload
M.unload          = MasterControl.bad_unload
M.unloadsys       = MasterControl.bad_unload
M.unsetenv        = MasterControl.bad_unsetenv
M.unset_alias     = MasterControl.bad_unset_alias
M.usrload         = MasterControl.unload
M.whatis          = MasterControl.quiet

return M
