#!@path_to_lua@/lua
-- -*- lua -*-

--------------------------------------------------------------------------
-- Fixme
-- @script computeHashSum

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

------------------------------------------------------------------------
-- Use command name to add the command directory to the package.path
------------------------------------------------------------------------
local sys_lua_path = "@sys_lua_path@"
if (sys_lua_path:sub(1,1) == "@") then
   sys_lua_path = package.path
end

local sys_lua_cpath = "@sys_lua_cpath@"
if (sys_lua_cpath:sub(1,1) == "@") then
   sys_lua_cpath = package.cpath
end

package.path   = sys_lua_path
package.cpath  = sys_lua_cpath

local arg_0    = arg[0]
_G._DEBUG      = false
local posix    = require("posix")
local readlink = posix.readlink
local stat     = posix.stat

local st       = stat(arg_0)
while (st.type == "link") do
   local lnk = readlink(arg_0)
   if (arg_0:find("/") and (lnk:find("^/") == nil)) then
      local dir = arg_0:gsub("/[^/]*$","")
      lnk       = dir .. "/" .. lnk
   end
   arg_0 = lnk
   st    = stat(arg_0)
end

local ia,ja = arg_0:find(".*/")
local LuaCommandName_dir = "./"
if (ia) then
   LuaCommandName_dir = arg_0:sub(1,ja)
end

package.path  = LuaCommandName_dir .. "../tools/?.lua;"      ..
                LuaCommandName_dir .. "../tools/?/init.lua;" ..
                LuaCommandName_dir .. "../shells/?.lua;"     ..
                LuaCommandName_dir .. "?.lua;"               ..
                sys_lua_path
package.cpath = LuaCommandName_dir .. "../lib/?.so;"..
                sys_lua_cpath

function cmdDir()
   return LuaCommandName_dir
end

Version = "1.0"
require("strict")
require("myGlobals")
require("utils")
require("fileOps")
require("capture")
MasterControl = require("MasterControl")
MCP           = false
mcp           = false
require("modfuncs")
require("cmdfuncs")
require("parseVersion")

BaseShell         = require("BaseShell")
Master            = require("Master")

local FrameStk    = require("FrameStk")
local MT          = require("MT")
local MName       = require("MName")
local Optiks      = require("Optiks")
local cosmic      = require("Cosmic"):singleton()
local concatTbl   = table.concat
local dbg         = require("Dbg"):dbg()
local fh          = nil
local getenv      = os.getenv
local s_masterTbl = {}

function masterTbl()
   return s_masterTbl
end


function main()
   __removeEnvMT()  -- Wipe the ModuleTable in the environment so that it doesn't pollute isloaded()!
   local master    = Master:singleton(false)
   local frameStk  = FrameStk:singleton()
   local shellNm   = "bash"
   _G.Shell        = BaseShell:build(shellNm)
   local tmpfn     = os.tmpname()
   fh              = io.open(tmpfn,"w")
   local i         = 1
   local masterTbl = masterTbl()

   options()

   if (masterTbl.debug) then
      dbg:activateDebug(1, tonumber(masterTbl.indentLevel))
   end
   dbg.start{"computeHashSum()"}

   setenv_lmod_version()    -- push Lmod version info into env for modulefiles.

   require("StandardPackage")
   local lmodPath = os.getenv("LMOD_PACKAGE_PATH") or ""
   for path in lmodPath:split(":") do
      path = path .. "/"
      path = path:gsub("//+","/")
      package.path  = path .. "?.lua;"      ..
         path .. "?/init.lua;" ..
         package.path

      package.cpath = path .. "../lib/?.so;"..
         package.cpath
   end

   dbg.print{"lmodPath: \"", lmodPath,"\"\n"}
   require("SitePackage")

   MCP           = MasterControl.build("computeHash","load")
   mcp           = MasterControl.build("computeHash","load")

   local fn     = masterTbl.pargs[1]
   local entryT = {sn = masterTbl.sn, userName = masterTbl.userName, fn = fn,
                   version = extractVersion(masterTbl.fullName, masterTbl.sn)}
   local mname = MName:new("entryT", entryT)
   dbg.print{"fullName: ",mname:fullName(),", userName: ",mname:userName()," masterTbl.fullName: ", masterTbl.fullName,"\n"}

   frameStk:push(mname)
   loadModuleFile{file=fn, shell=shellNm, reportErr=true}
   frameStk:pop()
   local s = concatTbl(ShowResultsA,"")
   dbg.textA{name="Text to Hash for: "..masterTbl.fullName, a=ShowResultsA}

   if (masterTbl.verbose) then
      io.stderr:write(s)
   end
   fh:write(s)
   fh:close()
   local HashSum = cosmic:value("LMOD_HASHSUM_PATH")

   if (HashSum == nil) then
      LmodSystemError{msg="e_Failed_Hashsum"}
   end

   local result = capture(HashSum .. " " .. tmpfn)
   os.remove(tmpfn)
   ia = result:find(" ")
   dbg.print{"hash value: ",result:sub(1,ia-1),"\n"}
   print (result:sub(1,ia-1))
   dbg.fini("computeHashSum")
end

function options()
   local masterTbl = masterTbl()
   local usage         = "Usage: computeHashSum [options] file"
   local cmdlineParser = Optiks:new{usage=usage, version=Version}

   cmdlineParser:add_option{
      name   = {'-v','--verbose'},
      dest   = 'verbosityLevel',
      action = 'count',
   }
   cmdlineParser:add_option{
      name   = {'--fullName'},
      dest   = 'fullName',
      action = 'store',
      help   = "Full name of the module file"
   }


   cmdlineParser:add_option{
      name   = {'--userName'},
      dest   = 'userName',
      action = 'store',
      help   = "User name of the module file"
   }

   cmdlineParser:add_option{
      name   = {'--MODULEPATH'},
      dest   = 'mpath',
      action = 'store',
      help   = "The current MODULEPATH"
   }

   cmdlineParser:add_option{
      name   = {'--sn'},
      dest   = 'sn',
      action = 'store',
      help   = "shortname of the module file"
   }

   cmdlineParser:add_option{
      name   = {'-D','-d','--debug'},
      dest   = 'debug',
      action = 'store_true',
      default = false,
      help    = "debug flag"
   }
   cmdlineParser:add_option{
      name   = {'--indentLevel'},
      dest   = 'indentLevel',
      action = 'store',
      default = "0",
      help    = "indent level for Dbg"
   }



   local optionTbl, pargs = cmdlineParser:parse(arg)

   for v in pairs(optionTbl) do
      masterTbl[v] = optionTbl[v]
   end
   masterTbl.pargs = pargs

end

main()
