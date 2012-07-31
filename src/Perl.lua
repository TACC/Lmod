-- -*- lua -*-
require("strict")

Perl              = inheritsFrom(BaseShell)
Perl.my_name      = "perl"

local Perl        = Perl
local Dbg         = require("Dbg")
local concatTbl   = table.concat
local stdout      = io.stdout

function Perl.alias(self, k, v)
   -- do nothing: alias do not make sense in a perl script
end

function Perl.expandVar(self, k, v, vType)
   local dbg = Dbg:dbg()
   local lineA = {}
   v = atSymbolEscaped(doubleQuoteEscaped(v))

   lineA[#lineA + 1] = '$ENV{'
   lineA[#lineA + 1] = k
   lineA[#lineA + 1] = '}="'
   lineA[#lineA + 1] = v
   lineA[#lineA + 1] = "\";\n"
   local line        = concatTbl(lineA,"")
   stdout:write(line)
   dbg.print(   line)
end

function Perl.unset(self, k, vType)
   local dbg = Dbg:dbg()
   stdout:write("delete $ENV{",name,"};\n")
   dbg.print(   "delete $ENV{",name,"};\n")
end

return Perl
