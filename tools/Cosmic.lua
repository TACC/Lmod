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
   local envV = t.envV or getenv(name)
   local kind = t.kind or "D"
   local sedV = t.sedV or "@"
   if (sedV:sub(1,1) ~= "@") then
      kind = "C"
   end
   if (envV) then
      kind = "E"
   end


   if (t.yn) then
      local defaultV = t.yn:lower()
      local value    = (envV or sedV):lower()
      if (value:sub(1,1) == "@") then
         value = defaultV
      end
      value = yes_noT[value] or value
      if (value ~= "no") then
         value = "yes"
      end
      T[name] = {value = value, kind = kind, default = defaultV}
      return
   end

   if (t.assignV ~= nil) then
      local defaultV = t.default
      local value    = t.assignV
      T[name] = {value = value, kind = kind, default = defaultV}
      return
   end

   if (t.default ~= nil) then
      --io.stderr:write("dflt: ",tostring(t.default),"\n")

      local defaultV = t.default
      local sedV     = t.sedV or "@"
      local value    = t.no_env and sedV or (envV or sedV)
      if (t.lower) then
         value = value:lower()
      end
      value          = yes_noT[value] or value
      if (value:sub(1,1) == "@" or value == "<empty>") then
         value = defaultV
      end
      T[name] = {value = value, kind = kind, default = defaultV}
      return
   end
end

local function l_build_string(v)
   local value = v
   if (type(v) == "table") then
      value = serializeTbl{value=v}
      value = value:gsub("\n","")
   end
   return value
end


function M.reportChangesFromDefault(self)
   require("serializeTbl")
   local T    = self.__T
   local a    = {}

   a[1] = {"Name","Where Set","Default","Value"}
   a[2] = {"----","---------","-------","-----"}


   for k,v in pairsByKeys(T) do
      local value   = l_build_string(v.value)
      local default = l_build_string(v.default)

      if (value ~= default) then
         if (value == "" ) then value = "<empty>" end
         a[#a+1] = {k, v.kind, tostring(default), tostring(value)}
      end
   end

   return (#a < 3) and {} or a
end



function M.assign(self, name, value)
   local T       = self.__T
   if (not T[name]) then
      T[name] = {}
   end

   T[name].value = value
   T[name].kind  = self:get_key()
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

function M.get_key(self)
   return self.__kind
end

function M.set_key(self, kind)
   self.__kind = kind
end

function l_new(self)
   local o = {}
   setmetatable(o,self)
   self.__index = self

   o.__T    = {}
   o.__kind = "D"
   return o
end


return M
