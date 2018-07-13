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
-- Fish: This is a derived class from BaseShell.  This classes knows how
--       to expand the environment variable into bash syntax.


require("strict")


local BaseShell = require("BaseShell")
local Fish      = inheritsFrom(BaseShell)
local dbg       = require("Dbg"):dbg()
local Var       = require("Var")
local concatTbl = table.concat
local stdout    = io.stdout
Fish.my_name    = "fish"

--------------------------------------------------------------------------
-- Fish:alias(): Either define or undefine a fish shell alias.
--               Modify module definition of alias so that there is
--               one and only one semicolon at the end.

function Fish.alias(self, k, v)
   if (not v) then
      stdout:write("functions -e ",k,";\n")
      dbg.print{   "functions -e ",k,";\n"}
   else
      v = v:gsub(";%s*$","")
      stdout:write("alias ",k,"='",v,"';\n")
      dbg.print{   "alias ",k,"='",v,"';\n"}
   end
end

--------------------------------------------------------------------------
-- Fish:shellFunc(): Either define or undefine a fish shell function.
--                   Modify module definition of function so that there is
--                   one and only one semicolon at the end.

function Fish.shellFunc(self, k, v)
   if (not v) then
      stdout:write("functions -e ",k,";\n")
      dbg.print{   "functions -e ",k,";\n"}
   else
      local func = v[1]:gsub(";%s*$","")
      stdout:write("function ",k,"; ",func,"; end;\n")
      dbg.print{   "function ",k,"; ",func,"; end;\n"}
   end
end


--------------------------------------------------------------------------
-- Fish:expandVar(): Define either a global or local variable in bash
--                   syntax

function Fish.expandVar(self, k, v, vType)
   local lineA       = {}
   v                 = tostring(v):multiEscaped()
   if (k == "PATH" or k == "INFOPATH") then
      v = v:gsub(":",' ')
   end
   lineA[#lineA + 1] = "set "
   lineA[#lineA + 1] = "-x "
   if (vType ~= "local_var") then
      lineA[#lineA + 1] = "-g "
   end
   lineA[#lineA + 1] = k
   lineA[#lineA + 1] = " "
   lineA[#lineA + 1] = v
   lineA[#lineA + 1] = ";\n"
   local line = concatTbl(lineA,"")
   stdout:write(line)
   dbg.print{   line}
end

--------------------------------------------------------------------------
-- Fish:unset() unset an environment variable.

function Fish.unset(self, k, vType)
   stdout:write("set -e ",k,";\n")
   dbg.print{   "set -e ",k,";\n"}
end


--------------------------------------------------------------------------
-- Fish:real_shell(): Return true if the output shell is "real" or not.
--                    This base function returns false.  Bash, Csh
--                    and Fish should return true.

function Fish.real_shell(self)
   return true
end

return Fish
