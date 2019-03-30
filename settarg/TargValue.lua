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

require("strict")


local M = {}

-- The table t can have the following forms:
--   t = { value = "..." }
--   t = { sn = "...", version = "..." }


function M.new(self, t)
   local o = {}
   setmetatable(o,self)
   self.__index = self
   if (t.value ~= nil) then
      o.__kind  = "value"
      o.__value = t.value
   end
   if (t.sn) then
      o.__kind    = "module"
      o.__sn      = t.sn
      o.__version = t.version
   end
   return o
end

function M.value(self)
   if (self.__kind == "value") then
      return { kind = "value", value = self.__value}
   elseif (self.__kind == "module") then
      return { kind = "module", sn = self.__sn, version = self.__version}
   end
   return {}
end


function M.display(self, de_slash)
   if (self.__kind == "value") then
      return self.__value or ''
   elseif (self.__kind == "module") then
      local  v = self.__sn .. "/" .. self.__version
      if (de_slash) then
         return v:gsub("/","-")
      else
         return v
      end
   end
   return "should not happen!!!"
end



return M
