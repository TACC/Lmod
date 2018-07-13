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
-- Perl(): This is a derived class from BaseShell.  It expands variables
--         into perl syntax.  Note that aliases and shell functions are
--         ignored as they do not make sense in Perl.

require("strict")

local BaseShell = require("BaseShell")
local Perl      = inheritsFrom(BaseShell)
local dbg       = require("Dbg"):dbg()
local concatTbl = table.concat
local stdout    = io.stdout
Perl.my_name    = "perl"

function Perl.alias(self, k, v)
   -- do nothing: alias do not make sense in a perl script.
end

function Perl.shellFunc(self, k, v)
   -- do nothing: shell functions do not make sense in a perl script.
end

function Perl.echo(self,...)
   self:_echo(...)
end

function Perl.expandVar(self, k, v, vType)
   local lineA = {}
   v = v:doubleQuoteString():atSymbolEscaped()

   lineA[#lineA + 1] = '$ENV{'
   lineA[#lineA + 1] = k
   lineA[#lineA + 1] = '}='
   lineA[#lineA + 1] = v
   lineA[#lineA + 1] = ";\n"
   local line        = concatTbl(lineA,"")
   stdout:write(line)
   dbg.print{   line}
end

function Perl.unset(self, k, vType)
   stdout:write("delete $ENV{",k,"};\n")
   dbg.print{   "delete $ENV{",k,"};\n"}
end

return Perl
