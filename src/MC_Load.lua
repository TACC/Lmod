-- -*- lua -*-
require("strict")

local MC_Load  = inheritsFrom(MasterControl)
local M        = MC_Load
local Dbg      = require("Dbg")
local format   = string.format
local getenv   = os.getenv
M.my_name      = "MC_Load"
M.append_path  = MasterControl.append_path
M.conflict     = MasterControl.conflict
M.family       = MasterControl.family
M.help         = MasterControl.quiet
M.inherit      = MasterControl.inherit
M.load         = MasterControl.load
M.mode         = MasterControl.mode_load
M.prepend_path = MasterControl.prepend_path
M.prereq       = MasterControl.prereq
M.remove_path  = MasterControl.remove_path
M.setenv       = MasterControl.setenv
M.try_load     = MasterControl.try_load
M.unload       = MasterControl.unload
M.unloadsys    = MasterControl.unloadsys
M.unsetenv     = MasterControl.unsetenv
M.usrload      = MasterControl.usrload
M.whatis       = MasterControl.quiet

return M
