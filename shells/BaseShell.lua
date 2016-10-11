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
--  Copyright (C) 2008-2014 Robert McLay
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
-- BaseShell:  This is the base class for all the shell output classes.

require("strict")
require("inherits")
require("serializeTbl")
require("string_utils")
require("utils")
local M            = {}

local dbg          = require("Dbg"):dbg()
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
local pack         = (_VERSION == "Lua 5.1") and argsPack   or table.pack
local pairsByKeys  = pairsByKeys


--------------------------------------------------------------------------
-- BaseShell Member functions:
--------------------------------------------------------------------------

--------------------------------------------------------------------------
-- BaseShell:name(): returns the derived class's name: (e.g. bash)

function M.name(self)
   return self.my_name
end

--------------------------------------------------------------------------
-- BaseShell:setActive(): Should shell output be turned on.  Currently
--                        checkSyntax mode is the only thing that turns off
--                        output.

function M.setActive(self, active)
   self._active = active
end

--------------------------------------------------------------------------
-- BaseShell:real_shell(): Return true if the output shell is "real" or not.
--                         This base function returns false.  Bash, Csh
--                         and Fish should return true.

function M.real_shell(self)
   return false
end

--------------------------------------------------------------------------
-- BaseShell:isActive(): Are we active.

function M.isActive(self)
   return self._active
end


--------------------------------------------------------------------------
-- BaseShell:expand(): This base class function is what converts the
--                     environment variables stored internally into
--                     strings.  Each variable knows its type, so this
--                     routine does a big switch on each type and calls
--                     the derived shell class member function to do the
--                     actual expansion to standard out (io.stdout).

function M.expand(self, tbl)
   dbg.start{"BaseShell:expand(tbl)"}

   if ( not self._active) then
      dbg.print{"expand is not active\n"}
      dbg.fini("BaseShell:expand")
      return
   end


   for k,v in pairsByKeys(tbl) do
      local vstr, vType, priorityStrT = v:expand()
      if (next(priorityStrT)) then
         for prtyKey,prtyStr in pairs(priorityStrT) do
            self:expandVar(prtyKey,prtyStr,"path")
         end
      end
      if (vType == "alias") then
         self:alias(k,vstr)
      elseif (vType == "shell_function") then
         self:shellFunc(k,vstr)
      elseif (not vstr) then
         self:unset(k, vType)
      elseif (k == "_ModuleTable_") then
         self:expandMT(vstr)
      else
         self:expandVar(k,vstr,vType)
      end
   end

   dbg.fini("BaseShell:expand")
end

--------------------------------------------------------------------------
-- BaseShell:expandMT():  This routine outputs the _ModuleTable_.  This
--                        table is how Lmod knows its state.  It is a lua
--                        table which is serialized into a string.  Then
--                        this string is uuencode and broken up into
--                        512 pieces.  This way the shell's little brain
--                        won't be taxed to much.

function M.expandMT(self, vstr)
   dbg.start{"BaseShell:expandMT(vstr)"}
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
      local indent = dbg.indent()
      local s      = serializeTbl{indent=true, name="_ModuleTable_",
                             value=mt}
      for line in s:split("\n") do
         io.stderr:write(indent,line,"\n")
      end
   end

   dbg.fini("BaseShell:expandMT")
end


function M.echo(self, ...)
   if (LMOD_REDIRECT == "no") then
      pcall(pager,io.stderr,...)
   else
      local arg = pack(...)
      for i = 1, arg.n do
         local whole=arg[i]
         if (whole:sub(-1) == "\n") then
            whole = whole:sub(1,-2)
         end
         for line in whole:split("\n") do
            line = line:gsub("'","'\"'\"'"):gsub(" ","' '")
            io.stdout:write("echo '",line,"';\n")
         end
      end
   end
end

function M._echo(self, ...)
   local arg = pack(...)
   for i = 1, arg.n do
      io.stderr:write(arg[i])
   end
end

--------------------------------------------------------------------------
-- valid_shell:  returns the valid shell name if it is in the shellTbl or
--               bare otherwise.

local function valid_shell(shellTbl, shell_name)
   if (not shellTbl[shell_name]) then
      return shellTbl.bare
   end
   return shellTbl[shell_name]
end

s_shellTbl = false

local function createShellTbl()
   if (not s_shellTbl) then
      local shellTbl     = {}
      local Csh          = require('Csh')
      local Bash         = require('Bash')
      local Bare         = require('Bare')
      local Fish         = require('Fish')
      local Perl         = require('Perl')
      local Python       = require('Python')
      local R            = require('R')
      shellTbl["sh"]     = Bash
      shellTbl["bash"]   = Bash
      shellTbl["zsh"]    = Bash
      shellTbl["fish"]   = Fish
      shellTbl["csh"]    = Csh
      shellTbl["tcsh"]   = Csh
      shellTbl["perl"]   = Perl
      shellTbl["python"] = Python
      shellTbl["r"]      = R
      shellTbl.bare      = Bare
      s_shellTbl         = shellTbl
   end
end


function M.isValid(shell_name)
   createShellTbl()
   return s_shellTbl[shell_name]
end

--------------------------------------------------------------------------
-- BaseShell:build():  This is the factory that builds the derived shell.

function M.build(shell_name)
   createShellTbl()
   local o     = valid_shell(s_shellTbl, shell_name):create()
   o._active   = true
   return o
end

return M
