--------------------------------------------------------------------------
-- When unloading all the positive actions of a module are reversed. So
-- a "setenv()" becomes an unset and so forth.  Note that reversing an
-- unload or an unsetenv command is a no-op.
--
-- @classmod MC_Unload

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
MC_Unload              = inheritsFrom(MainControl)
MC_Unload.my_name      = "MC_Unload"
MC_Unload.my_sType     = "mt"
MC_Unload.my_tcl_mode  = "remove"

local M                = MC_Unload
local dbg              = require("Dbg"):dbg()
M.always_load          = MainControl.quiet
M.always_unload        = MainControl.unload
M.add_property         = MainControl.remove_property
M.append_path          = MainControl.remove_path_last
M.build_unload         = MainControl.do_not_build_unload
M.color_banner         = MainControl.color_banner
M.complete             = MainControl.uncomplete
M.conflict             = MainControl.quiet
M.depends_on           = MainControl.forgo
M.error                = MainControl.warning
M.execute              = MainControl.execute
M.extensions           = MainControl.quiet
M.family               = MainControl.unset_family
M.haveDynamicMPATH     = MainControl.quiet
M.help                 = MainControl.quiet
M.inherit              = MainControl.inherit
M.load                 = MainControl.unload
M.load_any             = MainControl.unload
M.load_usr             = MainControl.unload
M.mgrload              = MainControl.mgr_unload
M.myFileName           = MainControl.myFileName
M.myModuleFullName     = MainControl.myModuleFullName
M.myModuleUsrName      = MainControl.myModuleUsrName
M.myModuleName         = MainControl.myModuleName
M.myModuleVersion      = MainControl.myModuleVersion
M.prepend_path         = MainControl.remove_path_first
M.prereq               = MainControl.quiet
M.prereq_any           = MainControl.quiet
M.pushenv              = MainControl.popenv
M.remove_path          = MainControl.remove_path
M.remove_property      = MainControl.quiet
M.report               = MainControl.warning
M.setenv               = MainControl.unsetenv
M.set_alias            = MainControl.unset_alias
M.set_shell_function   = MainControl.unset_shell_function
M.source_sh            = MainControl.un_source_sh
M.try_load             = MainControl.unload
M.uncomplete           = MainControl.uncomplete
M.unload               = MainControl.unload
M.unload_usr           = MainControl.unload_usr
M.unsetenv             = MainControl.quiet
M.unset_alias          = MainControl.quiet
M.unset_shell_function = MainControl.quiet
M.usrload              = MainControl.unload
M.whatis               = MainControl.quiet
M.LmodBreak            = MainControl.quiet

return M
