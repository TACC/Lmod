--------------------------------------------------------------------------
-- This class holds the "cosmic" class.  It is responsible for initializing
-- global variables used in Lmod. It remembers the default values as well as
-- the current values.  This class exists to make it easier to know when a
-- site is using values than the Lmod "defaults"



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

require("pairsByKeys")

local M = {}
local getenv   = os.getenv
local s_cosmic = false

-- local functions
local l_new

function M.singleton(self)
   if (not s_cosmic) then
      s_cosmic = l_new(self)
   end
   return s_cosmic
end

local yes_noT = {
   ['0']   = "no",
   ['']    = "no",
   ['off'] = "no",
   ['1']   = "yes",
}

function M.init(self, t)
   local T    = self.__T
   local name = (t.name or "unknown")

   if (t.yn) then
      local defaultV = t.yn:lower()
      local sedV     = t.sedV or "@"
      local value    = (getenv(name) or sedV):lower()
      if (value:sub(1,1) == "@") then
         value = defaultV
      end
      value = yes_noT[value] or value
      if (value ~= "no") then
         value = "yes"
      end
      T[name] = {value = value, default = defaultV}
      return
   end

   if (t.assignV ~= nil) then
      local defaultV = t.default
      local value    = t.assignV
      T[name] = {value = value, default = defaultV}
      return
   end

   if (t.default ~= nil) then
      --io.stderr:write("dflt: ",tostring(t.default),"\n")
      
      local defaultV = t.default
      local sedV     = t.sedV or "@"
      local value    = t.no_env and sedV or (getenv(name) or sedV) 
      if (t.lower) then
         value = value:lower()
      end
      value          = yes_noT[value] or value
      if (value:sub(1,1) == "@" or value == "<empty>") then
         value = defaultV
      end
      T[name] = {value = value, default = defaultV}
      return
   end
end

function M.reportChangesFromDefault(self)
   local T    = self.__T
   local a    = {}

   a[1] = {"Name","Default","Value"}
   a[2] = {"----","-------","-----"}


   for k,v in pairsByKeys(T) do
      if (v.value ~= v.default) then
         a[#a+1] = {k, tostring(v.default), tostring(v.value)}
      end
   end

   return (#a < 3) and {} or a
end
      


function M.assign(self, name, value)
   local T       = self.__T
   T[name].value = value
end

function M.value(self,name)
   --io.stderr:write("value: name:", tostring(name),"\n")
   return self.__T[name].value
end

function M.default(self,name)
   return self.__T[name].default
end

function M.changed(self,name)
   local T = self.__T
   return (T[name].value == T[name].default) and "no" or "yes"
end

function l_new(self)
   local o = {}
   setmetatable(o,self)
   self.__index = self

   o.__T = {}
   return o
end


return M
