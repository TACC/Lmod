--------------------------------------------------------------------------
-- Loading a module causes all the commands to act in the positive.
-- @classmod MC_Load

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
local MC_CheckSyntax   = inheritsFrom(MasterControl)
local M                = MC_CheckSyntax
local ReadLmodRC       = require("ReadLmodRC")
local dbg              = require("Dbg"):dbg()
local A                = ShowResultsA

M.my_name              = "MC_CheckSyntax"
M.my_sType             = "load"
M.my_tcl_mode          = "load"
M.always_load          = MasterControl.load_usr
M.always_unload        = MasterControl.quiet
M.append_path          = MasterControl.append_path
M.build_unload         = MasterControl.do_not_build_unload
M.color_banner         = MasterControl.quiet
M.complete             = MasterControl.quiet
M.conflict             = MasterControl.quiet
M.depends_on           = MasterControl.quiet
M.execute              = MasterControl.quiet
M.extensions           = MasterControl.quiet
M.family               = MasterControl.quiet
M.help                 = MasterControl.quiet
M.inherit              = MasterControl.quiet
M.load                 = MasterControl.load
M.load_any             = MasterControl.load_any
M.load_usr             = MasterControl.load_usr
M.message              = MasterControl.quiet
M.msg_raw              = MasterControl.quiet
M.mgrload              = MasterControl.mgrload
M.prepend_path         = MasterControl.prepend_path
M.prereq               = MasterControl.quiet
M.prereq_any           = MasterControl.quiet
M.pushenv              = MasterControl.pushenv
M.remove_path          = MasterControl.remove_path
M.remove_property      = MasterControl.quiet
M.report               = MasterControl.error
M.setenv               = MasterControl.setenv
M.set_alias            = MasterControl.set_alias
M.set_shell_function   = MasterControl.set_shell_function
M.source_sh            = MasterControl.quiet
M.try_load             = MasterControl.quiet
M.uncomplete           = MasterControl.quiet
M.unload               = MasterControl.quiet
M.unload_usr           = MasterControl.quiet
M.unsetenv             = MasterControl.unsetenv
M.unset_alias          = MasterControl.unset_alias
M.unset_shell_function = MasterControl.unset_shell_function
M.whatis               = MasterControl.quiet
M.LmodBreak            = MasterControl.quiet


-- Internally these function do not actually to anything when either
-- is called inside a modulefile.  This way the original load happens
-- and it allows for the syntax check but does nothing otherwise.

M.load_usr             = MasterControl.load_usr

--------------------------------------------------------------------------
-- Copy the property to moduleT
-- @param self A MasterControl object.
-- @param name the property name.
-- @param value the value.
function M.add_property(self, name, value)
   dbg.start{"MC_CheckSyntax:add_property(\"",name,"\", \"",value,"\")"}
   local t           = {}
   local readLmodRC  = ReadLmodRC:singleton()
   readLmodRC:validPropValue(name, value,t)
   dbg.fini("MC_CheckSyntax:add_property")
   return true
end

--------------------------------------------------------------------------
-- For the purposes of checking syntax.  "We" are always a member of
-- the group

function M.userInGroups(self, ...)
   return true
end


return M
