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


require("strict")

MC_ComputeHash         = inheritsFrom(MasterControl)
MC_ComputeHash.my_name = "MC_ComputeHash"
local M                = MC_ComputeHash
local Dbg              = require("Dbg")
local concatTbl        = table.concat
local A                = ComputeModuleResultsA

function ShowCmd(name, ...)
   local a = {}
   for _,v in ipairs{...} do
      local s = tostring(v)
      if (type(v) ~= "boolean") then
         s = "\"".. s .."\""
      end
      a[#a + 1] = s
   end
   local b = {}
   b[#b+1] = name
   b[#b+1] = "("
   b[#b+1] = concatTbl(a,",")
   b[#b+1] = ")\n"
   A[#A+1] = concatTbl(b,"")
end

M.add_property         = MasterControl.quiet
M.help                 = MasterControl.quiet
M.inherit              = MasterControl.quiet
M.myFileName           = MasterControl.myFileName
M.myModuleFullName     = MasterControl.myModuleFullName
M.myModuleUsrName      = MasterControl.myModuleUsrName
M.myModuleName         = MasterControl.myModuleName
M.myModuleVersion      = MasterControl.myModuleVersion
M.pushenv              = MasterControl.quiet
M.remove_property      = MasterControl.quiet
M.report               = MasterControl.quiet
M.set_alias            = MasterControl.quiet
M.set_shell_function   = MasterControl.quiet
M.setenv               = MasterControl.quiet
M.unset_alias          = MasterControl.quiet
M.unset_alias          = MasterControl.quiet
M.unset_shell_function = MasterControl.quiet
M.unsetenv             = MasterControl.quiet
M.whatis               = MasterControl.quiet


function M.always_load(self, ...)
   ShowCmd("always_load",...)
end

function M.always_unload(self, ...)
   ShowCmd("always_load",...)
end

function M.prepend_path(self, name, value, sep)
   if (name ~= "MODULEPATH") then return end
   ShowCmd("prepend_path", name, value, sep)
end

function M.append_path(self, name, value, sep)
   if (name ~= "MODULEPATH") then return end
   ShowCmd("append_path", name, value, sep)
end

function M.remove_path(self, name, value, sep)
   if (name ~= "MODULEPATH") then return end
   ShowCmd("remove_path", name, value, sep)
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

function M.prereq(self, ...)
   ShowCmd("prereq",...)
end

function M.conflict(self, ...)
   ShowCmd("conflict",...)
end

function M.prereq_any(self, ...)
   ShowCmd("prereq_any",...)
end

function M.error(self, ...)
   ShowCmd("LmodError", ...)
end

function M.message(self, ...)
   ShowCmd("LmodMessage", ...)
end

return M
