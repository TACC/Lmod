-- -*- lua -*-
require("strict")

Bash              = inheritsFrom(BaseShell)
Bash.my_name      = "bash"

local Bash        = Bash
local Dbg         = require("Dbg")
local Var         = require("Var")
local assert      = assert
local base64      = require("base64")
local concat      = table.concat
local encode64    = base64.encode64
local floor       = math.floor
local format      = string.format
local getenv      = os.getenv
local huge        = math.huge
local ipairs      = ipairs
local min         = math.min
local pairs       = pairs
local pairsByKeys = pairsByKeys
local stdout      = io.stdout
local systemG     = _G

local function formLine(k,v, vType)
   local lineA = {}
   lineA[#lineA + 1] = k
   lineA[#lineA + 1] = "='"
   lineA[#lineA + 1] = v
   lineA[#lineA + 1] = "';\n"
   if (vType ~= "local_var") then
      lineA[#lineA + 1] = "export "
      lineA[#lineA + 1] = k
      lineA[#lineA + 1] = ";\n"
   end
   return concat(lineA,"")
end

local function expandMT(vv)
   local dbg     = Dbg:dbg()
   local v       = encode64(vv)
   local a       = {}
   local vlen    = v:len()
   local blksize = 512
   local nblks   = floor((vlen - 1)/blksize) + 1
   local name
   local alen
   local line    = formLine("_ModuleTable_", vv, "path")
   dbg.print(line)
   
   for i = 1, vlen, blksize do
      alen    = min(i+blksize-1,vlen)
      a[#a+1] = v:sub(i,alen)
   end
   for i,v in ipairs(a) do
      name = format("_ModuleTable%03d_",i)
      stdout:write(formLine(name,v,nil))
   end
   for i = nblks+1, huge do
      name = format("_ModuleTable%03d_",i)
      v    = getenv(name)
      if (v == nil) then break end
      stdout:write("unset ",name,";\n")
   end
end

function Bash.expand(self,tbl)
   local dbg   = Dbg:dbg()

   for k,v in pairsByKeys(tbl) do
      local v,vType = tbl[k]:expand()
      if (vType == "alias") then
         if (v == "") then
            stdout:write("unalias ",k,";\n")
            dbg.print(   "unalias ",k,";\n")
         else
            stdout:write("alias ",k,"=\"",v,"\";\n")
            dbg.print(   "alias ",k,"=\"",v,"\";\n")
         end
      elseif (v == "") then
	 stdout:write("unset '",k,"';\n")
         dbg.print(   "unset '",k,"';\n")
      elseif (k == "_ModuleTable_") then
         expandMT(v)
      else
         local line = formLine(k,v, vType)
	 stdout:write(line)
	 dbg.print(line)
      end
   end
end

return Bash
