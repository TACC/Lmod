--------------------------------------------------------------------------
-- Setup for Dependency Check mode. This mode just reloads every currently loaded
-- module and runs depends_on().  It reports any modules that are not loaded.
--
-- @classmod MC_DependencyCk

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


local MainControl      = require("MainControl")
local MC_DependencyCk  = inheritsFrom(MainControl)
local M                = MC_DependencyCk
local cosmic           = require("Cosmic"):singleton()
M.my_name              = "MC_DependencyCk"
M.my_sType             = "load"
M.my_tcl_mode          = "load"
M.always_load          = MainControl.quiet
M.always_unload        = MainControl.quiet
M.add_property         = MainControl.quiet
M.append_path          = MainControl.quiet
M.build_unload         = MainControl.do_not_build_unload
M.color_banner         = MainControl.quiet
M.complete             = MainControl.quiet
M.conflict             = MainControl.quiet
M.depends_on           = MainControl.dependencyCk
M.depends_on_any       = MainControl.dependencyCk_any
M.execute              = MainControl.quiet
M.extensions           = MainControl.quiet
M.family               = MainControl.quiet
M.forgo                = MainControl.quiet
M.forgo_any            = MainControl.quiet
M.haveDynamicMPATH     = MainControl.quiet
M.help                 = MainControl.quiet
M.inherit              = MainControl.quiet
M.load                 = MainControl.quiet
M.load_any             = MainControl.quiet
M.load_usr             = MainControl.quiet
M.message              = MainControl.quiet
M.msg_raw              = MainControl.quiet
M.mgrload              = MainControl.quiet
M.myFileName           = MainControl.myFileName
M.myModuleFullName     = MainControl.myModuleFullName
M.myModuleUsrName      = MainControl.myModuleUsrName
M.myModuleName         = MainControl.myModuleName
M.myModuleVersion      = MainControl.myModuleVersion
M.prepend_path         = MainControl.quiet
M.prereq               = MainControl.quiet
M.prereq_any           = MainControl.quiet
M.purge                = MainControl.quiet
M.pushenv              = MainControl.quiet
M.remove_path          = MainControl.quiet
M.remove_property      = MainControl.quiet
M.report               = MainControl.quiet
M.setenv               = MainControl.setenv_env
M.set_alias            = MainControl.quiet
M.set_shell_function   = MainControl.quiet
M.source_sh            = MainControl.quiet
M.try_load             = MainControl.quiet
M.uncomplete           = MainControl.quiet
M.unload               = MainControl.quiet
M.unload_usr           = MainControl.quiet
M.unsetenv             = MainControl.quiet
M.unset_alias          = MainControl.quiet
M.unset_shell_function = MainControl.quiet
M.usrload              = MainControl.quiet
M.whatis               = MainControl.quiet
M.LmodBreak            = MainControl.quiet

if (cosmic:value("MODULES_AUTO_HANDLING") == "yes") then
   M.prereq     = MainControl.dependencyCk
   M.prereq_any = MainControl.dependencyCk_any
end


return M
