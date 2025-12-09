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

--------------------------------------------------------------------------
-- Python(): This is a derived class from BaseShell.  It expands variables
--           into python syntax.  Note that aliases and shell functions are
--           ignored as they do not make sense in Python.

require("strict")

local BaseShell = require("BaseShell")
local Python    = inheritsFrom(BaseShell)
local dbg       = require("Dbg"):dbg()
local Var       = require("Var")
local concatTbl = table.concat
local stdout    = io.stdout
Python.my_name  = "python"
Python.myType   = Python.my_name

function Python.echo(self,...)
   self:_echo(...)
end

function Python.expandVar(self, k, v, vType)
   local lineA = {}
   v                 = tostring(v):doubleQuoteString()
   lineA[#lineA + 1] = 'os.environ['
   lineA[#lineA + 1] = k:doubleQuoteString()
   lineA[#lineA + 1] = '] = '
   lineA[#lineA + 1] = v
   lineA[#lineA + 1] = ';\n'
   local line        = concatTbl(lineA,"")
   stdout:write(line)
   dbg.print{   line}
end

function Python.unset(self, k)
   local lineA = {}
   -- We set environment key first to avoid Python key error
   -- in case key isn't set.
   lineA[#lineA + 1] = "os.environ["
   lineA[#lineA + 1] = k:doubleQuoteString()
   lineA[#lineA + 1] = "] = ''\n"
   lineA[#lineA + 1] = "del os.environ["
   lineA[#lineA + 1] = k:doubleQuoteString()
   lineA[#lineA + 1] = "]\n"
   local line        = concatTbl(lineA,"")
   stdout:write(line)
   dbg.print{   line}
end

function Python.initialize(self)
   local line = "import os\n"
   stdout:write(line)
   dbg.print{   line}
end

function Python.report_failure(self)
   local line = "_mlstatus = False\n"
   stdout:write(line)
   dbg.print{   line}
end

function Python.report_success(self)
   local line = "_mlstatus = True\n"
   stdout:write(line)
   dbg.print{   line}
end

return Python
