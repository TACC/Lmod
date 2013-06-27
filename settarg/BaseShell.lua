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

-- BaseShell
require("strict")
require("inherits")

local M            = {}

local base64       = require("base64")
local concat       = table.concat
local decode64     = base64.decode64
local format       = string.format
local getenv       = os.getenv
local huge         = math.huge

------------------------------------------------------------------------
--module ('BaseShell')
------------------------------------------------------------------------

function M.name(self)
   return self.my_name
end

function M.getMT(self,name)
   local a    = {}
   local mtSz = getenv("_ModuleTable_Sz_") or huge
   local s    = nil

   for i = 1, mtSz do
      local name = format("_ModuleTable%03d_",i)
      local v    = getenv(name)
      if (v == nil) then break end
      a[#a+1]    = v
   end
   if (#a > 0) then
      s = decode64(concat(a,""))
   end
   return s
end


local function valid_shell(shellTbl, shell_name)
   if (not shellTbl[shell_name]) then
      return shellTbl.bare
   end
   return shellTbl[shell_name]
end

function M.build(shell_name)

   local shellTbl   = {}
   local Csh        = require('Csh')
   local Bash       = require('Bash')
   local Bare       = require('Bare')
   shellTbl["sh"]   = Bash
   shellTbl["bash"] = Bash
   shellTbl["zsh"]  = Bash
   shellTbl["csh"]  = Csh
   shellTbl["tcsh"] = Csh
   shellTbl.bare    = Bare


   local o     = valid_shell(shellTbl, shell_name):create()
   return o
end

return M
