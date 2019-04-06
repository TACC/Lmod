--------------------------------------------------------------------------
-- Setup for refresh mode. Refresh just reloads every currently loaded
-- module so that shell functions and aliases will be defined in a
-- sub-shell.  So almost all Lmod functions do nothing except for the ones
-- that name the module and the set_alias and set_shell_function functions.
--
-- @classmod MC_Refresh

require("strict")

--------------------------------------------------------------------------
-- Lmod License
--------------------------------------------------------------------------
--
--  Lmod is licensed under the terms of the MIT license reproduced below.
--  This means that Lmod is free software and can be used for both academic
--  and commercial purposes at absolutely no cost.
--
--  ----------------------------------------------------------------------
--
--  Copyright (C) 2008-2018 Robert McLay
--
--  Permission is hereby granted, free of charge, to any person obtaining
--  a copy of this software and associated documentation files (the
--  "Software"), to deal in the Software without restriction, including
--  without limitation the rights to use, copy, modify, merge, publish,
--  distribute, sublicense, and/or sell copies of the Software, and to
--  permit persons to whom the Software is furnished to do so, subject
--  to the following conditions:
--
--  The above copyright notice and this permission notice shall be
--  included in all copies or substantial portions of the Software.
--
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
--  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
--  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
--  NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
--  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
--  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
--  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
--  THE SOFTWARE.
--
--------------------------------------------------------------------------


local MasterControl    = require("MasterControl")
local MC_Refresh       = inheritsFrom(MasterControl)
local M                = MC_Refresh
M.my_name              = "MC_Refresh"
M.my_sType             = "load"
M.my_tcl_mode          = "load"
M.always_load          = MasterControl.quiet
M.always_unload        = MasterControl.quiet
M.add_property         = MasterControl.quiet
M.append_path          = MasterControl.quiet
M.conflict             = MasterControl.quiet
M.depends_on           = MasterControl.quiet
M.execute              = MasterControl.execute
M.family               = MasterControl.quiet
M.help                 = MasterControl.quiet
M.inherit              = MasterControl.quiet
M.load                 = MasterControl.quiet
M.load_usr             = MasterControl.quiet
M.message              = MasterControl.quiet
M.msg_raw              = MasterControl.quiet
M.mgrload              = MasterControl.quiet
M.myFileName           = MasterControl.myFileName
M.myModuleFullName     = MasterControl.myModuleFullName
M.myModuleUsrName      = MasterControl.myModuleUsrName
M.myModuleName         = MasterControl.myModuleName
M.myModuleVersion      = MasterControl.myModuleVersion
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
M.unload_usr           = MasterControl.quiet
M.unsetenv             = MasterControl.quiet
M.unset_alias          = MasterControl.quiet
M.unset_shell_function = MasterControl.quiet
M.usrload              = MasterControl.quiet
M.whatis               = MasterControl.quiet

return M
