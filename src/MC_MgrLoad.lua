--------------------------------------------------------------------------
-- This is used to load all modulefiles when doing module collection
-- restore.
-- @classmod MC_MgrLoad

require("strict")
--------------------------------------------------------------------------
-- Lmod License
--------------------------------------------------------------------------
--
--  Lmod is licensed under the terms of the MIT license reproduced below.
--  This means that Lua is free software and can be used for both academic
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


local MainControl      = require("MainControl")
local MC_MgrLoad       = inheritsFrom(MainControl)
local M                = MC_MgrLoad
local dbg              = require("Dbg"):dbg()
M.my_name              = "MC_MgrLoad"
M.my_sType             = "load"
M.my_tcl_mode          = "load"
M.always_load          = MainControl.fake_load
M.always_unload        = MainControl.fake_load
M.add_property         = MainControl.add_property
M.build_unload         = MainControl.do_not_build_unload
M.append_path          = MainControl.append_path
M.color_banner         = MainControl.color_banner
M.complete             = MainControl.complete
M.conflict             = MainControl.conflict
M.depends_on           = MainControl.fake_load
M.execute              = MainControl.execute
M.extensions           = MainControl.quiet
M.family               = MainControl.family
M.help                 = MainControl.quiet
M.haveDynamicMPATH     = MainControl.quiet
M.inherit              = MainControl.inherit
M.load                 = MainControl.fake_load
M.load_any             = MainControl.fake_load
M.load_usr             = MainControl.fake_load
M.message              = MainControl.message
M.msg_raw              = MainControl.msg_raw
M.mgrload              = MainControl.fake_load
M.myFileName           = MainControl.myFileName
M.myModuleFullName     = MainControl.myModuleFullName
M.myModuleUsrName      = MainControl.myModuleUsrName
M.myModuleName         = MainControl.myModuleName
M.myModuleVersion      = MainControl.myModuleVersion
M.prepend_path         = MainControl.prepend_path
M.prereq               = MainControl.prereq
M.prereq_any           = MainControl.prereq_any
M.purge                = MainControl.quiet
M.pushenv              = MainControl.pushenv
M.remove_path          = MainControl.remove_path
M.remove_property      = MainControl.remove_property
M.report               = MainControl.error
M.setenv               = MainControl.setenv
M.set_alias            = MainControl.set_alias
M.set_shell_function   = MainControl.set_shell_function
M.source_sh            = MainControl.source_sh
M.try_load             = MainControl.fake_load
M.uncomplete           = MainControl.uncomplete
M.unload               = MainControl.fake_load
M.unload_usr           = MainControl.fake_load
M.unsetenv             = MainControl.unsetenv
M.unset_alias          = MainControl.unset_alias
M.unset_shell_function = MainControl.unset_shell_function
M.usrload              = MainControl.fake_load
M.whatis               = MainControl.quiet
M.LmodBreak            = MainControl.LmodBreak

return M
