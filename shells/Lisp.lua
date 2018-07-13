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
-- Lisp: This is a derived class from BaseShell.  This classes knows how
--       to expand the environment variable into lisp syntax.


require("strict")


local BaseShell = require("BaseShell")
local Lisp      = inheritsFrom(BaseShell)
local dbg       = require("Dbg"):dbg()
local Var       = require("Var")
local concatTbl = table.concat
local stdout    = io.stdout
Lisp.my_name    = "lisp"

--------------------------------------------------------------------------
-- Bash:alias(): Either define or undefine a bash shell alias.
--               Modify module definition of function so that there is
--               one and only one semicolon at the end.

function Lisp.alias(self, k, v)
   -- do nothing: alias do not make sense in lisp.
end

--------------------------------------------------------------------------
-- Lisp:shellFunc(): Either define or undefine a bash shell function.
--                   Modify module definition of function so that there is
--                   one and only one semicolon at the end.

function Lisp.shellFunc(self, k, v)
   -- do nothing: shell functions do not make sense in lisp.
end


--------------------------------------------------------------------------
-- Lisp:expandVar(): Define either a global or local variable in bash
--                   syntax

function Lisp.expandVar(self, k, v, vType)
   local lineA       = {}
   if (k:find("%.")) then
      return
   end
   v                 = tostring(v):multiEscaped()
   lineA[#lineA + 1] = "(setenv \""
   lineA[#lineA + 1] = k
   lineA[#lineA + 1] = "\" "
   lineA[#lineA + 1] = v
   lineA[#lineA + 1] = ")\n"
   local line = concatTbl(lineA,"")
   stdout:write(line)
   if (k:find('^_ModuleTable') == nil) then
      dbg.print{   line}
   end
end

--------------------------------------------------------------------------
-- Lisp:unset() unset an environment variable.

function Lisp.unset(self, k, vType)
   if (k:find("%.")) then
      return
   end
   stdout:write("(setenv \"",k,"\" nil)\n")
   dbg.print{   "(setenv \"",k,"\" nil)\n"}
end

--------------------------------------------------------------------------
-- Lisp:real_shell(): Return true if the output shell is "real" or not.
--                    This base function returns false.  Bash, Csh
--                    and Fish should return true.

function Lisp.real_shell(self)
   return false
end

return Lisp
