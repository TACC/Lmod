-- -*- lua -*-

require("strict")
require("pairsByKeys")

local BaseShell   = BaseShell
local Dbg         = require("Dbg")
local base64      = require("base64")
local concatTbl   = table.concat
local decode64    = base64.decode64
local encode64    = base64.encode64
local floor       = math.floor
local format      = string.format
local getenv      = os.getenv
local huge        = math.huge
local ipairs      = ipairs
local min         = math.min
local pairsByKeys = pairsByKeys
local stdout      = io.stdout

Csh	    = inheritsFrom(BaseShell)
Csh.my_name = 'csh'


-- module("Csh")

local function formLine(k, v, vType)
   local lineA       = {}
   local middle      = ' "'
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
   return concatTbl(lineA,"")
end

local function delLine(k, vType)
   local lineA       = {}
   if (vType == "local_var") then
      lineA[#lineA + 1] = "unset "
   else
      lineA[#lineA + 1] = "unsetenv "
   end
   lineA[#lineA + 1] = k
   lineA[#lineA + 1] = ";\n"
   return concatTbl(lineA,"")
end


local function expandMT(vv)
   local v       = encode64(vv)
   local a       = {}
   local vlen    = v:len()
   local blksize = 512
   local nblks   = floor((vlen - 1)/blksize) + 1
   local name
   local alen
   for i = 1, vlen, blksize do
      alen    = min(i+blksize-1,vlen)
      a[#a+1] = v:sub(i,alen)
   end
   for i,v in ipairs(a) do
      name = format("_ModuleTable%03d_",i)
      stdout:write("setenv ",name," \"",v,"\";\n")
   end
   stdout:write(formLine("_ModuleTable_Sz_",tostring(#a)))
   for i = nblks+1, huge do
      name = format("_ModuleTable%03d_",i)
      v    = getenv(name)
      if (v == nil) then break end
      stdout:write("unsetenv ",name,";\n")
   end
end

function Csh.expand(self,tbl)
   local dbg  = Dbg:dbg()
   for k in pairsByKeys(tbl) do
      local v, vType = tbl[k]:expand()
      if (vType == 'alias') then
         if (v == "")then
            stdout:write("unalias ",k,";\n")
            dbg.print(   "unalias ",k,";\n")
         else
            v = v:gsub("%$%*","\\!*")
            v = v:gsub("%$([0-9])", "\\!:%1")
            stdout:write("alias ",k," \"",v,"\";\n")
            dbg.print(   "alias ",k," \"",v,"\";\n")
         end
      elseif (v == '') then
         local s = delLine(k,vType)
	 stdout:write(s)
         dbg.print(   s)
      else
         local s = formLine(k,v,vType)
         dbg.print(   s)
         if (k == '_ModuleTable_') then
            expandMT(v)
         else
            stdout:write(s)
         end
      end
   end
end

return Csh
