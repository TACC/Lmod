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

--------------------------------------------------------------------------
-- Csh: This is a derived class from BaseShell.  This classes knows how
--      to expand the environment variable into Csh syntax.

_G._DEBUG          = false
local posix        = require("posix")

require("strict")
require("pairsByKeys")

local BaseShell    = require("BaseShell")
local Csh          = inheritsFrom(BaseShell)
local dbg          = require("Dbg"):dbg()
local concatTbl    = table.concat
local setenv_posix = posix.setenv
local stdout       = io.stdout
Csh.my_name        = 'csh'

--------------------------------------------------------------------------
-- Csh:alias(): Either define or undefine a Csh shell alias. Remove any
--              trailing semicolons in module definition.  Then add it back
--              in.  This way there is one and only one semicolon at the
--              end.

function Csh.alias(self, k, v)
   if (not v ) then
      stdout:write("unalias ",k,";\n")
      dbg.print{   "unalias ",k,";\n"}
   else
      v = v:gsub("%$%*","\\!*")
      v = v:gsub("%$([0-9])", "\\!:%1")
      v = v:gsub(";%s$","")
      stdout:write("alias ",k," '",v,"';\n")
      dbg.print{   "alias ",k," '",v,"';\n"}
   end
end

--------------------------------------------------------------------------
-- Csh:shellFunc(): reuse the Csh:alias function after deciding if is
--                  a set or unset of the alias.

function Csh.shellFunc(self,k,v)
   local vv = (type(v) == "table") and v[2] or ""
   self:alias(k,vv)
end

--------------------------------------------------------------------------
-- Csh:expandVar(): expand a single key-value pair into Csh syntax.

function Csh.expandVar(self, k, v, vType)
   if (k:find("%.")) then
      return
   end
   local lineA       = {}
   local middle      = ' '
   v                 = tostring(v):gsub("!","\\!")
   v                 = v:cshEscaped()
   if (vType == "local_var") then
      lineA[#lineA + 1] = "set "
      middle            = "="
   else
      lineA[#lineA + 1] = "setenv "
   end
   lineA[#lineA + 1] = k
   lineA[#lineA + 1] = middle
   lineA[#lineA + 1] = v
   lineA[#lineA + 1] = ";\n"
   local  line       = concatTbl(lineA,"")
   stdout:write(line)
   dbg.print{   line}
end

function Csh.echo(self, ...)
   setenv_posix("LC_ALL",nil,true)
   pcall(pager,io.stderr,...)
   setenv_posix("LC_ALL","C",true)
end

--------------------------------------------------------------------------
-- Csh:unset(): unset a local or env. variable.

function Csh.unset(self, k, vType)
   if (k:find("%.")) then
      return
   end
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
   dbg.print{   line}
end

--------------------------------------------------------------------------
-- Csh:real_shell(): Return true if the output shell is "real" or not.
--                   This base function returns false.  Bash, Csh
--                   and Fish should return true.

function Csh.real_shell(self)
   return true
end

return Csh
