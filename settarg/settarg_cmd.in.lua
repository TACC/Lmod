#!@path_to_lua@/lua
-- -*- lua -*-
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


local LuaCommandName = arg[0]
local i,j = LuaCommandName:find(".*/")
local LuaCommandName_dir = "./"
if (i) then
   LuaCommandName_dir = LuaCommandName:sub(1,j)
end

package.path = LuaCommandName_dir .. "../tools/?.lua;" ..
               LuaCommandName_dir .. "?.lua;"       ..
               LuaCommandName_dir .. "?/init.lua;"  ..
               package.path

function cmdDir()
   return LuaCommandName_dir
end

if (not pcall(require,"strict")) then
   os.exit(0)
end

local master = {}

function masterTbl()
   return master
end

BaseShell      = require("BaseShell")

local Dbg            = require("Dbg")
local CmdLineOptions = require("CmdLineOptions")
local BuildTarget    = require("BuildTarget")
require("ModifyPath")
require("Output")
require("FindProjectData")

function main()
   local dbg         = Dbg:dbg()
   local masterTbl   = masterTbl()
   masterTbl.execDir = cmdDir()

   CmdLineOptions:options()
   if (masterTbl.debug) then
      dbg:activateDebug(1)
   end
   dbg.start("settarg()")

   if (masterTbl.cmdHelp) then
      io.stderr:write("Lmod settarg ",Version.name(),"\n")
      io.stderr:write(masterTbl.cmdHelpMsg,"\n")
      dbg.fini("settarg")
      return
   end

   if (masterTbl.version) then
      io.stderr:write("Lmod settarg ",Version.name(),"\n")
      os.exit(0)
   end

   ------------------------------------------
   -- Build shell object
   local shell = BaseShell.build(masterTbl.shell)

   BuildTarget.exec(shell, FindProjectData())
   ModifyPath()
   Output(shell)
   dbg.fini("settarg")
end

main()
