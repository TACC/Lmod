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

local MainControl      = require("MainControl")
local MC_CheckSyntax   = inheritsFrom(MainControl)
local M                = MC_CheckSyntax
local ReadLmodRC       = require("ReadLmodRC")
local dbg              = require("Dbg"):dbg()
local A                = ShowResultsA

M.my_name              = "MC_CheckSyntax"
M.my_sType             = "load"
M.my_tcl_mode          = "load"
M.always_load          = MainControl.load_usr
M.always_unload        = MainControl.quiet
M.append_path          = MainControl.append_path
M.build_unload         = MainControl.do_not_build_unload
M.color_banner         = MainControl.quiet
M.complete             = MainControl.quiet
M.conflict             = MainControl.quiet
M.depends_on           = MainControl.quiet
M.error                = MainControl.error
M.execute              = MainControl.quiet
M.extensions           = MainControl.quiet
M.family               = MainControl.quiet
M.haveDynamicMPATH     = MainControl.quiet
M.help                 = MainControl.quiet
M.inherit              = MainControl.quiet
M.load                 = MainControl.load
M.load_any             = MainControl.load_any
M.load_usr             = MainControl.load_usr
M.message              = MainControl.quiet
M.msg_raw              = MainControl.quiet
M.mgrload              = MainControl.mgrload
M.prepend_path         = MainControl.prepend_path
M.prereq               = MainControl.quiet
M.prereq_any           = MainControl.quiet
M.purge                = MainControl.quiet
M.pushenv              = MainControl.pushenv
M.remove_path          = MainControl.remove_path
M.remove_property      = MainControl.quiet
M.report               = MainControl.error
M.setenv               = MainControl.setenv
M.set_alias            = MainControl.set_alias
M.set_shell_function   = MainControl.set_shell_function
M.source_sh            = MainControl.quiet
M.try_load             = MainControl.quiet
M.uncomplete           = MainControl.quiet
M.unload               = MainControl.quiet
M.unload_usr           = MainControl.quiet
M.unsetenv             = MainControl.unsetenv
M.unset_alias          = MainControl.unset_alias
M.unset_shell_function = MainControl.unset_shell_function
M.whatis               = MainControl.quiet
M.LmodBreak            = MainControl.quiet


-- Internally these function do not actually to anything when either
-- is called inside a modulefile.  This way the original load happens
-- and it allows for the syntax check but does nothing otherwise.

M.load_usr             = MainControl.load_usr

--------------------------------------------------------------------------
-- Copy the property to moduleT
-- @param self A MainControl object.
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
