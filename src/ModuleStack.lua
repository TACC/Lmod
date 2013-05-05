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
require("escape")
ModuleStack = { }

local Dbg          = require("Dbg")
local next         = next
local remove       = table.remove
local setmetatable = setmetatable

--module("ModuleStack")
local M = {}

s_moduleStack = {}

local function new(self)
   local o = {}

   setmetatable(o,self)
   self.__index = self
   o.stack      = { {name = "lmod_base", loadCnt = 0, setCnt = 0, fn = "unknown"} }
   return o
end

function M.moduleStack(self)
   if (next(s_moduleStack) == nil) then
      s_moduleStack = new(self)
   end
   return s_moduleStack
end

function M.loading(self, count)
   count       = count or 1
   local stack = self.stack
   local top   = stack[#stack]

   top.loadCnt = top.loadCnt + count
end

function M.setting(self)
   local stack = self.stack
   local top   = stack[#stack]

   top.setCnt = top.setCnt + 1
end

function M.push(self, full, sn, fn)
   local entry = {full = full, sn = sn, loadCnt = 0, setCnt = 0, fn= fn}
   local stack = self.stack

   stack[#stack+1] = entry
end

function M.pop(self)
   local stack = self.stack
   remove(stack)
end

function M.empty(self)
   return (#self.stack == 1)
end

function M.moduleType(self)
   local dbg   = Dbg:dbg()
   dbg.start("ModuleStack:moduleType()")

   local stack   = self.stack
   local top     = stack[#stack]
   local results = nil

   if (top.loadCnt > 0) then
      if (top.setCnt > 0) then
         results = "mw"
      else
         results = "m"
      end
   else
      results = "w"
   end
   dbg.print("name: ",top.name," type: ",results,"\n")
   dbg.fini()
   return results
end

function M.fullName(self)
   local stack = self.stack
   local top   = stack[#stack]
   return top.full
end

function M.sn(self)
   local stack = self.stack
   local top   = stack[#stack]
   return top.sn
end

function M.version(self)
   local stack   = self.stack
   local top     = stack[#stack]
   local full    = top.full
   local sn      = top.sn
   return extractVersion(full, sn) or ""
end

function M.fileName(self)
   local stack = self.stack
   local top   = stack[#stack]
   return top.fn
end

return M
