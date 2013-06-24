#!/usr/bin/env lua
-- -*- lua -*-

if (not pcall(require,"strict")) then
   os.exit(0)
end

local master = {}

function masterTbl()
   return master
end

function splitFileName(path)
   local d, f
   local i,j = path:find(".*/")
   if (i == nil) then
      d = './'
      f = path
   else
      d = path:sub(1,j)
      f = path:sub(j+1,-1)
   end
   return d, f
end

local execDir = splitFileName(arg[0])
-- remove current directory from search path
package.path = package.path:gsub("^%./%?.lua;","")
package.path=execDir .. '/?.lua;' .. package.path

BaseShell      = require("BaseShell")

local Dbg            = require("Dbg")
local CmdLineOptions = require("CmdLineOptions")
local BuildTarget    = require("BuildTarget")
require("ModifyPath")
require("Output")
require("FindProjectData")

function main()
   local dbg       = Dbg:dbg()
   local masterTbl = masterTbl()
   masterTbl.execDir = execDir

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
