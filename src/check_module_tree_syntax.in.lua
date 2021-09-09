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
require("TermWidth")

_G.MasterControl    = require("MasterControl")
Shell               = false

local BaseShell     = require("BaseShell")
local Cache         = require("Cache")
local FrameStk      = require("FrameStk")
local MRC           = require("MRC")
local MName         = require("MName")
local MT            = require("MT")
local Master        = require("Master")
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

local function nothing()
end

function walk_spiderT(spiderT, mt, mList, errorT)
   dbg.start{"walk_spiderT(spiderT, mList, errorT)"}
   local show_hidden = masterTbl().show_hidden
   local mrc         = MRC:singleton()

   local function l_walk_moduleA_helper(mpath, sn, v)
      dbg.print{"in l_walk_moduleA_helper(",mpath,",",sn,")\n"}
      if (next(v.defaultA) ~= nil and #v.defaultA > 1) then
         too_many_defaultA_entries(mpath, sn, v.defaultA, errorT.defaultA)
      end

      if (next(v.fileT) ~= nil) then
         for fullName, vv in pairs(v.fileT) do
            if (show_hidden or mrc:isVisible{fullName=fullName,sn=sn,fn=vv.fn}) then
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
   

   local function loadMe(entryT)
      dbg.start{"loadMe(entryT, moduleStack, iStack, myModuleT)"}
      local shellNm       = "bash"
      local mname = MName:new("entryT", entryT)
      frameStk:push(mname)
      mt:add(mname, "pending")
      if (tracing == "yes") then
         local b          = {}
         b[#b + 1]        = "check_syntax Loading: "
         b[#b + 1]        = fullName
         b[#b + 1]        = " (fn: "
         b[#b + 1]        = fn or "nil"
         b[#b + 1]        = ")\n"
         shell:echo(concatTbl(b,""))
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
   loadMe(entryT)
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
      errMsg    = buildMsg(twidth, label, msg)
   else
      errMsg  = buildMsg(twidth, label, ...)
   end

   --if (t and t.msg) then
   --   dbg.print{"t.msg: ",t.msg,"\n"}
   --   if (myModuleFullName() == "mkl/mkl") then
   --      FukMe()
   --   end
   --end
   my_errorMsg = "ModuleName: "..myModuleFullName()..", Fn: "..myFileName() .. " " .. errMsg
   dbg.print{"Setting my_errorMsg to : ",my_errorMsg,"\n"}
   dbg.fini("check_syntax_error_handler")
end

local function OptError(...)
   local argA   = pack(...)
   for i = 1,argA.n do
      io.stderr:write(argA[i])
   end
end

local function prt(...)
   io.stderr:write(...)
end

function options()
   local masterTbl     = masterTbl()
   local usage         = "Usage: spider [options] moduledir ..."
   local cmdlineParser = Optiks:new{usage   = usage,
                                    version = "1.0",
                                    error   = OptError,
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
   cmdlineParser:add_option{
      name    = {'--preload'},
      dest    = 'preload',
      action  = 'store_true',
      default = false,
      help    = "Use preloaded modules to build reverseMapT"
   }
   local optionTbl, pargs = cmdlineParser:parse(arg)

   if (optionTbl.trace) then
      cosmic:assign("LMOD_TRACING", "yes")
   end

   for v in pairs(optionTbl) do
      masterTbl[v] = optionTbl[v]
   end
   masterTbl.pargs = pargs
   Use_Preload     = masterTbl.preload
end
   
function main()

   options()
   local masterTbl  = masterTbl()
   local pargs      = masterTbl.pargs
   local mpathA     = {}
   local errorT     = { defaultA = {}, syntaxA = {} }

   Shell            = BaseShell:build("bash")
   build_i18n_messages()
   dbg.set_prefix(colorize("red","Lmod"))

   ------------------------------------------------------------------------
   --  The StandardPackage is where Lmod registers hooks.  Sites may
   --  override the hook functions in SitePackage.
   ------------------------------------------------------------------------
   dbg.print{"Loading StandardPackage\n"}
   require("StandardPackage")

   ------------------------------------------------------------------------
   -- Load a SitePackage Module.
   ------------------------------------------------------------------------

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

   dbg.print{"lmodPath:", lmodPath,"\n"}
   require("SitePackage")

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
   setenv_lmod_version() -- push Lmod version info into env for modulefiles.


   if (masterTbl.debug > 0 or masterTbl.dbglvl) then
      local dbgLevel = math.max(masterTbl.debug, masterTbl.dbglvl or 1)
      dbg:activateDebug(dbgLevel)
   end

   dbg.start{"module_tree_check main()"}
   _G.mcp = MasterControl.build("spider")
   _G.MCP = MasterControl.build("spider")
   local remove_MRC_home         = true
   local mrc                     = MRC:singleton(getModuleRCT(remove_MRC_home))
   local cache                   = Cache:singleton{dontWrite = true, quiet = true, buildCache = true,
                                                   buildFresh = true, noMRC=true}
   local spider                  = Spider:new()
   local spiderT, dbT,
         mpathMapT, providedByT  = cache:build()

   _G.MCP = MasterControl.build("checkSyntax")
   _G.mcp = MasterControl.build("checkSyntax")
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
   masterTbl.moduleStack = {}
   masterTbl.dirStk      = {}
   masterTbl.mpathMapT   = {}
   local exit            = os.exit

   sandbox_set_os_exit(nothing)

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
