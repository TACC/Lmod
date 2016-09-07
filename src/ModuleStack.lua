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
-- @classmod ModuleStack

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


local dbg          = require("Dbg"):dbg()
local remove       = table.remove

local M = {}

s_moduleStack = {}

--------------------------------------------------------------------------
-- A singleton constructor for this class.
-- @param self A ModuleStack object.
local function new(self)
   local o = {}

   setmetatable(o,self)
   self.__index = self
   o.stack      = { {full = "lmod_base/0.0", sn = "lmod_base", fn = "unknown"} }
   return o
end

--------------------------------------------------------------------------
-- The wrapper around the singleton ctor.
-- @param self A ModuleStack object.
function M.moduleStack(self)
   if (next(s_moduleStack) == nil) then
      s_moduleStack = new(self)
   end
   return s_moduleStack
end

--------------------------------------------------------------------------
-- Push current module information on stack.
-- @param self A ModuleStack object.
-- @param full The full name of the module.
-- @param usrName The user name of the module.
-- @param sn The short name of the module.
-- @param fn The filename of the module.
function M.push(self, full, usrName, sn, fn)
   local entry = {full = full, usrName = usrName, sn = sn, fn= fn}
   local stack = self.stack

   stack[#stack+1] = entry
end

--------------------------------------------------------------------------
-- Pop the module off the stack when loading is complete.
-- @param self A ModuleStack object.
function M.pop(self)
   local stack = self.stack
   remove(stack)
end

--------------------------------------------------------------------------
-- Report true when the stack is empty.
-- @param self A ModuleStack object.
function M.empty(self)
   return (#self.stack == 1)
end

--------------------------------------------------------------------------
-- Report true when the stack has only a single module.
-- @param self A ModuleStack object.
function M.atTop(self)
   return (#self.stack == 2)
end

--------------------------------------------------------------------------
-- Report the number of modules in the stack
-- @param self A ModuleStack object.
function M.count(self)
   return (#self.stack - 1)
end

--------------------------------------------------------------------------
-- Return the full module name for modulefile at the top of the stack.
-- @param self A ModuleStack object.
function M.fullName(self)
   local stack = self.stack
   local top   = stack[#stack]
   return top.full
end

--------------------------------------------------------------------------
-- Return the short module name for modulefile at the top of the stack.
-- @param self A ModuleStack object.
function M.sn(self)
   local stack = self.stack
   local top   = stack[#stack]
   return top.sn
end

--------------------------------------------------------------------------
-- Return the name specified by the user for modulefile at the top of the
-- stack.
-- @param self A ModuleStack object.
function M.usrName(self)
   local stack = self.stack
   local top   = stack[#stack]
   return top.usrName
end

--------------------------------------------------------------------------
-- Return the module version for modulefile at top of the stack.
-- @param self A ModuleStack object.
function M.version(self)
   local stack   = self.stack
   local top     = stack[#stack]
   local full    = top.full
   local sn      = top.sn
   return extractVersion(full, sn) or ""
end

--------------------------------------------------------------------------
-- Return the file name for modulefile at the top of the stack.
-- @param self A ModuleStack object.
function M.fileName(self)
   local stack = self.stack
   local top   = stack[#stack]
   return top.fn
end

function M.traceBack(self)
   local a     = {}
   local stack = self.stack

   for i = #stack, 2,-1 do
      a[#a+1] = {fullName = stack[i].full, fn = stack[i].fn }
   end
   return a
end

return M
