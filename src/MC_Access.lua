--------------------------------------------------------------------------
-- Access is the MCP mode that handles help message or whatis messages.
-- almost all other module commands are ignored.
-- @classmod MC_Access

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
--  Copyright (C) 2008-2025 Robert McLay
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
-- Access is the MCP mode that handles help message or whatis messages.
-- almost all other module commands are ignored.

require("utils")
require("myGlobals")

local MainControl     = require("MainControl")
MC_Access             = inheritsFrom(MainControl)
MC_Access.my_name     = "MC_Access"
MC_Access.my_sType    = "load"
MC_Access.my_tcl_mode = "display"

local concatTbl       = table.concat
local A               = ShowResultsA
local M               = MC_Access

M.accessT = { help = false, whatis = false}

--------------------------------------------------------------------------
-- Set access mode to either help or whatis
-- @param mode The type of access: help, or whatis.
-- @param value Either true or false
function M.setAccessMode(self, mode, value)
   self.accessT[mode] = value
end

--------------------------------------------------------------------------
-- print Help message when assessT is in help mode
-- @param self MC_Access object
function M.help(self, ...)
   local argA = pack(...)
   if (self.accessT.help == true) then
      for i = 1, argA.n do
         A[#A+1] = argA[i]
      end
      A[#A+1] = "\n"
   end
end

--------------------------------------------------------------------------
-- print whatis message when assessT is whatis mode.
-- @param self A MC_Access object.
-- @param msg The message string.
function M.whatis(self, msg)
   if (self.accessT.whatis) then
      local nm     = FullName or ""
      local l      = nm:len()
      local nblnks
      if (l < 20) then
         nblnks = 20 - l
      else
         nblnks = l + 2
      end
      local prefix = nm .. string.rep(" ",nblnks) .. ": "
      A[#A+1] = prefix
      A[#A+1] = msg
      A[#A+1] = "\n"
   end
end


M.always_load          = MainControl.quiet
M.always_unload        = MainControl.quiet
M.add_property         = MainControl.quiet
M.append_path          = MainControl.quiet
M.build_unload         = MainControl.do_not_build_unload
M.color_banner         = MainControl.quiet
M.complete             = MainControl.quiet
M.uncomplete           = MainControl.quiet
M.conflict             = MainControl.quiet
M.depends_on           = MainControl.quiet
M.depends_on_any       = MainControl.quiet
M.error                = MainControl.quiet  --> Users are allowed to access(whatis/help) on forbidden modules
M.execute              = MainControl.execute
M.extensions           = MainControl.quiet
M.family               = MainControl.quiet
M.haveDynamicMPATH     = MainControl.quiet
M.inherit              = MainControl.inherit
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
M.pushenv              = MainControl.setenv_env
M.remove_path          = MainControl.quiet
M.remove_property      = MainControl.quiet
M.report               = MainControl.warning
M.setenv               = MainControl.setenv_env
M.set_alias            = MainControl.quiet
M.set_shell_function   = MainControl.quiet
M.source_sh            = MainControl.quiet
M.try_load             = MainControl.quiet
M.uncomplete           = MainControl.quiet
M.unload               = MainControl.quiet
M.unload_usr           = MainControl.quiet
M.unsetenv             = MainControl.quiet
M.unset_shell_function = MainControl.quiet
M.usrload              = MainControl.quiet
M.LmodBreak            = MainControl.quiet

return M
