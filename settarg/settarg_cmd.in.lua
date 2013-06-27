#!/usr/bin/env lua
-- -*- lua -*-

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
   dbg.start("settarg")

   ------------------------------------------
   -- Build shell object
   local shell = BaseShell.build(masterTbl.shell)

   BuildTarget.exec(shell, FindProjectData())
   ModifyPath()
   Output(shell)
   dbg.fini()
end

main()
