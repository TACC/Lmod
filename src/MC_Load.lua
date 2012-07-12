-- -*- lua -*-
require("strict")

Load              = inheritsFrom(MasterControl)
Load.my_name      = "MC_Load"

local M           = Load
local Dbg         = require("Dbg")
local format      = string.format
local getenv      = os.getenv

M.load         = MasterControl.load
M.try_load     = MasterControl.try_load
M.unload       = MasterControl.unload
M.unloadsys    = MasterControl.unloadsys
M.prepend_path = MasterControl.prepend_path
M.append_path  = MasterControl.append_path
M.remove_path  = MasterControl.remove_path
M.setenv       = MasterControl.setenv
M.unsetenv     = MasterControl.unsetenv
M.prereq       = MasterControl.prereq
M.conflict     = MasterControl.conflict
M.family       = MasterControl.family
M.inherit      = MasterControl.inherit
M.whatis       = MasterControl.quiet
M.help         = MasterControl.quiet

return M
