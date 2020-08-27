#!@path_to_lua@/lua
-- -*- lua -*-

--------------------------------------------------------------------------
-- Use command name to add the command directory to the package.path
-- @script spider

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

_G._DEBUG      = false
local arg_0    = arg[0]
local posix    = require("posix")
local readlink = posix.readlink
local stat     = posix.stat
local access   = posix.access
local stderr   = io.stderr

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

require("strict")

require("myGlobals")
require("utils")
require("colorize")
require("pairsByKeys")
require("fileOps")
require("modfuncs")
require("deepcopy")
require("parseVersion")
MasterControl       = require("MasterControl")
Cache               = require("Cache")
MRC                 = require("MRC")
Master              = require("Master")
ModuleA             = require("ModuleA")
BaseShell           = require("BaseShell")
Shell               = false
local Optiks        = require("Optiks")
local concatTbl     = table.concat
local cosmic        = require("Cosmic"):singleton()
local dbg           = require("Dbg"):dbg()
local i18n          = require("i18n")
local lfs           = require("lfs")
local sort          = table.sort
local pack          = (_VERSION == "Lua 5.1") and argsPack or table.pack -- luacheck: compat

function walk_moduleA(moduleA, errorT)
   dbg.start{"walk_moduleA(moduleA)"}
   local show_hidden = masterTbl().show_hidden
   local mrc         = MRC:singleton()

   local function l_walk_moduleA_helper(mpath, sn, v)
      dbg.print{"in l_walk_moduleA_helper(",mpath,",",sn,")\n"}
      if (next(v.defaultA) ~= nil and #v.defaultA > 1) then
         too_many_defaultA_entries(mpath, sn, v.defaultA, errorT.defaultA)
      end

      if (next(v.fileT) ~= nil) then
         for fullName, vv in pairs(v.fileT) do
            if (show_hidden or mrc:isVisible({fullName=fullName,sn=sn,fn=vv.fn})) then
               check_syntax(vv.fn, errorT.syntaxA)
            end
         end
      end
      if (next(v.dirT) ~= nil) then
         for name, vv in pairs(v.dirT) do
            l_walk_moduleA_helper(mpath, sn, vv)
         end
      end
   end

   dbg.print{"#moduleA: ",#moduleA,"\n"}

   for i = 1, #moduleA do
      local T     = moduleA[i].T
      local mpath = moduleA[i].mpath
      for sn, v in pairs(T) do
         l_walk_moduleA_helper(mpath, sn, v)
      end
   end

   dbg.fini("walk_moduleA")
end

function too_many_defaultA_entries(mpath, sn, defaultA, errorA)
   errorA[#errorA + 1]   = pathJoin(mpath,sn)
end

local my_errorFn
function check_syntax(fn, errorA)
   my_errorFn = nil
   loadModuleFile{file=fn, help=true, shell="bash", reportErr=true, mList = ""}
   if (my_errorFn) then
      errorA[#errorA + 1]   = my_errorFn
   end
end

function check_syntax_error_handler(self, t)
   my_errorFn = t.fn
end

local function Error(...)
   local argA   = pack(...)
   for i = 1,argA.n do
      io.stderr:write(argA[i])
   end
end

local function prt(...)
   io.stderr:write(...)
end

function options()
   local masterTbl = masterTbl()
   local usage         = "Usage: spider [options] moduledir ..."
   local cmdlineParser = Optiks:new{usage   = usage,
                                    version = "1.0",
                                    error   = Error,
                                    prt     = prt,
   }

   cmdlineParser:add_option{
      name   = {'-D'},
      dest   = 'debug',
      action = 'count',
      help   = "Program tracing written to stderr",
   }

   cmdlineParser:add_option{
      name   = {"-T", "--trace" },
      dest   = "trace",
      action = "store_true",
      help   = "Tracing",
   }
   local optionTbl, pargs = cmdlineParser:parse(arg)

   if (optionTbl.trace) then
      cosmic:assign("LMOD_TRACING", "yes")
   end

   for v in pairs(optionTbl) do
      masterTbl[v] = optionTbl[v]
   end
   masterTbl.pargs = pargs
end
   
function main()

   options()
   local masterTbl  = masterTbl()
   local pargs      = masterTbl.pargs
   local mpathA     = {}
   local errorT     = { defaultA = {}, syntaxA = {} }

   Shell            = BaseShell:build("bash")
   build_i18n_messages()

   local master     = Master:singleton(false)
   for i = 1,#pargs do
      local v = pargs[i]
      for path in v:split(":") do
         local my_path     = path_regularize(path)
         if (my_path:sub(1,1) ~= "/") then
            stderr:write("Each path in MODULEPATH must be absolute: ",path,"\n")
            os.exit(1)
         end
         mpathA[#mpathA+1] = my_path
      end
   end
   local mpath = concatTbl(mpathA,":")
   posix.setenv("MODULEPATH",mpath,true)


   if (masterTbl.debug > 0 or masterTbl.dbglvl) then
      local dbgLevel = math.max(masterTbl.debug, masterTbl.dbglvl or 1)
      dbg:activateDebug(dbgLevel)
   end

   dbg.start{"module_tree_check main()"}
   MCP = MasterControl.build("checkSyntax")
   mcp = MasterControl.build("checkSyntax")
   mcp.error = check_syntax_error_handler
   MCP.error = check_syntax_error_handler
   Shell:setActive(false)
   setSyntaxMode(true)
   
   local moduleA = ModuleA:singleton{reset=true}
   local mA      = moduleA:moduleA()

   walk_moduleA(mA, errorT)

   local ierr = 0
   if (next(errorT.defaultA) ~= nil) then
      io.stderr:write("\nThe following directories have more than one marked default file:\n",
                        "-----------------------------------------------------------------\n")
      for i in 1,#errorT.defaultA do
         ierr = ierr + 1
         io.stderr:write("  ",errorT.defaultA[i],"\n")
      end
      io.stderr:write("\n")
   end

   if (next(errorT.syntaxA) ~= nil) then
      io.stderr:write("\nThe following modulefile(s) have a syntax error:\n",
                        "-----------------------------------------------\n")
      for i in 1,#errorT.syntaxA do
         ierr = ierr + 1
         io.stderr:write("  ",errorT.syntaxA[i],"\n")
      end
      io.stderr:write("\n")
   end
      
   dbg.fini("module_tree_check main")
   if (ierr > 0) then
      print(colorize("red","There were ".. tostring(ierr) .. "possible errors found!"))
      os.exit(1)
   end
   print("No errors found")
end

main()
