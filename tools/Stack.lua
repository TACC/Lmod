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
--  Copyright (C) 2008-2025 Robert McLay
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

local M           = {}
local dbg         = require("Dbg"):dbg()

function M.new(self)
   dbg.start{"Stack:new()"}
   local o = {}
   setmetatable(o,self)
   self.__index = self
   o.__stack = {}
   o.__count = 0
   dbg.fini("Stack:new")
   return o
end

function M.push(self, entry)
   dbg.start{"Stack:push(entry)"}
   local stack  = self.__stack
   local count  = self.__count + 1
   stack[count] = entry
   self.__count = count
   dbg.fini("Stack:push")
end

function M.pop(self)
   dbg.start{"Stack:pop()"}
   local stack  = self.__stack
   local count  = self.__count
   assert(count > 0,"Trying to pop an empty stack")

   local entry  = stack[count]
   stack[count] = nil
   self.__count = count - 1
   dbg.fini("Stack:pop")
   return entry
end
   
return M

