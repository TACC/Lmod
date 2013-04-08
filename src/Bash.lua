-- -*- lua -*-
require("strict")

Bash              = inheritsFrom(BaseShell)
Bash.my_name      = "bash"

local Bash        = Bash
local Dbg         = require("Dbg")
local Var         = require("Var")
local concatTbl   = table.concat
local stdout      = io.stdout

function Bash.alias(self, k, v)
   local dbg = Dbg:dbg()
   if (v == "") then
      stdout:write("unalias ",k,";\n")
      dbg.print(   "unalias ",k,";\n")
   else
      stdout:write("alias ",k,"=\"",v,"\";\n")
      dbg.print(   "alias ",k,"=\"",v,"\";\n")
   end
end
   
function Bash.shellFunc(self, k, v)
   local dbg = Dbg:dbg()
   if (v == "") then
      stdout:write("unset -f ",k,";\n")
      dbg.print(   "unset -f ",k,";\n")
   else
      stdout:write(k,"() {",v[1]," };\n")
      dbg.print(   k,"() {",v[1]," };\n")
   end
end   


function Bash.expandVar(self, k, v, vType)
   local dbg = Dbg:dbg()
   dbg.print("Key: ", k, " type(value): ", type(v)," value: ",v,"\n")
   local lineA       = {}
   v                 = doubleQuoteEscaped(tostring(v))
   lineA[#lineA + 1] = k
   lineA[#lineA + 1] = "=\""
   lineA[#lineA + 1] = v
   lineA[#lineA + 1] = "\";\n"
   if (vType ~= "local_var") then
      lineA[#lineA + 1] = "export "
      lineA[#lineA + 1] = k
      lineA[#lineA + 1] = ";\n"
   end
   local line = concatTbl(lineA,"")
   stdout:write(line)
   dbg.print(   line)
end

function Bash.unset(self, k, vType)
   local dbg = Dbg:dbg()
   stdout:write("unset ",k,";\n")
   dbg.print(   "unset ",k,";\n")
end


return Bash
