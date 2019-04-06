--------------------------------------------------------------------------
-- This derived class of MasterControl just prints ever module
-- command.
--
-- @classmod MC_Show

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



require("utils")
local pack          = (_VERSION == "Lua 5.1") and argsPack or table.pack -- luacheck: compat
local MasterControl = require("MasterControl")
MC_Show             = inheritsFrom(MasterControl)
MC_Show.my_name     = "MC_Show"
MC_Show.my_sType    = "load"
MC_Show.my_tcl_mode = "display"
MC_Show.report      = MasterControl.warning

local A             = ShowResultsA
local M             = MC_Show
local dbg           = require("Dbg"):dbg()
local concatTbl     = table.concat
M.accessMode        = MasterControl.quiet
M.myFileName        = MasterControl.myFileName
M.myModuleFullName  = MasterControl.myModuleFullName
M.myModuleName      = MasterControl.myModuleName
M.myModuleVersion   = MasterControl.myModuleVersion
M.myModuleUsrName   = MasterControl.myModuleUsrName

local function ShowCmd(name,...)
   A[#A+1] = ShowCmdStr(name, ...)
end

local function Show_help(...)
   local argA = pack(...)
   local a    = {}
   local b    = {}
   a[#a+1]    = "help("
   for i = 1,argA.n do
      b[#b + 1] = "[[".. argA[i] .."]]"
   end
   a[#a+1]   = concatTbl(b,", ")
   a[#a+1]   = ")\n"

   A[#A+1]   = concatTbl(a,"")
end

--------------------------------------------------------------------------
-- Print help command.
-- @param self A MasterControl object
function M.help(self, ...)
   Show_help(...)
end

--------------------------------------------------------------------------
-- Print whatis command.
-- @param self A MasterControl object
-- @param value the whatis string.
function M.whatis(self, value)
   ShowCmd("whatis", value)
end

--------------------------------------------------------------------------
-- Print execute command.
-- @param self A MasterControl object.
-- @param t Input table describing shell command.
function M.execute(self, t)
   local a = {}
   a[#a+1] = "execute{cmd=\""
   a[#a+1] = t.cmd
   a[#a+1] = "\", modeA={\""
   a[#a+1] = concatTbl(t.modeA, "\", \"")
   a[#a+1] = "\"}}\n"
   A[#A+1] = concatTbl(a,"")
end

--------------------------------------------------------------------------
-- Print prepend_path command.
-- @param self A MasterControl object
-- @param t input table
function M.prepend_path(self, t)
   ShowCmd("prepend_path", t)
end

--------------------------------------------------------------------------
-- Print add_property command.
-- @param self A MasterControl object.
-- @param name the environment variable name.
-- @param value the environment variable value.
function M.add_property(self, name,value)
   ShowCmd("add_property", name, value)
end

--------------------------------------------------------------------------
-- Print set_alias command.
-- @param self A MasterControl object.
-- @param name the environment variable name.
-- @param value the environment variable value.
function M.remove_property(self, name,value)
   ShowCmd("remove_property", name, value)
end

--------------------------------------------------------------------------
-- Print message command.
-- @param self A MasterControl object.
function M.message(self, ...)
   ShowCmd("LmodMessage", ...)
end

--------------------------------------------------------------------------
-- Print message raw command.
-- @param self A MasterControl object.
function M.msg_raw(self, ...)
   ShowCmd("LmodMsgRaw", ...)
end

--------------------------------------------------------------------------
-- Print set_alias command.
-- @param self A MasterControl object.
-- @param name the environment variable name.
-- @param value the environment variable value.
function M.set_alias(self, name,value)
   ShowCmd("set_alias", name, value)
end

--------------------------------------------------------------------------
-- Print pushenv command.
-- @param self A MasterControl object.
-- @param name the environment variable name.
-- @param value the environment variable value.
function M.pushenv(self, name,value)
   ShowCmd("pushenv", name, value)
end

--------------------------------------------------------------------------
-- Print unset_alias command.
-- @param self A MasterControl object
-- @param name the environment variable name.
function M.unset_alias(self, name)
   ShowCmd("unset_alias",name)
end

--------------------------------------------------------------------------
-- Print append_path command.
-- @param self A MasterControl object
-- @param t input table
function M.append_path(self, t)
   ShowCmd("append_path", t)
end

--------------------------------------------------------------------------
-- Print setenv command.
-- @param self A MasterControl object.
-- @param name the environment variable name.
-- @param value the environment variable value.
function M.setenv(self, name,value)
   ShowCmd("setenv", name, value)
end

--------------------------------------------------------------------------
-- Print unsetenv command.
-- @param self A MasterControl object.
-- @param name the environment variable name.
-- @param value the environment variable value.
function M.unsetenv(self, name,value)
   ShowCmd("unsetenv", name, value)
end

--------------------------------------------------------------------------
-- Print remove_path command.
-- @param self A MasterControl object
-- @param t input table
function M.remove_path(self, t)
   ShowCmd("remove_path", t)
end

--------------------------------------------------------------------------
-- Print load command.
-- @param self A MasterControl object
-- @param mA An array of module names (MName objects)
function M.load(self, mA)
   A[#A+1] = ShowCmdA("load",mA)
end

--------------------------------------------------------------------------
-- Print mgrload command.
-- @param self A MasterControl object
-- @param mA An array of module names (MName objects)
function M.mgrload(self, required, active)
   A[#A+1] = ShowCmd("mgrload",required, active)
end

--------------------------------------------------------------------------
-- Print depends_on command.
-- @param self A MasterControl object
-- @param mA An array of module names (MName objects)
function M.depends_on(self, mA)
   A[#A+1] = ShowCmdA("depends_on",mA)
end

M.load_usr = M.load

--------------------------------------------------------------------------
-- Print try_load command.
-- @param self A MasterControl object
-- @param mA An array of module names (MName objects)
function M.try_load(self, mA)
   A[#A+1] = ShowCmdA("try_load",mA)
end

M.try_add = M.try_load

--------------------------------------------------------------------------
-- Print inherit command.
-- @param self A MasterControl object
function M.inherit(self, ...)
   ShowCmd("inherit",...)
end

--------------------------------------------------------------------------
-- Print family command.
-- @param self A MasterControl object
function M.family(self, ...)
   ShowCmd("family",...)
end

--------------------------------------------------------------------------
-- Print unload command.
-- @param self A MasterControl object
-- @param mA An array of module names (MName objects)
function M.unload(self, mA)
   A[#A+1] = ShowCmdA("unload",mA)
end

--------------------------------------------------------------------------
-- Print alway_load command.
-- @param self A MasterControl object
-- @param mA An array of module names (MName objects)
function M.always_load(self, mA)
   A[#A+1] = ShowCmdA("always_load",mA)
end

--------------------------------------------------------------------------
-- Print always_unload command.
-- @param self A MasterControl object
-- @param mA An array of module names (MName objects)
function M.always_unload(self, mA)
   A[#A+1] = ShowCmdA("always_unload",mA)
end

--------------------------------------------------------------------------
-- Print prereq command.
-- @param self A MasterControl object
-- @param mA An array of module names (MName objects)
function M.prereq(self, mA)
   A[#A+1] = ShowCmdA("prereq",mA)
end

--------------------------------------------------------------------------
-- Print prereq_any command.
-- @param self A MasterControl object
-- @param mA An array of module names (MName objects)
function M.prereq_any(self, mA)
   A[#A+1] = ShowCmdA("prereq_any",mA)
end

--------------------------------------------------------------------------
-- Print conflict command.
-- @param self A MasterControl object
-- @param mA An array of module names (MName objects)
function M.conflict(self, mA)
   A[#A+1] = ShowCmdA("conflict",mA)
end

--------------------------------------------------------------------------
-- Print set shell function
-- @param self A MasterControl object
function M.set_shell_function(self, ...)
   ShowCmd("set_shell_function", ...)
end

--------------------------------------------------------------------------
-- Print unset shell function
-- @param self A MasterControl object
function M.unset_shell_function(self, ...)
   ShowCmd("set_shell_function", ...)
end


return M
