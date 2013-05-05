--------------------------------------------------------------------------
-- Lmod License
--------------------------------------------------------------------------
--
--  Lmod is licensed under the terms of the MIT license reproduced below.
--  This means that Lua is free software and can be used for both academic
--  and commercial purposes at absolutely no cost.
--
--  ----------------------------------------------------------------------
--
--  Copyright (C) 2008-2013 Robert McLay
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

-- BaseShell
require("strict")
require("inherits")
require("serializeTbl")
require("string_split")

local M            = {}

local Dbg          = require("Dbg")
local MT           = require("MT")
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
   return self.my_name
end

function M.setActive(self, active)
   self._active = active
end

function M.isActive(self)
   return self._active
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
      dbg.fini("BaseShell:expand")
      return
   end
      

   for k,v in pairsByKeys(tbl) do
      local vstr,vType = tbl[k]:expand()
      if (vType == "alias") then
         self:alias(k,vstr)
      elseif (vType == "shell_function") then
         self:shellFunc(k,vstr)
      elseif (vstr == "") then
         self:unset(k, vType)
      elseif (k == "_ModuleTable_") then
         self:expandMT(vstr)
      else
         self:expandVar(k,vstr,vType)
      end
   end   
         
   dbg.fini("BaseShell:expand")
end

function M.expandMT(self, vstr)
   local dbg = Dbg:dbg()
   dbg.start("BaseShell:expandMT(vstr)")
   local vv      = encode64(vstr)
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
      name    = format("_ModuleTable%03d_",i)
      local v = getenv(name)
      if (v == nil) then break end
      self:unset(name)
   end

   if (dbg.active()) then
      local mt     = MT:mt()
      local blank  = " "
      local indent = blank:rep(dbg.indentLevel()*2)
      local s      = serializeTbl{indent=true, name="_ModuleTable_",
                             value=mt}
      for line in s:split("\n") do
         io.stderr:write(indent,line,"\n")
      end
   end

   dbg.fini("BaseShell:expandMT")
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
