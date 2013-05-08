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

local M   = {}
local Dbg = require("Dbg")
local MT  = require("MT")

local function shorten(name, level)
   if (level == 0) then
      return name
   end

   local i,j = name:find(".*/")
   j = (j or 0) - 1
   return name:sub(1,j)
end

function M.new(self, sType, name)
   local o = {}
   setmetatable(o,self)
   self.__index = self
   local mt = MT:mt()

   name          = (name or ""):gsub("/+$","")  -- remove any trailing '/'
   local sn      = false
   local version = false

   if (sType == "load") then
      for level = 0, 1 do
         local n = shorten(name, level)
         if (mt:locationTbl(n)) then
            sn = n
            break
         end
      end
   elseif(sType == "userName") then
      if (mt:exists(name)) then
         sn      = name
         name    = name
      else
         local n = shorten(name, 1)
         if (mt:exists(n) )then
            sn = n
         end
      end
   else
      for level = 0, 1 do
         local n = shorten(name, level)
         if (mt:exists(n)) then
            sn      = n
            version = mt:Version(sn)
            break
         end
      end
   end

   if (sn) then
      o._sn      = sn
      o._name    = name
      o._version = version or extractVersion(name, sn)
   end

   return o
end

function M.sn(self)
   return self._sn
end

function M.usrName(self)
   return self._name
end

function M.version(self)
   return self._version
end

return M
