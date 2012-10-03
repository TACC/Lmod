-- -*- lua -*-

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
