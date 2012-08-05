-- -*- lua -*-
require("strict")

MC_Unload         = inheritsFrom(MasterControl)
MC_Unload.my_name = "MC_Unload"

local M           = MC_Unload
local Dbg         = require("Dbg")
local format      = string.format
local getenv      = os.getenv

M.add_property    = MasterControl.remove_property
M.append_path     = MasterControl.remove_path
M.conflict        = MasterControl.quiet
M.family          = MasterControl.unset_family
M.help            = MasterControl.quiet
M.inherit         = MasterControl.inherit
M.load            = MasterControl.unload
M.mode            = MasterControl.mode_unload
M.prepend_path    = MasterControl.remove_path
M.prereq          = MasterControl.quiet
M.remove_path     = MasterControl.bad_remove_path
M.remove_property = MasterControl.bad_remove_property
M.required        = MasterControl.quiet
M.setenv          = MasterControl.unsetenv
M.try_load        = MasterControl.unload
M.unload          = MasterControl.bad_unload
M.unloadsys       = MasterControl.bad_unload
M.unsetenv        = MasterControl.bad_unsetenv
M.usrload         = MasterControl.unload
M.whatis          = MasterControl.quiet

return M
