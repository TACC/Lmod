-- -*- lua -*-
require("strict")

Python            = inheritsFrom(BaseShell)
Python.my_name    = "python"

local Python      = Python
local Dbg         = require("Dbg")
local Var         = require("Var")
local assert      = assert
local concatTbl   = table.concat
local stdout      = io.stdout

function Python.alias(self, k, v)
   -- do nothing: alias do not make sense in a python script
end

function Python.expandVar(self, k, v, vType)
   local dbg = Dbg:dbg()
   local lineA = {}
   v = singleQuoteEscaped(v)

   lineA[#lineA + 1] = "os.environ['"
   lineA[#lineA + 1] = k
   lineA[#lineA + 1] = "'] = '"
   lineA[#lineA + 1] = v
   lineA[#lineA + 1] = "';\n"
   local line        = concatTbl(lineA,"")
   stdout:write(line)
   dbg.print(   line)
end

function Python.unset(self, k, vType)
   local dbg = Dbg:dbg()
   local lineA = {}
   lineA[#lineA + 1] = "os.environ['"
   lineA[#lineA + 1] = k
   lineA[#lineA + 1] = "'] = ''\n"
   lineA[#lineA + 1] = "del os.environ['"
   lineA[#lineA + 1] = k
   lineA[#lineA + 1] = "']\n"
   local line        = concatTbl(lineA,"")
   stdout:write(line)
   dbg.print(   line)
end

return Python
