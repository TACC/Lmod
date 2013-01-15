-- BaseShell
require("strict")
require("inherits")

local M            = {}

local Dbg          = require("Dbg")
local base64       = require("base64")
local concatTbl    = table.concat
local decode64     = base64.decode64
local encode64     = base64.encode64
local floor        = math.floor
local format       = string.format
local getenv       = os.getenv
local huge         = math.huge
local min          = math.min
local pairsByKeys  = pairsByKeys
local print	   = print
local setmetatable = setmetatable
local type	   = type

function doubleQuoteEscaped(s)
   s = s:gsub('"','\\"')
   return s
end

function singleQuoteEscaped(s)
   s = s:gsub("'","\\'")
   return s
end

function atSymbolEscaped(s)
   s = s:gsub('@','\\@')
   return s
end

------------------------------------------------------------------------
--module ('BaseShell')
------------------------------------------------------------------------

function M.name(self)
   print ("Shell name:",self.my_name)
end

function M.setActive(self, active)
   self._active = active
end


function M.getMT(self)
   local a    = {}
   local mtSz = getenv("_ModuleTable_Sz_") or huge
   local s    = nil

   for i = 1, mtSz do
      local name = format("_ModuleTable%03d_",i)
      local v    = getenv(name)
      if (v == nil) then break end
      a[#a+1]    = v
   end
   if (#a > 0) then
      s = decode64(concatTbl(a,""))
   end
   return s
end

local function valid_shell(shellTbl, shell_name)
   if (not shellTbl[shell_name]) then
      return shellTbl.bare
   end
   return shellTbl[shell_name]
end

function M.expand(self, tbl)
   local dbg = Dbg:dbg()
   dbg.start("BaseShell:expand(tbl)")

   if ( not self._active) then
      dbg.print("expand is not active\n")
      dbg.fini()
      return
   end
      

   for k,v in pairsByKeys(tbl) do
      local v,vType = tbl[k]:expand()
      if (vType == "alias") then
         self:alias(k,v)
      elseif (vType == "shell_function") then
         self:shellFunc(k,v)
      elseif (v == "") then
         self:unset(k, vType)
      elseif (k == "_ModuleTable_") then
         self:expandMT(v)
      else
         self:expandVar(k,v,vType)
      end
   end   
         
   dbg.fini()
end

function M.expandMT(self, v)
   local dbg = Dbg:dbg()
   dbg.start("BaseShell:expandMT(v)")
   local vv      = encode64(v)
   local a       = {}
   local vlen    = vv:len()
   local blksize = 512
   local nblks   = floor((vlen - 1)/blksize) + 1
   local name
   local alen

   for i = 1, vlen, blksize do
      alen    = min(i+blksize-1,vlen)
      a[#a+1] = vv:sub(i,alen)
   end
   for i = 1, #a do
      name = format("_ModuleTable%03d_",i)
      self:expandVar(name, a[i])
   end
   self:expandVar("_ModuleTable_Sz_",tostring(#a))

   for i = nblks+1, huge do
      name = format("_ModuleTable%03d_",i)
      v    = getenv(name)
      if (v == nil) then break end
      self:unset(name)
   end
   dbg.fini()
end


function M.build(shell_name)

   local shellTbl     = {}
   local Csh          = require('Csh')
   local Bash         = require('Bash')
   local Bare         = require('Bare')
   local Perl         = require('Perl')
   local Python       = require('Python')
   shellTbl["sh"]     = Bash
   shellTbl["bash"]   = Bash
   shellTbl["zsh"]    = Bash
   shellTbl["csh"]    = Csh
   shellTbl["tcsh"]   = Csh
   shellTbl["perl"]   = Perl
   shellTbl["python"] = Python
   shellTbl.bare      = Bare

   local o     = valid_shell(shellTbl, shell_name):create()
   o._active   = true
   return o
end

return M
