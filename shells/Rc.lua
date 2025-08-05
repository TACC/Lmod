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
--  Copyright (C) 2021 Oak Ridge National Laboratory
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
-- Rc: This is a derived class from BaseShell.  This classes knows how
--      to expand the environment variable into Rc syntax.

_G._DEBUG          = false
local posix        = require("posix")

require("strict")
require("pairsByKeys")

local BaseShell    = require("BaseShell")
local Rc           = inheritsFrom(BaseShell)
local dbg          = require("Dbg"):dbg()
local concatTbl    = table.concat
local stdout       = io.stdout
local posix_setenv = posix.setenv
local cosmic       = require("Cosmic"):singleton()
Rc.my_name         = 'rc'
Rc.myType          = 'rc'

--------------------------------------------------------------------------
-- Rc:alias(): Either define or undefine an Rc shell alias. Remove any
--             trailing semicolons in module definition.  Then add it back
--             in.  This way there is one and only one semicolon at the
--             end.

function Rc.set_alias(self, k, t)
  local vstr  = t.vstr
  local lineA = {}
  lineA[#lineA + 1] = "fn "
  lineA[#lineA + 1] = k
  lineA[#lineA + 1] = " { "
  if (k:find("^" .. k .. " ")) then
    -- detect whether k is an alias for k itself
    lineA[#lineA + 1] = "builtin "
  end
  lineA[#lineA + 1] = vstr
  lineA[#lineA + 1] = " $* }\n"
  local line = concatTbl(lineA,"")
  stdout:write(line)
  dbg.print{   line}
end

--------------------------------------------------------------------------
-- Rc:expandVar(): expand a single key-value pair into Rc syntax.

function Rc.expandVar(self, k, v, vType)
   if (k:find("%.")) then
      return
   end
   local lineA = {}
   lineA[#lineA + 1] = k
   lineA[#lineA + 1] = "='"
   lineA[#lineA + 1] = tostring(v):gsub("'", "''")
   lineA[#lineA + 1] = "';\n"
   -- Note: there is no concept of file-scoped local variables in rc
   -- only command-scoped ones
   local line = concatTbl(lineA,"")
   stdout:write(line)
   if (k:find('^_ModuleTable') == nil) then
      dbg.print{line}
   end
end

function Rc.echo(self, ...)
   local LMOD_REDIRECT = cosmic:value("LMOD_REDIRECT")
   if (LMOD_REDIRECT == "no") then
      posix_setenv("LC_ALL",nil,true)
      pcall(pager,io.stderr,...)
      posix_setenv("LC_ALL","C",true)
   else
      local argA = pack(...)
      for i = 1, argA.n do
         local whole = argA[i]
         if (whole:sub(-1) == "\n") then
            whole = whole:sub(1,-2)
         end
         for line in whole:split("\n") do
            line = line:gsub("'","''")
            stdout:write("echo '",line,"';\n")
         end
      end
   end
end

--------------------------------------------------------------------------
-- Rc:unset(): unset a local or env. variable.

function Rc.unset(self, k)
   if (k:find("%.")) then
      return
   end
   local line = k .. "=()\n"
   stdout:write(line)
   dbg.print{   line}
end

--------------------------------------------------------------------------
-- Rc:real_shell(): Return true because `rc` is executable.

function Rc.real_shell(self)
   return true
end

return Rc
