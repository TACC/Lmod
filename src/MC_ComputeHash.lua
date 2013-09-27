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
-- MC_ComputeHash:  This class is used to detect when a module file changes
--                  in a way that will tell the user that their collection
--                  of modules has to be reformed.  The problem is that if
--                  a modulefile changes the directory that it prepends to
--                  MODULEPATH or prereq or conflicts change, then the
--                  current is considered no-longer valid.
--
-- The way this works is that this class sets most Lmod functions to be
-- quiet.  Mainly any loads, or changes to MODULEPATH generate output.
-- This output is collect into the array [[ComputeModuleResultsA]].
-- Then the command computeHashSum takes that array output and computes
-- either mdsum or sha1sum of the text.   When a collection is stored,
-- this hash sum is computed.  When a collection is reloaded the hash sum
-- is recomputed for each modulefile.  If the sums are different then
-- the collection is no longer valid.

require("strict")
require("utils")

MC_ComputeHash         = inheritsFrom(MasterControl)
MC_ComputeHash.my_name = "MC_ComputeHash"
local M                = MC_ComputeHash
local dbg              = require("Dbg"):dbg()
local concatTbl        = table.concat
local A                = ComputeModuleResultsA

function ShowCmd(name, ...)
   A[#A+1] = ShowCmdStr(name, ...)
end

M.add_property         = MasterControl.quiet
M.execute              = MasterControl.quiet
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


function M.always_load(self, mA)
   A[#A+1] = ShowCmdA("always_load", mA)
end

function M.always_unload(self, mA)
   A[#A+1] = ShowCmdA("always_load", mA)
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

function M.load(self, mA)
   A[#A+1] = ShowCmdA("load", mA)
end

function M.try_load(self, mA)
   A[#A+1] = ShowCmdA("try_load", mA)
end

M.try_add = M.try_load

function M.inherit(self, ...)
   ShowCmd("inherit",...)
end

function M.family(self, ...)
   ShowCmd("family",...)
end

function M.unload(self, mA)
   A[#A+1] = ShowCmdA("unload", mA)
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
