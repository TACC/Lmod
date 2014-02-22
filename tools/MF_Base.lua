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
--  Copyright (C) 2008-2014 Robert McLay
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
-- MF_Base:  This the base class for Module file output.

require("strict")
require("inherits")
require("string_split")
require("quote")

local M            = {}

local dbg          = require("Dbg"):dbg()
local concatTbl    = table.concat
local pairsByKeys  = pairsByKeys


--------------------------------------------------------------------------
-- Member functions:
--------------------------------------------------------------------------

--------------------------------------------------------------------------
-- MF_Base:name(): returns the derived class's name: (e.g. bash)

function M.name(self)
   return self.my_name
end


s_mfT = false

--------------------------------------------------------------------------
-- MF_Base:build():  This is the factory that builds the derived shell.

function M.build(kind)
   if (not s_mfT) then
      local MF_Lmod = require("MF_Lmod")
      local MF_TCL  = require("MF_TCL")
      s_mfT         = {}
      s_mfT["Lmod"] = MF_Lmod
      s_mfT["TCL"]  = MF_TCL
   end

   local mkind = s_mfT[kind] or s_mfT['Lmod']
   return mkind:create()
end

function M.process(self, ignoreT, oldEnvT, envT)
   dbg.start{"MF_Base:process(ignoreT, oldEnvT, envT)"}
   local a = {}

   dbg.print{"name: ",self:name(), "\n"}

   for k, v in pairsByKeys(envT) do
      dbg.print{"k: ", k, ", v: ", v, ", oldV: ",oldEnvT[k],"\n"}
      if (not ignoreT[k]) then
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
               for i = idx-1, 1, -1 do
                  a[#a+1] = self:prepend_path(k,newA[i])
               end
               for i = idx, #newA do
                  a[#a+1] = self:append_path(k,newA[i])
               end
            end
         end
      end
   end
                  
   dbg.fini("MF_Base:process")
   return a
end

return M
