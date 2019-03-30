--------------------------------------------------------------------------
-- This the base class for Module file output.
-- @classmod MF_Base

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

require("inherits")
require("string_utils")

local M            = {}

local dbg          = require("Dbg"):dbg()
local concatTbl    = table.concat
local pairsByKeys  = pairsByKeys


--------------------------------------------------------------------------
-- returns the derived class's name: (e.g. bash)
-- @param self MF_Base object
function M.name(self)
   return self.my_name
end

s_mfT = false

--------------------------------------------------------------------------
-- This is the factory that builds the derived shell.
-- @param kind the kind of derived MF_Base class to build.
function M.build(kind)
   if (not s_mfT) then
      local MF_Lua  = require("MF_Lua")
      local MF_TCL  = require("MF_TCL")
      s_mfT         = {}
      s_mfT["lmod"] = MF_Lua
      s_mfT["lua"]  = MF_Lua
      s_mfT["tcl"]  = MF_TCL
   end
   kind = (kind or ""):lower()
   local mkind = s_mfT[kind] or s_mfT['lua']
   return mkind:create()
end

--------------------------------------------------------------------------
-- Compare the old env table with the new and generate differences.
-- @param self MF_Base object
-- @param ignoreT table of env. vars to ignore.
-- @param oldEnvT The original user environment.
-- @param envT The new user environment.
function M.process(self, ignoreT, oldEnvT, envT)
   dbg.start{"MF_Base:process(ignoreT, oldEnvT, envT)"}
   local a = {}

   ------------------------------------------------------------
   -- Add header to modulefile if necessary. 
   -- Include the "#%Module" magic string For TCL modulefiles

   local s = self:header()
   if (s) then
      a[#a+1] = s
   end

   dbg.print{"name: ",self:name(), "\n"}

   local mt_pat = "^_ModuleTable"
   for k, v in pairsByKeys(envT) do
      local i = k:find(mt_pat)
      if (not ignoreT[k] and not i and not k:find("^BASH_FUNC_") and not v:find("^%(%)")) then
         dbg.print{"k: ", k, ", v: ", v, ", oldV: ",oldEnvT[k],"\n"}
         local oldV = oldEnvT[k]
         if (not oldV) then
            a[#a+1] = self:setenv(k,v)
         else
            local oldA = path2pathA(oldV)
            local newA = path2pathA(v)
            local idx  = indexPath(oldV, oldA, v, newA)
            if (idx < 0) then
               a[#a+1] = self:setenv(k,v)
            else
               newA = splice(newA, idx, #oldA + idx - 1)
               for j = idx-1, 1, -1 do
                  a[#a+1] = self:prepend_path(k,newA[j])
               end
               for j = idx, #newA do
                  a[#a+1] = self:append_path(k,newA[j])
               end
            end
         end
      end
   end

   dbg.fini("MF_Base:process")
   return a
end

function M.header(self)
   return nil
end

return M
