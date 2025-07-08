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
Csh.myType         = 'csh'

--------------------------------------------------------------------------
-- Csh:alias(): Either define or undefine a Csh shell alias. Remove any
--              trailing semicolons in module definition.  Then add it back
--              in.  This way there is one and only one semicolon at the
--              end.

function Csh.set_alias(self, k, t)
   local vstr = t.vstr
   if (not vstr ) then
      stdout:write("unalias ",k,";\n")
      dbg.print{   "unalias ",k,";\n"}
   else
      vstr = vstr:gsub("%$%*","\\!*")
      vstr = vstr:gsub("%$([0-9])", "\\!:%1")
      vstr = vstr:gsub(";%s$","")
      stdout:write("alias ",k," '",vstr,"';\n")
      dbg.print{   "alias ",k," '",vstr,"';\n"}
   end
end

--------------------------------------------------------------------------
-- Csh:set_shell_function(): reuse the Csh:alias function after deciding if is
--                       a set or unset of the alias.

function Csh.set_shell_function(self,k,t)
   local vstr  = t.vstr
   local vv    = (type(vstr) == "table") and vstr[2] or ""
   t.vstr      = vv
   self:set_alias(k,t)
end

--------------------------------------------------------------------------
-- Csh:expandVar(): expand a single key-value pair into Csh syntax.

function Csh.expandVar(self, k, v)
   if (k:find("%.")) then
      return
   end
   local lineA       = {}
   local middle      = ' '
   v                 = tostring(v):gsub("!","\\!")
   v                 = v:multiEscaped()
   lineA[#lineA + 1] = "setenv "
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

function Csh.unset(self, k)
   if (k:find("%.")) then
      return
   end
   local lineA       = {}
   lineA[#lineA + 1] = "unsetenv "
   lineA[#lineA + 1] = k
   lineA[#lineA + 1] = ";\n"
   local line = concatTbl(lineA,"")
   stdout:write(line)
   dbg.print{   line}
end

function Csh.set_complete(self, name, value)
   local lineA = {}
   local n     = unwrap_kind("complete", name)
   if (value) then
      lineA[#lineA + 1]  = "complete "
      lineA[#lineA + 1]  = n
      lineA[#lineA + 1]  = " "
      lineA[#lineA + 1]  = value:multiEscaped()
      lineA[#lineA + 1]  = ";\n"
   else
      lineA[#lineA + 1]  = "uncomplete "
      lineA[#lineA + 1]  = n
      lineA[#lineA + 1]  = ";\n"
   end
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
