-- -*- lua -*-
require("strict")

Unload            = inheritsFrom(MasterControl)
Unload.my_name    = "MC_Unload"

local M           = Unload
local Dbg         = require("Dbg")
local format      = string.format
local getenv      = os.getenv

M.append_path  = MasterControl.remove_path
M.conflict     = MasterControl.quiet
M.family       = MasterControl.unset_family
M.help         = MasterControl.quiet
M.inherit      = MasterControl.inherit
M.load         = MasterControl.unload
M.mode         = MasterControl.mode_unload
M.prepend_path = MasterControl.remove_path
M.prereq       = MasterControl.quiet
M.remove_path  = MasterControl.bad_remove_path
M.setenv       = MasterControl.unsetenv
M.try_load     = MasterControl.unload
M.unload       = MasterControl.bad_unload
M.unloadsys    = MasterControl.bad_unload
M.unsetenv     = MasterControl.bad_unsetenv
M.usrload      = MasterControl.unload
M.whatis       = MasterControl.quiet

return M
