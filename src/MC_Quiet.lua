--------------------------------------------------------------------------
-- When unloading all the positive actions of a module are reversed. So
-- a "setenv()" becomes an unset and so forth.  Note that reversing an
-- unload or an unsetenv command is a no-op.
--
-- @classmod MC_Quiet

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
MC_Quiet               = inheritsFrom(MainControl)
MC_Quiet.my_name       = "MC_Quiet"
MC_Quiet.my_sType      = "mt"
MC_Quiet.my_tcl_mode   = "remove"

local M                = MC_Quiet
M.always_load          = MainControl.quiet
M.always_unload        = MainControl.quiet
M.add_property         = MainControl.quiet
M.append_path          = MainControl.quiet
M.build_unload         = MainControl.quiet
M.color_banner         = MainControl.quiet
M.complete             = MainControl.quiet
M.conflict             = MainControl.quiet
M.depends_on           = MainControl.quiet
M.depends_on_any       = MainControl.quiet
M.error                = MainControl.quiet
M.execute              = MainControl.quiet
M.extensions           = MainControl.quiet
M.family               = MainControl.quiet
M.haveDynamicMPATH     = MainControl.quiet
M.help                 = MainControl.quiet
M.inherit              = MainControl.quiet
M.load                 = MainControl.quiet
M.load_any             = MainControl.quiet
M.load_usr             = MainControl.quiet
M.mgrload              = MainControl.quiet
M.myFileName           = MainControl.quiet
M.myModuleFullName     = MainControl.quiet
M.myModuleUsrName      = MainControl.quiet
M.myModuleName         = MainControl.quiet
M.myModuleVersion      = MainControl.quiet
M.popenv               = MainControl.quiet
M.prepend_path         = MainControl.quiet
M.prereq               = MainControl.quiet
M.prereq_any           = MainControl.quiet
M.purge                = MainControl.quiet
M.pushenv              = MainControl.quiet
M.remove_path          = MainControl.quiet
M.remove_property      = MainControl.quiet
M.report               = MainControl.quiet
M.setenv               = MainControl.quiet
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

return M
