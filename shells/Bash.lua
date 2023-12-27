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
-- Bash: This is a derived class from BaseShell.  This classes knows how
--       to expand the environment variable into bash syntax.


require("strict")


local BaseShell = require("BaseShell")
local Bash      = inheritsFrom(BaseShell)
local dbg       = require("Dbg"):dbg()
local Var       = require("Var")
local concatTbl = table.concat
local cosmic    = require("Cosmic"):singleton()
local stdout    = io.stdout
Bash.my_name    = "bash"
Bash.myType     = "sh"

--------------------------------------------------------------------------
-- Bash:alias(): Either define or undefine a bash shell alias.
--               Modify module definition of function so that there is
--               one and only one semicolon at the end.

function Bash.alias(self, k, v)
   if (not v) then
      stdout:write("unalias ",k," 2> /dev/null || true;\n")
      dbg.print{   "unalias ",k," 2> /dev/null || true;\n"}
   else
      v = v:gsub(";%s*$",""):multiEscaped()

      stdout:write("alias ",k,"=",v,";\n")
      dbg.print{   "alias ",k,"=",v,";\n"}
   end
end

local function l_build_shell_func(name, func)
   local a = {}
   a[#a+1] = name
   a[#a+1] = " () { ";
   a[#a+1] = func:gsub("\n$","")
   a[#a+1] = "; \n};\n"
   return concatTbl(a,"")
end

--------------------------------------------------------------------------
-- Bash:shellFunc(): Either define or undefine a bash shell function.
--                   Modify module definition of function so that there is
--                   one and only one semicolon at the end.

function Bash.shellFunc(self, k, v)
   if (not v) then
      stdout:write("unset -f ",k," 2> /dev/null || true;\n")
      dbg.print{   "unset -f ",k," 2> /dev/null || true;\n"}
   else
      local func = v[1]:gsub(";%s*$","")
      local str  = l_build_shell_func(k, func);
      stdout:write(str)
      dbg.print{   str}
   end
end


--------------------------------------------------------------------------
-- Bash:expandVar(): Define either a global or local variable in bash
--                   syntax

function Bash.expandVar(self, k, v, vType)
   local lineA       = {}
   local nl          = [["
"]]
   if (k:find("%.")) then
      return
   end
   v                 = tostring(v):multiEscaped()
   if (v:find("\n")) then
      v = v:gsub("\n",nl)
   end
   lineA[#lineA + 1] = k
   lineA[#lineA + 1] = "="
   lineA[#lineA + 1] = v
   lineA[#lineA + 1] = ";\n"
   if (vType ~= "local_var") then
      lineA[#lineA + 1] = "export "
      lineA[#lineA + 1] = k
      lineA[#lineA + 1] = ";\n"
   end
   local line = concatTbl(lineA,"")
   stdout:write(line)
   if (k:find('^_ModuleTable') == nil) then
      dbg.print{line}
   end
end

--------------------------------------------------------------------------
-- Bash:unset() unset an environment variable.

function Bash.unset(self, k, vType)
   if (k:find("%.")) then
      return
   end
   stdout:write("unset ",k,";\n")
   dbg.print{   "unset ",k,";\n"}
end

function Bash.complete(self, name, value)
   local lineA = {}
   local n     = unwrap_complete(name)
   if (value) then
      lineA[#lineA + 1]  = "[[ -n \"${BASH_VERSION:-}\" ]] && complete "
      lineA[#lineA + 1]  = value
      lineA[#lineA + 1]  = " "
      lineA[#lineA + 1]  = n
      lineA[#lineA + 1]  = ";\n"
   else
      lineA[#lineA + 1]  = "[[ -n \"${BASH_VERSION:-}\" ]] && complete -r "
      lineA[#lineA + 1]  = n
      lineA[#lineA + 1]  = ";\n"
   end
   local line = concatTbl(lineA,"")
   stdout:write(line)
   dbg.print{   line}
end


--------------------------------------------------------------------------
-- Bash:real_shell(): Return true if the output shell is "real" or not.
--                    This base function returns false.  Bash, Csh
--                    and Fish should return true.

function Bash.real_shell(self)
   return true
end

return Bash
