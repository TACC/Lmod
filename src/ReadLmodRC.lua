--------------------------------------------------------------------------
-- This class controls the ModuleTable.  The ModuleTable is how Lmod
-- communicates what modules are loaded or inactive and so on between
-- module commands.
--
-- @classmod ReadLmodRC

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


local M       = {}
local dbg     = require("Dbg"):dbg()
local getenv  = os.getenv
local open    = io.open
local RCFileA = {
   pathJoin(cmdDir(),"../init/lmodrc.lua"),
   pathJoin(cmdDir(),"../../etc/lmodrc.lua"),
   pathJoin("/etc/lmodrc.lua"),
   pathJoin(getenv("HOME"),".lmodrc.lua"),
}

local s_classObj    = false

local function buildRC(self)
   dbg.start{"buildRC(self)"}

   declare("propT",       false)
   declare("scDescriptT", false)
   local s_propT       = {}
   local s_scDescriptT = {}
   local s_rcFileA     = {}
   
   local lmodrc_env = getenv("LMOD_RC") or ""
   if (lmodrc_env:len() > 0) then
      for rc in lmodrc_env:split(":") do
         RCFileA[#RCFileA+1] = rc
      end
   end

   for i = 1,#RCFileA do
      repeat
         local f  = RCFileA[i]
         local fh = open(f)
         if (not fh) then break end
            
         assert(loadfile(f))()
         s_rcFileA[#s_rcFileA+1] = f
         fh:close()

         local propT       = _G.propT or {}
         local scDescriptT = _G.scDescriptT   or {}
         for k,v in pairs(propT) do
            s_propT[k] = v
         end
         for j = 1,#scDescriptT do
            s_scDescriptT[#s_scDescriptT + 1] = scDescriptT[j]
         end
      until true
   end

   self.__propT       = s_propT
   self.__scDescriptT = s_scDescriptT
   self.__rcFileA     = s_rcFileA

   dbg.fini("buildRC")
end



local function new(self)
   local o = {}
   setmetatable(o,self)
   self.__index = self

   buildRC(o)

   return o
end

function M.singleton(self)
   if (not s_classObj) then
      s_classObj = new(self)
   end
   return s_classObj
end

function M.propT(self)
   return self.__propT
end

function M.scDescriptT(self)
   return self.__scDescriptT
end

function M.rcFileA(self)
   return self.__rcFileA
end

return M

