--------------------------------------------------------------------------
-- This class is used to detect when a module file changes
-- in a way that will tell the user that their collection
-- of modules has to be reformed.  The problem is that if
-- a modulefile changes the directory that it prepends to
-- MODULEPATH or prereq or conflicts change, then the
-- current is considered no-longer valid.
--
-- The way this works is that this class sets most Lmod functions to be
-- quiet.  Mainly any loads, or changes to MODULEPATH generate output.
-- This output is collect into the array *ShowResultsA*.
-- Then the command computeHashSum takes that array output and computes
-- either mdsum or sha1sum of the text.   When a collection is stored,
-- this hash sum is computed.  When a collection is reloaded the hash sum
-- is recomputed for each modulefile.  If the sums are different then
-- the collection is no longer valid.
-- @classmod MC_ComputeHash

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

local MainControl          = require("MainControl")
MC_ComputeHash             = inheritsFrom(MainControl)
MC_ComputeHash.my_name     = "MC_ComputeHash"
MC_ComputeHash.my_sType    = "load"
MC_ComputeHash.my_tcl_mode = "load"
local M                    = MC_ComputeHash
local dbg                  = require("Dbg"):dbg()
local A                    = ShowResultsA

local function l_ShowCmd(name, ...)
   A[#A+1] = ShowCmdStr(name, ...)
end

M.add_property         = MainControl.quiet
M.build_unload         = MainControl.do_not_build_unload
M.color_banner         = MainControl.quiet
M.complete             = MainControl.quiet
M.conflict             = MainControl.quiet
M.error                = MainControl.quiet
M.execute              = MainControl.quiet
M.extensions           = MainControl.quiet
M.family               = MainControl.quiet
M.haveDynamicMPATH     = MainControl.quiet
M.help                 = MainControl.quiet
M.inherit              = MainControl.quiet
M.message              = MainControl.quiet
M.msg_raw              = MainControl.quiet
M.myFileName           = MainControl.myFileName
M.myModuleFullName     = MainControl.myModuleFullName
M.myModuleName         = MainControl.myModuleName
M.myModuleUsrName      = MainControl.myModuleUsrName
M.myModuleVersion      = MainControl.myModuleVersion
M.prereq               = MainControl.quiet
M.prereq_any           = MainControl.quiet
M.pushenv              = MainControl.setenv_env
M.remove_property      = MainControl.quiet
M.report               = MainControl.quiet
M.set_alias            = MainControl.quiet
M.set_shell_function   = MainControl.quiet
M.source_sh            = MainControl.quiet
M.setenv               = MainControl.setenv_env
M.uncomplete           = MainControl.quiet
M.unset_alias          = MainControl.quiet
M.unset_alias          = MainControl.quiet
M.unset_shell_function = MainControl.quiet
M.unsetenv             = MainControl.quiet
M.whatis               = MainControl.quiet
M.LmodBreak            = MainControl.quiet



--------------------------------------------------------------------------
-- Print always_load and arguments
-- @param self A MainControl object
-- @param mA An array of module names (MName objects)
function M.always_load(self, mA)
   A[#A+1] = ShowCmdA("always_load", mA)
end

--------------------------------------------------------------------------
-- Print always_unload and arguments
-- @param self A MainControl object
-- @param mA An array of module names (MName objects)
function M.always_unload(self, mA)
   A[#A+1] = ShowCmdA("always_unload", mA)
end

--------------------------------------------------------------------------
-- Print prepend_path command iff the env var. is MODULEPATH.
-- @param self A MainControl object
-- @param t input table
function M.prepend_path(self, t)
   local name = t[1]
   if (name ~= "MODULEPATH") then return end
   l_ShowCmd("prepend_path", name, t[2], t.delim)
end

--------------------------------------------------------------------------
-- Print append_path command iff the env var. is MODULEPATH.
-- @param self A MainControl object
-- @param t input table
function M.append_path(self, t)
   local name = t[1]
   if (name ~= "MODULEPATH") then return end
   l_ShowCmd("append_path", name, t[2], t.delim)
end

--------------------------------------------------------------------------
-- Print remove_path command iff the env var. is MODULEPATH.
-- @param self A MainControl object
-- @param t input table
function M.remove_path(self, t)
   local name = t[1]
   if (name ~= "MODULEPATH") then return end
   l_ShowCmd("remove_path", name, t[2], t.delim)
end

--------------------------------------------------------------------------
-- Print load command.
-- @param self A MainControl object
-- @param mA An array of module names (MName objects)
function M.load(self, mA)
   A[#A+1] = ShowCmdA("load", mA)
end

-- Print mgrload command.
-- @param self A MainControl object
-- @param mA An array of module names (MName objects)
function M.mgrload(self, required, active)
   A[#A+1] = l_ShowCmd("mgrload", required, active)
end
--------------------------------------------------------------------------
-- Print depends_on command.
-- @param self A MainControl object
-- @param mA An array of module names (MName objects)
function M.depends_on(self, mA)
   A[#A+1] = ShowCmdA("depends_on", mA)
end

--------------------------------------------------------------------------
-- Print load command.
-- @param self A MainControl object
-- @param mA An array of module names (MName objects)
function M.load_usr(self, mA)
   A[#A+1] = ShowCmdA("load", mA)
end

--------------------------------------------------------------------------
-- Print load_any command.
-- @param self A MainControl object
-- @param mA An array of module names (MName objects)
function M.load_any(self, mA)
   A[#A+1] = ShowCmdA("load_any", mA)
end

--------------------------------------------------------------------------
-- Print try_load command.
-- @param self A MainControl object
-- @param mA An array of module names (MName objects)
function M.try_load(self, mA)
   A[#A+1] = ShowCmdA("try_load", mA)
end

M.try_add = M.try_load

--------------------------------------------------------------------------
-- Print the inherit command.
-- @param self A MainControl object
function M.inherit(self, ...)
   l_ShowCmd("inherit",...)
end

--------------------------------------------------------------------------
-- Print the unload command.
-- @param self A MainControl object
-- @param mA An array of module names (MName objects)
function M.unload(self, mA)
   A[#A+1] = ShowCmdA("unload", mA)
end


return M
