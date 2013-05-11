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
require("pairsByKeys")

local BaseShell   = BaseShell
local Dbg         = require("Dbg")
local concatTbl   = table.concat
local stdout      = io.stdout

Csh	    = inheritsFrom(BaseShell)
Csh.my_name = 'csh'


function Csh.shellFunc(self,k,v)
   local dbg = Dbg:dbg()
   if (v == "") then
      stdout:write("unalias ",k,";\n")
      dbg.print(   "unalias ",k,";\n")
   else
      v = v[2]
      v = v:gsub("%$%*","\\!*")
      v = v:gsub("%$([0-9])", "\\!:%1")
      stdout:write("alias ",k," '",v,"';\n")
      dbg.print(   "alias ",k," '",v,"';\n")
   end
end


function Csh.alias(self, k, v)
   local dbg = Dbg:dbg()
   if (v == "") then
      stdout:write("unalias ",k,";\n")
      dbg.print(   "unalias ",k,";\n")
   else
      v = v:gsub("%$%*","\\!*")
      v = v:gsub("%$([0-9])", "\\!:%1")
      stdout:write("alias ",k," '",v,"';\n")
      dbg.print(   "alias ",k," '",v,"';\n")
   end
end

function Csh.expandVar(self, k, v, vType)
   local dbg = Dbg:dbg()
   local lineA       = {}
   local middle      = ' "'
   v                 = tostring(v)
   v                 = v:gsub("!","\\!")
   v                 = doubleQuoteEscaped(v)
   if (vType == "local_var") then
      lineA[#lineA + 1] = "set "
      middle            = "=\""
   else
      lineA[#lineA + 1] = "setenv "
   end
   lineA[#lineA + 1] = k
   lineA[#lineA + 1] = middle
   lineA[#lineA + 1] = v
   lineA[#lineA + 1] = "\";\n"
   local  line       = concatTbl(lineA,"")
   stdout:write(line)
   dbg.print(   line)
end

function Csh.unset(self, k, vType)
   local dbg = Dbg:dbg()
   local lineA       = {}
   if (vType == "local_var") then
      lineA[#lineA + 1] = "unset "
   else
      lineA[#lineA + 1] = "unsetenv "
   end
   lineA[#lineA + 1] = k
   lineA[#lineA + 1] = ";\n"
   local line = concatTbl(lineA,"")
   stdout:write(line)
   dbg.print(   line)
end

return Csh
