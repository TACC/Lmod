#!@path_to_lua@
-- -*- lua -*-
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
--  Copyright (C) 2008-2018 Robert McLay
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
local ia,ja = LuaCommandName:find(".*/")
local LuaCommandName_dir = "./"
if (ia) then
   LuaCommandName_dir = LuaCommandName:sub(1,ja)
end

local sys_lua_path = "@sys_lua_path@"
if (sys_lua_path:sub(1,1) == "@") then
   sys_lua_path = package.path
end
local sys_lua_cpath = "@sys_lua_cpath@"
if (sys_lua_cpath:sub(1,1) == "@") then
   sys_lua_cpath = package.cpath
end

package.path  = LuaCommandName_dir .. "../tools/?.lua;"       ..
                LuaCommandName_dir .. "../tools/?/init.lua;"  ..
                LuaCommandName_dir .. "?.lua;"                ..
                LuaCommandName_dir .. "?/init.lua;"           ..
                sys_lua_path
package.cpath = LuaCommandName_dir .. "../lib/?.so;"..
                sys_lua_cpath

_G._DEBUG            = false
local posix          = require("posix")

function cmdDir()
   return LuaCommandName_dir
end

if (not pcall(require,"strict")) then
   os.exit(0)
end

local s_optionTbl = {}

function optionTbl()
   return s_optionTbl
end

BaseShell            = require("BaseShell")

local dbg            = require("Dbg"):dbg()
local CmdLineOptions = require("CmdLineOptions")
local BuildTarget    = require("BuildTarget")
local STT            = require("STT")
local cosmic         = require("Cosmic"):singleton()
local getenv         = os.getenv

require("ModifyPath")
require("Output")
require("serializeTbl")

------------------------------------------------------------------------
-- LMOD_LD_LIBRARY_PATH:   LD_LIBRARY_PATH found at configure
------------------------------------------------------------------------

local ld_lib_path = "@sys_ld_lib_path@"
if (ld_lib_path:sub(1,1) == "@") then
   ld_lib_path = getenv("LD_LIBRARY_PATH")
end
if (ld_lib_path == "") then
   ld_lib_path = false
end

cosmic:init{name    = "LMOD_LD_LIBRARY_PATH",
            default = false,
            assignV = ld_lib_path}

------------------------------------------------------------------------
-- LMOD_LD_PRELOAD:   LD_PRELOAD found at configure
------------------------------------------------------------------------

local ld_preload = "@sys_ld_preload@"
if (ld_preload:sub(1,1) == "@") then
   ld_preload = getenv("LD_PRELOAD")
end
if (ld_preload == "") then
   ld_preload = nil
end

cosmic:init{name    = "LMOD_LD_PRELOAD",
            default = false,
            assignV = ld_preload}

function main()
   local optionTbl   = optionTbl()

   optionTbl.execDir = cmdDir()

   CmdLineOptions:options()
   if (optionTbl.debug) then
      dbg:activateDebug(1)
   end
   dbg.start{"settarg()"}

   -- Error out if there are spaces in command line arguments
   for i = 1,#optionTbl.pargs do
      local s = optionTbl.pargs[i]
      if (s:find("%s")) then
         io.stderr:write("Error: Argument #",i," has spaces in it: \"",s,"\"\n")
         os.exit(1)
      end
   end


   if (optionTbl.cmdHelp) then
      io.stderr:write("Lmod settarg ",Version.name(),"\n")
      io.stderr:write(optionTbl.cmdHelpMsg,"\n")
      dbg.fini("settarg")
      return
   end

   if (optionTbl.version) then
      io.stderr:write("Lmod settarg ",Version.name(),"\n")
      os.exit(0)
   end

   ------------------------------------------
   -- Build shell object
   local shell = BaseShell.build(optionTbl.shell)

   BuildTarget.exec(shell)

   if (optionTbl.report) then
      io.stderr:write(serializeTbl{name="SettargConfigFnA",   indent=true, value=optionTbl.SttgConfFnA},"\n")
      io.stderr:write(serializeTbl{name="BuildScenarioTbl",   indent=true, value=optionTbl.BuildScenarioTbl},"\n")
      io.stderr:write(serializeTbl{name="HostnameTbl",        indent=true, value=optionTbl.HostTbl},         "\n")
      io.stderr:write(serializeTbl{name="ModuleTbl",          indent=true, value=optionTbl.ModuleTbl},       "\n")
      io.stderr:write(serializeTbl{name="TargetList",         indent=true, value=optionTbl.targetList},      "\n")
      io.stderr:write(serializeTbl{name="SettargDirTemplate", indent=true, value=optionTbl.SettargDirTmpl},  "\n")
      io.stderr:write(serializeTbl{name="TitleTbl",           indent=true, value=optionTbl.TitleTbl},        "\n")
      io.stderr:write("TargPathLoc = \"",optionTbl.TargPathLoc,"\"\n")
      dbg.fini("settarg")
      return
   end

   if (optionTbl.stt) then
      local stt = STT:stt()
      local s   = stt:serializeTbl("pretty")
      io.stderr:write(s,"\n")
   end

   ModifyPath()
   Output(shell)
   dbg.fini("settarg")
end

main()
