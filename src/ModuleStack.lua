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

--------------------------------------------------------------------------
--  ModuleStack class:  This is a singleton class that is use to keep
--  track of the modules that are currently loaded.  It has two jobs:
--
--     a) Remember the name and filename for each module that is being
--        loaded.
--     b) Keep track of whether a module is a manager or worker bee.
--        A manager module is also a meta-module.  This means it loads
--        other modules.  A worker-bee module does not.
--
--  This is important to know because a module that does both loads and
--  changes the environment can not be stored in a user defined
--  collective.  This is how myModuleFullName() and myFileName() gets
--  their value.  Note that is stack is used for normal operations but
--  is not used when in spider mode.


require("escape")
require("strict")
ModuleStack = { }

local Dbg          = require("Dbg")
local remove       = table.remove

--module("ModuleStack")
local M = {}

s_moduleStack = {}

--------------------------------------------------------------------------
-- new(): A singleton constructor for this class.

local function new(self)
   local o = {}

   setmetatable(o,self)
   self.__index = self
   o.stack      = { {full = "lmod_base/0.0", sn = "lmod_base", loadCnt = 0, setCnt = 0, fn = "unknown"} }
   return o
end

--------------------------------------------------------------------------
-- ModuleStack:moduleStack(): The wrapper around the singleton ctor.

function M.moduleStack(self)
   if (next(s_moduleStack) == nil) then
      s_moduleStack = new(self)
   end
   return s_moduleStack
end

--------------------------------------------------------------------------
-- ModuleStack:loading(): bump the load counter.

function M.loading(self, count)
   count       = count or 1
   local stack = self.stack
   local top   = stack[#stack]

   top.loadCnt = top.loadCnt + count
end

--------------------------------------------------------------------------
-- ModuleStack:setting(): bump the env. var. set counter.

function M.setting(self)
   local stack = self.stack
   local top   = stack[#stack]

   top.setCnt = top.setCnt + 1
end

function M.push(self, full, usrName, sn, fn)
   local entry = {full = full, usrName = usrName, sn = sn, loadCnt = 0, setCnt = 0, fn= fn}
   local stack = self.stack

   stack[#stack+1] = entry
end

--------------------------------------------------------------------------
-- ModuleStack:pop(): pop the module off the stack when loading is
--                    complete.

function M.pop(self)
   local stack = self.stack
   remove(stack)
end

--------------------------------------------------------------------------
-- ModuleStack:empty(): report true when the stack is empty.

function M.empty(self)
   return (#self.stack == 1)
end

--------------------------------------------------------------------------
-- ModuleStack:moduleType(): report what type the current module is:
--                           meta/regular or (manager/worker bee) or both.

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
   dbg.print("full: ",top.full," type: ",results,"\n")
   dbg.fini()
   return results
end

--------------------------------------------------------------------------
-- ModuleStack:fullName(): return the full module name for modulefile at
--                         the top of the stack.

function M.fullName(self)
   local stack = self.stack
   local top   = stack[#stack]
   return top.full
end

--------------------------------------------------------------------------
-- ModuleStack:sn(): return the short module name for modulefile at
--                   the top of the stack.
function M.sn(self)
   local stack = self.stack
   local top   = stack[#stack]
   return top.sn
end

--------------------------------------------------------------------------
-- ModuleStack:usrName(): return the module version for modulefile at
--                   the top of the stack.
function M.usrName(self)
   local stack = self.stack
   local top   = stack[#stack]
   return top.usrName
end

function M.version(self)
   local stack   = self.stack
   local top     = stack[#stack]
   local full    = top.full
   local sn      = top.sn
   return extractVersion(full, sn) or ""
end

--------------------------------------------------------------------------
-- ModuleStack:fileName(): return the file name for modulefile at
--                         the top of the stack.

function M.fileName(self)
   local stack = self.stack
   local top   = stack[#stack]
   return top.fn
end

return M
