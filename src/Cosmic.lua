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
--  Copyright (C) 2008-2016 Robert McLay
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


--------------------------------------------------------------------------
-- cosmic:init{name="LMOD_AUTO_SWAP", sedV="@auto_swap@", yn="yes"}
-- cosmic:init{name="LMOD_PAGER",     sedV="@pager@",     default="less"}
-- cosmic:init{name="LMOD_MAXDEPTH",  sedV="@maxdepth@",  default=false}

-- MRC_DEFAULT  = pathJoin(cmdDir(),"../../etc/rc")
-- MODULERCFILE = getenv("LMOD_MODULERCFILE") or getenv("MODULERCFILE") or MRC_DEFAULT
-- cosmic:init{name="LMOD_MODULERCFILE",        default=MRC_DEFAULT, kind="file", assignV=MODULERCFILE}

-- Usage:  cosmic:value("LMOD_SITE_NAME")
-- Usage:  cosmic:default("LMOD_SITE_NAME")
-- Usage:  cosmic:diff_between_v_and_d("LMOD_SITE_NAME")  ? better name needed.

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
      if (value ~= "no") then
         value = "yes"
      end
      T[name] = {value = value, default = defaultV}
      return
   end

   if (t.assignV) then
      local value = t.assignV
      local extra = nil
      if (t.kind == "file" and not isFile(value)) then
         extra = "<empty>"
      end
      T[name] = {value = value, default = defaultV, extra = extra}
      return
   end

   if (t.default) then
      local defaultV = t.default
      local sedV     = t.sedV or "@"
      local value    = (getenv(name) or sedV):lower()
      local extra    = nil
      if (value:sub(1,1) == "@") then
         value = defaultV
      end
      if (not value ) then
         extra = "<empty>"
      end

      T[name] = {value = value, default = defaultV, extra = extra}
      return
   end
end

function M.value(self,name)
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
