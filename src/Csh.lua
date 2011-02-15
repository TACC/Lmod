-- -*- lua -*-
-- $Id: Csh.lua 457 2009-04-02 22:34:23Z mclay $ --

require("strict")
require("base64")
require("pairsByKeys")
require("Dbg")

local BaseShell   = BaseShell
local Dbg         = Dbg
local concat      = table.concat
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


module("Csh")

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
      stdout:write("setenv ",name," '",v,"';\n")
   end
   for i = nblks+1, huge do
      name = format("_ModuleTable%03d_",i)
      v    = getenv(name)
      if (v == nil) then break end
      stdout:write("unsetenv ",name,";\n")
   end
end

function expand(self,tbl)
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
         local cmd = "unsetenv "
         if (vType == "local_var") then
            cmd = "unset "
         end
	 stdout:write(cmd, k,";\n")
         dbg.print(   cmd, k,";\n")
      elseif (vType == "local_var") then
         v = v:gsub("!","\\!")
         stdout:write("set ",k,"='",v,"';\n")
         dbg.print(   "set ",k,"='",v,"';\n")
      else
         if (k == '_ModuleTable_') then
            expandMT(v)
         else
            stdout:write("setenv ",k," '",v,"';\n")
         end
         dbg.print("setenv ",k," '",v,"';\n")
      end
   end
end
