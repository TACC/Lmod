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
--  Copyright (C) 2008-2013 Robert McLay
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

--------------------------------------------------------------------------
-- MC_Show: This derived class of MasterControl just prints ever module
--          command.


require("strict")
require("utils")

MC_Show            = inheritsFrom(MasterControl)
MC_Show.my_name    = "MC_Show"
MC_Show.report     = MasterControl.warning

local M            = MC_Show
local Dbg          = require("Dbg")
local concatTbl    = table.concat
M.accessMode       = MasterControl.quiet
M.myFileName       = MasterControl.myFileName
M.myModuleFullName = MasterControl.myModuleFullName
M.myModuleName     = MasterControl.myModuleName
M.myModuleVersion  = MasterControl.myModuleVersion
M.myModuleUsrName  = MasterControl.myModuleUsrName

local function ShowCmd(name,...)
   io.stderr:write(ShowCmdStr(name, ...))
end

local function Show_help(...)
   local a = {}
   for _,v in ipairs{...} do
      a[#a + 1] = "[[".. v .."]]"
   end
   io.stderr:write("help(",concatTbl(a,", "),")\n")
end

function M.help(self, ...)
   Show_help(...)
end

function M.whatis(self, value)
   ShowCmd("whatis", value)
end

function M.execute(self, ...)
   ShowCmd("execute", ...)
end

function M.prepend_path(self, ...)
   ShowCmd("prepend_path", ...)
end

function M.add_property(self, name,value)
   ShowCmd("add_property", name, value)
end

function M.remove_property(self, name,value)
   ShowCmd("remove_property", name, value)
end

function M.message(self, ...)
   ShowCmd("LmodMessage", ...)
end

function M.set_alias(self, name,value)
   ShowCmd("set_alias", name, value)
end

function M.pushenv(self, name,value)
   ShowCmd("pushenv", name, value)
end

function M.unset_alias(self, name)
   ShowCmd("unset_alias",name)
end

function M.append_path(self, ...)
   ShowCmd("append_path", ...)
end

function M.setenv(self, name,value)
   ShowCmd("setenv", name, value)
end

function M.unsetenv(self, name,value)
   ShowCmd("unsetenv", name, value)
end

function M.remove_path(self, name,value)
   ShowCmd("remove_path", name, value)
end

function M.load(self, ...)
   ShowCmd("load",...)
end

function M.try_load(self, ...)
   ShowCmd("try_load",...)
end

M.try_add = M.try_load

function M.inherit(self, ...)
   ShowCmd("inherit",...)
end

function M.family(self, ...)
   ShowCmd("family",...)
end

function M.unload(self, ...)
   ShowCmd("unload", ...)
end

function M.always_load(self, ...)
   ShowCmd("always_load", ...)
end

function M.always_unload(self, ...)
   ShowCmd("always_unload", ...)
end

function M.unload(self, ...)
   ShowCmd("unload", ...)
end

function M.prereq(self, ...)
   ShowCmd("prereq",...)
end

function M.prereq_any(self, ...)
   ShowCmd("prereq_any",...)
end

function M.conflict(self, ...)
   ShowCmd("conflict",...)
end


function M.set_shell_function(self, ...)
   ShowCmd("set_shell_function", ...)
end

function M.unset_shell_function(self, ...)
   ShowCmd("set_shell_function", ...)
end


return M
