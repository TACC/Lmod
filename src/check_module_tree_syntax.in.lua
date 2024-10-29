#!@path_to_lua@
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
local access   = posix.access
local getuid   = posix.getuid
local readlink = posix.readlink
local stat     = posix.stat
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
require("TermWidth")

_G.MainControl      = require("MainControl")
Shell               = false

local BaseShell     = require("BaseShell")
local Cache         = require("Cache")
local FrameStk      = require("FrameStk")
local MRC           = require("MRC")
local MName         = require("MName")
local MT            = require("MT")
local Hub           = require("Hub")
local ModuleA       = require("ModuleA")
local Optiks        = require("Optiks")
local Spider        = require("Spider")
local concatTbl     = table.concat
local cosmic        = require("Cosmic"):singleton()
local dbg           = require("Dbg"):dbg()
local hook          = require("Hook")
local i18n          = require("i18n")
local lfs           = require("lfs")
local sort          = table.sort
local pack          = (_VERSION == "Lua 5.1") and argsPack or table.pack -- luacheck: compat

local function l_nothing()
end

function walk_spiderT(spiderT, mt, mList, errorT)
   dbg.start{"walk_spiderT(spiderT, mList, errorT)"}
   local mrc         = MRC:singleton()

   local function l_walk_moduleA_helper(mpath, sn, v)
      dbg.print{"in l_walk_moduleA_helper(",mpath,",",sn,")\n"}
      if (next(v.defaultA) ~= nil and #v.defaultA > 1) then
         too_many_defaultA_entries(mpath, sn, v.defaultA, errorT.defaultA)
      end

      if (next(v.fileT) ~= nil) then
         for fullName, vv in pairs(v.fileT) do
            local resultT = mrc:isVisible{fullName=fullName,sn=sn,fn=vv.fn, mpath = vv.mpath}
            if (resultT.isVisible) then
               check_syntax(mpath, mt, mList, sn, vv.fn, fullName, errorT.syntaxA)
            end
         end
      end
      if (next(v.dirT) ~= nil) then
         for name, vv in pairs(v.dirT) do
            l_walk_moduleA_helper(mpath, name, vv)
         end
      end
   end

   for mpath, vv in pairs(spiderT) do
      if (mpath ~= "version") then
         for sn, v  in pairs(vv) do
            l_walk_moduleA_helper(mpath, sn, v)
         end
      end
   end

   dbg.fini("walk_spiderT")
end

function too_many_defaultA_entries(mpath, sn, defaultA, errorA)
   errorA[#errorA + 1]   = pathJoin(mpath,sn)
end

local my_errorMsg = nil
function check_syntax(mpath, mt, mList, sn, fn, fullName, errorA)
   dbg.start{"check_syntax(mpath=\"",mpath,"\", mList=\"",mList,"\", sn=\"",sn,"\", fn= \"",fn,"\", fullName=\"",fullName,"\"...)"}
   local shell    = _G.Shell
   local tracing  = cosmic:value("LMOD_TRACING")
   local frameStk = FrameStk:singleton()
   

   local function l_loadMe(entryT)
      dbg.start{"loadMe(entryT, moduleStack, iStack, myModuleT)"}
      local shellNm       = "bash"
      local mname = MName:new("entryT", entryT)
      frameStk:push(mname)
      mt:add(mname, "pending")
      if (tracing == "yes") then
         tracing_msg{"check_syntax Loading: ", fullName, " (fn: ", fn or "nil",")"}
      end
      loadModuleFile{file=entryT.fn, shell=shellNm, help=true, reportErr=true, mList = mList}
      mt = frameStk:mt()
      mt:setStatus(sn, "active")
      frameStk:pop()
      dbg.fini("loadMe")
   end
   local entryT      = { fn = fn, sn = sn, userName = fullName, fullName = fullName,
                         version = extractVersion(fullName, sn)}

   my_errorMsg = nil
   l_loadMe(entryT)
   if (my_errorMsg) then
      errorA[#errorA + 1]   = my_errorMsg
   end
   dbg.fini("check_syntax")
end

function check_syntax_error_handler(self, ...)
   dbg.start{"check_syntax_error_handler(self, ...)"}
   local twidth = TermWidth()
   local argA   = pack(...)
   local kind   = "lmoderror"
   local label  = "Error:"
   local errMsg = ""
   if (argA.n == 1 and type(argA[1]) == "table") then
      local t   = argA[1]
      local key = t.msg
      if (key == "e_Unable_2_Load")    then key = "e_Unable_2_Load_short"    end
      if (key == "e_Args_Not_Strings") then key = "e_Args_Not_Strings_short" end
      local msg = i18n(key, t) or "Unknown Error Message"
      msg       = hook.apply("errWarnMsgHook", kind, key, msg, t) or msg
      errMsg    = buildMsg(twidth, pack(label, msg))
   else
      errMsg  = buildMsg(twidth, pack(label, ...))
   end

   my_errorMsg = "ModuleName: "..myModuleFullName()..", Fn: "..myFileName() .. " " .. errMsg
   dbg.print{"Setting my_errorMsg to : ",my_errorMsg,"\n"}
   dbg.fini("check_syntax_error_handler")
end

local function l_OptError(...)
   local argA   = pack(...)
   for i = 1,argA.n do
      io.stderr:write(argA[i])
   end
end

local function l_prt(...)
   io.stderr:write(...)
end

function options()
   local optionTbl     = optionTbl()
   local usage         = "Usage: check_module_tree_syntax [options] moduledir ..."
   local cmdlineParser = Optiks:new{usage   = usage,
                                    version = "1.0",
                                    error   = l_OptError,
                                    prt     = l_prt,
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
   local optTbl, pargs = cmdlineParser:parse(arg)

   if (optionTbl.trace) then
      cosmic:assign("LMOD_TRACING", "yes")
   end

   for v in pairs(optTbl) do
      optionTbl[v] = optTbl[v]
   end
   optionTbl.pargs = pargs
   Use_Preload     = optionTbl.preload
end
   
function main()

   options()
   local optionTbl  = optionTbl()
   local pargs      = optionTbl.pargs
   local mpathA     = {}
   local errorT     = { defaultA = {}, syntaxA = {} }

   Shell            = BaseShell:build("bash")

   ------------------------------------------------------------------
   -- initialize lmod with SitePackage and /etc/lmod/lmod_config.lua
   initialize_lmod()

   local mrc        = MRC:singleton()
   mrc:set_display_mode("spider")

   dbg.set_prefix(colorize("red","Lmod"))

   local hub     = Hub:singleton(false)
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
   setenv_lmod_version() -- push Lmod version info into env for modulefiles.


   if (optionTbl.debug > 0 or optionTbl.dbglvl) then
      local dbgLevel = math.max(optionTbl.debug, optionTbl.dbglvl or 1)
      dbg:activateDebug(dbgLevel)
   end

   dbg.start{"module_tree_check main()"}
   _G.mcp = MainControl.build("spider")
   _G.MCP = MainControl.build("spider")
   local remove_MRC_home         = getuid() < 501
   local cache                   = Cache:singleton{dontWrite = true, quiet = true, buildCache = true,
                                                   buildFresh = true, noMRC=true}
   local spider                  = Spider:new()
   local spiderT, dbT,
         mpathMapT, providedByT  = cache:build()

   _G.MCP = MainControl.build("checkSyntax")
   _G.mcp = MainControl.build("checkSyntax")
   mcp.error  = check_syntax_error_handler
   MCP.error  = check_syntax_error_handler
   mcp.report = check_syntax_error_handler
   MCP.report = check_syntax_error_handler
   Shell:setActive(false)
   setSyntaxMode(true)
   
   local mList           = ""
   local tracing         = cosmic:value("LMOD_TRACING")
   local mt              = deepcopy(MT:singleton())
   local maxdepthT       = mt:maxDepthT()
   local moduleDirT      = {}
   optionTbl.moduleStack = {}
   optionTbl.dirStk      = {}
   optionTbl.mpathMapT   = {}
   local exit            = os.exit

   sandbox_set_os_exit(l_nothing)

   if (Use_Preload) then
      local a = {}
      mList   = getenv("LOADEDMODULES") or ""
      for mod in mList:split(":") do
         local i = mod:find("/[^/]*$")
         if (i) then
            a[#a+1] = mod:sub(1,i-1)
         end
         a[#a+1] = mod
      end
      mList = concatTbl(a,":")
   end

   if (tracing == "no" and not dbg.active()) then
      turn_off_stdio()
   end
   walk_spiderT(spiderT, mt, mList, errorT)

   sandbox_set_os_exit(exit)
   if (tracing == "no" and not dbg.active()) then
      turn_on_stdio()
   end

   local ierr = 0
   if (next(errorT.defaultA) ~= nil) then
      io.stderr:write("\nThe following directories have more than one marked default file:\n",
                        "-----------------------------------------------------------------\n")
      table.sort(errorT.defaultA)

      for i = 1,#errorT.defaultA do
         ierr = ierr + 1
         io.stderr:write("  ",errorT.defaultA[i],"\n")
      end
      io.stderr:write("\n")
   end

   if (next(errorT.syntaxA) ~= nil) then
      io.stderr:write("\nThe following modulefile(s) have syntax errors:\n",
                        "-----------------------------------------------\n")
      table.sort(errorT.syntaxA)
      for i = 1,#errorT.syntaxA do
         ierr = ierr + 1
         io.stderr:write("  ",errorT.syntaxA[i],"\n")
      end
      io.stderr:write("\n")
   end
      
   dbg.fini("module_tree_check main")
   if (ierr > 0) then
      print("\n",colorize("red","There were ".. tostring(ierr) .. " possible errors found!"),"\n")
      os.exit(1)
   end
   print("\nNo errors found\n")
end

main()
