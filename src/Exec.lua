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
-- Exec:  This class holds a array of strings. These are commands that
--        the module file  can execute after all the environment variables
--        have been reported.

require("strict")
require("utils")
local dbg           = require("Dbg"):dbg()
local concatTbl     = table.concat
local getenv        = os.getenv

local M = {}

s_exec = false

local function new(self)
   local o = {}
   o.a     = {}

   setmetatable(o,self)
   self.__index = self
   return o
end

function M.exec(self)
   if (not s_exec) then
      dbg.start("Exec:exec()")
      s_exec = new(self)
      dbg.fini("Exec:exec")
   end
   return s_exec
end

function M.register(self, ...)
   local arg = { n = select('#',...), ...}
   local a   = self.a

   for i = 1, arg.n do
      if (arg[i]) then
         a[#a+1] = arg[i]
      end
   end
end

function M.expand(self)
   local a = self.a

   for i = 1,#a do
      local v = a[i]:gsub(";%s*$","")
      io.stdout:write(v,";\n")
   end
end


return M
