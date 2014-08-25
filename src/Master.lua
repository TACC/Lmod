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
-- Master: This class is responsible for actively managing the actions of
--         Lmod.  It is responsible finding and loading or unloading a
--         modulefile.  It is also responsible for reloading modules when
--         the module path changes.  Finally it is responsible for finding
--         modulefiles for "avail"

require("strict")
local concatTbl          = table.concat
local getenv             = os.getenv
local sort               = table.sort
local systemG            = _G
local removeEntry        = table.remove

require("TermWidth")
require("fileOps")
require("string_utils")
require("fillWords")
require("loadModuleFile")
require("utils")
require("caseIndependent")

local BeautifulTbl = require('BeautifulTbl')
local ColumnTable  = require('ColumnTable')
local Default      = '(D)'
local M            = {}
local MName        = require("MName")
local ModuleStack  = require("ModuleStack")
local Optiks       = require("Optiks")
local Spider       = require("Spider")
local Var          = require("Var")
local dbg          = require("Dbg"):dbg()
local hook         = require("Hook")
local lfs          = require("lfs")
local posix        = require("posix")
local pack         = (_VERSION == "Lua 5.1") and argsPack   or table.pack
local load         = (_VERSION == "Lua 5.1") and loadstring or load

------------------------------------------------------------------------
-- Master:new() a private ctor that is used to construct a singleton.

s_master = {}

local function new(self,safe)
   local o = {}

   setmetatable(o,self)
   self.__index = self
   o.safe       = safe
   return o
end

local searchTbl     = {'.lua', '', '/default', '/.version'}
local numSearch     = 4
local numSrchLatest = 2

--------------------------------------------------------------------------
-- followDefault(): This local function is used to find a default file
--                  that maybe in symbolic link chain. This returns
--                  the absolute path.

local function followDefault(path)
   if (path == nil) then return nil end
   dbg.start{"followDefault(path=\"",path,"\")"}
   local attr = lfs.symlinkattributes(path)
   local result = path
   if (attr == nil) then
      result = nil
   elseif (attr.mode == "link") then
      local rl = posix.readlink(path)
      local a  = {}
      local n  = 0
      for s in path:split("/") do
         n = n + 1
         a[n] = s or ""
      end

      a[n] = ""
      local i  = n
      for s in rl:split("/") do
         if (s == "..") then
            i = i - 1
         else
            a[i] = s
            i    = i + 1
         end
      end
      result = concatTbl(a,"/")
   end
   dbg.print{"result: ",result,"\n"}
   dbg.fini("followDefault")
   return result
end

--------------------------------------------------------------------------
-- find_inherit_module(): This local function is very similar to
--                        [[find_module_file]].  The idea is that
--                        an advanced user wants to inherit a compiler
--                        module and/or an mpi stack module.  They want
--                        to inherit the system compiler but add to the
--                        MODULEPATH.  This routine does a similar search
--                        for the module.  It searches for the original
--                        module in pathA and then searches again.  Only
--                        after finding the same named module does it
--                        return.


local function find_inherit_module(fullModuleName, oldFn)
   dbg.start{"find_inherit_module(",fullModuleName,",",oldFn, ")"}

   local t        = {fn = nil, modFullName = nil, modName = nil, default = 0}
   local mt       = systemG.MT:mt()
   local mname    = MName:new("load", fullModuleName)
   local sn       = mname:sn()
   local localDir = true


   local pathA = mt:locationTbl(sn)

   if (pathA == nil or #pathA == 0) then
      dbg.fini("find_inherit_module")
      return t
   end
   local fn, result, rstripped
   local foundOld = false
   local oldFn_stripped = oldFn:gsub("%.lua$","")

   for ii, vv in ipairs(pathA) do
      local mpath  = vv.mpath
      fn           = pathJoin(vv.file, mname:version())
      result       = nil
      dbg.print{"ii: ",ii," mpath: ",mpath," vv.file: ",vv.file," fn: ",fn,"\n"}
      for i = 1, #searchTbl do
         local f        = fn .. searchTbl[i]
         local attr     = lfs.attributes(f)
         local readable = posix.access(f,"r")
         dbg.print{'(1) fn: ',fn," f: ",f,"\n"}
         if (readable and attr and attr.mode == "file") then
            result = f
            rstripped = result:gsub("%.lua$","")
            break
         end
      end

      dbg.print{"(2) result: ", result, " foundOld: ", foundOld,"\n"}
      if (foundOld) then
         break
      end


      if (result and rstripped == oldFn_stripped) then
         foundOld = true
         result = nil
      end
      dbg.print{"(3) result: ", result, " foundOld: ", foundOld,"\n"}
   end

   dbg.print{"fullModuleName: ",fullModuleName, " fn: ", result,"\n"}
   t.modFullName = fullModuleName
   t.fn          = result
   dbg.fini("find_inherit_module")
   return t
end

--------------------------------------------------------------------------
-- registerLoaded(): This function marks a module name as loaded and saves
--                   it to LOADEDMODULES and _LMFILES_.   This is only for
--                   compatibility with TCL/C module.
local function registerLoaded(full, fn)
   local modList  = "LOADEDMODULES"
   local modFn    = "_LMFILES_"
   local nodups   = true
   local priority = 0
   local sep      = ":"
   if (varTbl[modList] == nil) then
      varTbl[modList] = Var:new(modList, nil, sep)
   end

   varTbl[modList]:append(full, nodups, priority)


   if (varTbl[modFn] == nil) then
      varTbl[modFn] = Var:new(modFn, nil, sep)
   end

   varTbl[modFn]:append(fn, nodups, priority)
end

--------------------------------------------------------------------------
-- registerUnloaded(): This function marks a module name as unloaded and 
--                     saves it to LOADEDMODULES and _LMFILES_.   This is
--                     only for compatibility with TCL/C module.
local function registerUnloaded(full, fn)
   local modList  = "LOADEDMODULES"
   local modFn    = "_LMFILES_"
   local where    = "all"
   local sep      = ":"
   local priority = 0
   if (varTbl[modList] == nil) then
      varTbl[modList] = Var:new(modList, nil, sep)
   end

   varTbl[modList]:remove(full, where, priority)


   if (varTbl[modFn] == nil) then
      varTbl[modFn] = Var:new(modFn, nil, sep)
   end

   varTbl[modFn]:remove(fn, where, priority)
end

--------------------------------------------------------------------------
-- Master:master() - Singleton Ctor.

function M.master(self, safe)
   dbg.start{"Master:master(safe: ",safe,")"}
   if (next(s_master) == nil) then
      MT       = systemG.MT
      s_master = new(self, safe)
   end
   dbg.fini("Master:master")
   return s_master
end


--------------------------------------------------------------------------
-- access_find_module_file(): This local function returns the name of the
--                            filename and the full name of the module file.
--                            If the user gives the short name and it is
--                            loaded then that version is used not the default
--                            module file for the one named.  Otherwise
--                            find_module_file is used.

local function access_find_module_file(mname)
   local mt    = MT:mt()
   local sn    = mname:sn()
   if (sn == mname:usrName() and mt:have(sn,"any")) then
      local full = mt:fullName(sn)
      return mt:fileName(sn), full or ""
   end

   local t    = mname:find()
   local full = t.modFullName or ""
   local fn   = t.fn
   return fn, full
end

--------------------------------------------------------------------------
-- Master:access():  This member function is engine that runs the user
--                   commands "help", "whatis" and "show".  In each case
--                   mcp is set to MC_Access, MC_Access and MC_Show,
--                   respectively.  Using that value of mcp, the
--                   modulefile is found and evaluated by loadModuleFile.
--                   This causes the help, or whatis or showing the
--                   modulefile as the user requested.

function M.access(self, ...)
   local masterTbl = masterTbl()
   local shell     = s_master.shell
   local mt        = MT:mt()
   local mStack    = ModuleStack:moduleStack()
   local prtHdr    = systemG.prtHdr
   local a         = {}
   local shellN    = s_master.shell:name()
   local help      = (systemG.help ~= dbg.quiet) and "-h" or nil
   local result, t
   local A         = ShowResultsA
   dbg.print{"RTM(1) #A:",#A,"\n"}

   local arg = pack(...)
   for i = 1, arg.n do
      local moduleName   = arg[i]
      local mname        = MName:new("load", moduleName)
      local fn, full     = access_find_module_file(mname)
      systemG.ModuleFn   = fn
      systemG.ModuleName = full
      if (fn and isFile(fn)) then
         A[#A+1] = prtHdr()
         dbg.print{"RTM(2) #A:",#A,"\n"}
         if (masterTbl.rawDisplay) then
            local f     = io.open(fn, "r")
            local whole = f:read("*all")
            f:close()
            A[#A+1]     = whole
         else
            mStack:push(full, moduleName, mname:sn(), fn)
            
            local mList = concatTbl(mt:list("both","active"),":")
            
            loadModuleFile{file=fn,help=help, shell=shellN, mList = mList,
                        reportErr=true}
            mStack:pop()
            A[#A+1] = "\n"
            dbg.print{"RTM(3) #A:",#A,"\n"}
         end
      else
         a[#a+1] = moduleName
      end
   end

   shell:echo(concatTbl(A,""))


   if (#a > 0) then
      setWarningFlag()
      io.stderr:write("Failed to find the following module(s):  \"",
                      concatTbl(a,"\", \""),"\" in your MODULEPATH\n")
      io.stderr:write("Try: \n",
                      "    \"module spider ", concatTbl(a," "), "\"\n",
                      "\nto see if the module(s) are available across all ",
                      "compilers and MPI implementations.\n")
   end
end

--------------------------------------------------------------------------
-- Master:inheritModule(): load the module that has the same name as the
--                         one on the top of mStack.  This way a user
--                         can "inherit" the contents of a system module
--                         instead of copying.

function M.inheritModule()
   dbg.start{"Master:inherit()"}

   local mt      = MT:mt()
   local shellN  = s_master.shell:name()
   local mStack  = ModuleStack:moduleStack()
   local myFn    = mStack:fileName()
   local myUsrN  = mStack:usrName()
   local sn      = mStack:sn()
   local mFull   = mStack:fullName()

   dbg.print{"myFn:  ", myFn,"\n"}
   dbg.print{"mFull: ", mFull,"\n"}

   local fnI

   if (mode() == "unload") then
      dbg.print{"here before pop\n"}
      fnI = mt:popInheritFn(sn)
      dbg.print{"fnI: ",fnI,"\n"}
   else
      local t = find_inherit_module(mFull,myFn)
      fnI = t.fn
   end

   dbg.print{"fn: ", fnI,"\n"}
   if (fnI == nil) then
      LmodError("Failed to inherit: ",mFull,"\n")
   else
      local mList = concatTbl(mt:list("both","active"),":")
      mStack:push(mFull, myUsrN, sn, fnI)
      loadModuleFile{file=fnI,mList = mList, shell=shellN,
                     reportErr=true}
      mStack:pop()
   end

   if (mode() == "load") then
      mt:pushInheritFn(sn,fnI)
   end

   dbg.fini("Master:inherit")
end

--------------------------------------------------------------------------
-- Master:load(): Load all requested modules.  Each module is unloaded
--                if it is currently loaded.

function M.load(mA)
   local mStack = ModuleStack:moduleStack()
   local shellN = s_master.shell:name()
   local mt     = MT:mt()
   local a      = {}

   dbg.start{"Master:load(mA)"}

   a   = {}
   for i  = 1,#mA do
      local mname      = mA[i]
      local moduleName = mname:usrName()
      local sn         = mname:sn()
      local loaded     = false
      local t          = mname:find()
      local fn         = t.fn
      dbg.print{"fn: ", t.fn,"\n"}
      if (mt:have(sn,"active")) then
         dbg.print{"Master:load reload module: \"",moduleName,
                   "\" as it is already loaded\n"}
         local mcp_old = mcp
         mcp           = MCP
         dbg.print{"Setting mcp to ", mcp:name(),"\n"}
         local ma      = {}
         ma[1]         = mA[i]
         mcp:unload(ma)
         local aa = mcp:load(ma)
         mcp           = mcp_old
         dbg.print{"Setting mcp to ", mcp:name(),"\n"}
         loaded = aa[1]
      elseif (fn) then
         dbg.print{"Master:loading: \"",moduleName,"\" from f: \"",fn,"\"\n"}
         local mList = concatTbl(mt:list("both","active"),":")
         mt:add(t, "pending")
	 mt:beginOP()
         mStack:push(t.modFullName, moduleName, sn, fn)
	 loadModuleFile{file=fn, shell = shellN, mList = mList, reportErr=true}
         mStack:pop()
	 mt:endOP()
         dbg.print{"Making ", t.modName, " active\n"}
         mt:setStatus(sn, "active")
         registerLoaded(t.modFullName, fn)
         dbg.print{"Marked: ",t.modFullName," as loaded\n"}
         loaded = true
         hook.apply("load",t)
      end
      a[#a+1] = loaded
   end

   if (M.safeToUpdate() and mt:safeToCheckZombies() and mStack:empty()) then
      dbg.print{"Master:load calling reloadAll()\n"}
      M.reloadAll()
   end
   dbg.fini("Master:load")
   return a
end

--------------------------------------------------------------------------
-- Master:refresh() - Loop over all active modules and reload each one.
--                    Since only the "shell" functions are active and all
--                    other Lmod functions are inactive because mcp is now
--                    MC_Refresh, there is no need to unload and reload the
--                    modulefiles.  Just call loadModuleFile() to redefine
--                    the aliases/shell functions in a subshell.

function M.refresh()
   local mStack  = ModuleStack:moduleStack()
   local mt      = MT:mt()
   local shellN  = s_master.shell:name()
   local mcp_old = mcp
   mcp           = MasterControl.build("refresh","load")
   dbg.start{"Master:refresh()"}

   local activeA = mt:list("short","active")

   for i = 1,#activeA do
      local sn      = activeA[i]
      local fn      = mt:fileName(sn)
      local usrName = mt:usrName(sn)
      local full    = mt:fullName(sn)
      local mList   = concatTbl(mt:list("both","active"),":")
      if (isFile(fn)) then
         mStack:push(full, usrName, sn, fn)
         dbg.print{"loading: ",sn," fn: ", fn,"\n"}
         loadModuleFile{file = fn, shell = shellN, mList = mList,
                        reportErr=true}
         mStack:pop()
      end
   end

   mcp = mcp_old
   dbg.print{"Setting mcp to : ",mcp:name(),"\n"}
   dbg.fini("Master:refresh")
end

--------------------------------------------------------------------------
-- Master:reloadAll(): Loop over all modules in MT to see if they still
--                     can be seen.  We check every active module to see
--                     if the file associated with loaded module is the
--                     same as [[find_module_file()]] reports.  If not
--                     then it is unloaded and an attempt is made to reload
--                     it.  Each inactive module is re-loaded if possible.

function M.reloadAll()
   local mt   = MT:mt()
   dbg.start{"Master:reloadAll()"}

   local mcp_old = mcp
   mcp = MCP
   dbg.print{"Setting mcp to ", mcp:name(),"\n"}

   local same = true
   local a    = mt:list("userName","any")
   for i = 1, #a do
      local v = a[i]
      local sn = v.sn
      if (mt:have(sn, "active")) then
         dbg.print{"module sn: ",sn," is active\n"}
         dbg.print{"userName:  ",v.name,"\n"}
         local mname    = MName:new("userName", v.name)
         local t        = mname:find()
         local fn       = mt:fileName(sn)
         local fullName = t.modFullName
         local userName = v.name
         if (t.fn ~= fn) then
            dbg.print{"Master:reloadAll t.fn: \"",t.fn or "nil","\"",
                      " mt:fileName(sn): \"",fn or "nil","\"\n"}
            dbg.print{"Master:reloadAll Unloading module: \"",sn,"\"\n"}
            local ma = {}
            ma[1] = mname
            mcp:unload(ma)
            dbg.print{"Master:reloadAll Loading module: \"",userName or "nil","\"\n"}
            local loadA = mcp:load(ma)
            dbg.print{"Master:reloadAll: fn: \"",fn or "nil",
                      "\" mt:fileName(sn): \"", tostring(mt:fileName(sn)), "\"\n"}
            if (loadA[1] and fn ~= mt:fileName(sn)) then
               same = false
               dbg.print{"Master:reloadAll module: ",fullName," marked as reloaded\n"}
            end
         end
      else
         dbg.print{"module sn: ", sn, " is inactive\n"}
         local fn    = mt:fileName(sn)
         local name  = v.name          -- This name is short for default and
                                       -- Full for specific version.
         dbg.print{"Master:reloadAll Loading module: \"", name, "\"\n"}
         local ma    = {}
         ma[1]       = MName:new("load",name)
         local aa = mcp:load(ma)
         if (aa[1] and fn ~= mt:fileName(sn)) then
            dbg.print{"Master:reloadAll module: ", name, " marked as reloaded\n"}
         end
         same = not aa[1]
      end
   end


   for i = 1, #a do
      local v  = a[i]
      local sn = v.sn
      if (not mt:have(sn, "active")) then
         local t = { modFullName = v.full, modName = sn, default = v.defaultFlg}
         dbg.print{"Master:reloadAll module: ", sn, " marked as inactive\n"}
         mt:add(t, "inactive")
      end
   end

   mcp = mcp_old
   dbg.print{"Setting mpc to ", mcp:name(),"\n"}
   dbg.fini("Master:reloadAll")
   return same
end

--------------------------------------------------------------------------
-- Master:safeToUpdate() - [[safe]] is set during ctor. It is controlled
--                         by the command table in lmod.

function M.safeToUpdate()
   return s_master.safe
end

--------------------------------------------------------------------------
-- Master:unload() - unload modulefile(s) via the module names.

function M.unload(mA)
   local mStack = ModuleStack:moduleStack()
   local mt     = MT:mt()
   local a      = {}
   local shellN = s_master.shell:name()
   dbg.start{"Master:unload(mA)"}

   local mcp_old = mcp

   mcp = MasterControl.build("unload")
   dbg.print{"Setting mcp to ", mcp:name(),"\n"}
   for i = 1, #mA do
      local mname      = mA[i]
      local moduleName = mname:usrName()
      local sn         = mname:sn()
      dbg.print{"Trying to unload: ", moduleName, " sn: ", sn,"\n"}

      if (mt:have(sn,"inactive")) then
         dbg.print{"Removing inactive module: ", moduleName, "\n"}
         mt:remove(sn)
         registerUnloaded(mt:fullName(sn), mt:fileName(sn))
         a[#a + 1] = true
      elseif (mt:have(sn,"active")) then
         dbg.print{"Mark ", moduleName, " as pending\n"}
         mt:setStatus(sn,"pending")
         local mList          = concatTbl(mt:list("both","active"),":")
         local f              = mt:fileName(sn)
         local fullModuleName = mt:fullName(sn)
         local isSticky       = mt:haveProperty(sn, "lmod", "sticky")
         if (isSticky) then
            mt:addStickyA(sn)
            dbg.print{"sn: ", sn, " Sticky: ",isSticky,"\n"}
         end

         dbg.print{"Master:unload: \"",fullModuleName,"\" from f: ",f,"\n"}
         mt:beginOP()
         dbg.print{"changePATH: ", mt._changePATHCount, "\n"}
         mStack:push(fullModuleName, moduleName, sn, f)
	 loadModuleFile{file=f, mList=mList, shell=shellN, reportErr=false}
         mStack:pop()
         mt:endOP()
         dbg.print{"changePATH: ", mt._changePATHCount, "\n"}
         dbg.print{"calling mt:remove(\"",sn,"\")\n"}
         local t = {fn = mt:fileName(sn), modFullName = mt:fullName(sn) }
         mt:remove(sn)
         registerUnloaded(fullModuleName, f)
         hook.apply("unload",t)
         a[#a + 1] = true
      else
         a[#a + 1] = false
      end
   end
   dbg.print{"changePATH: ", mt._changePATHCount, " Zombie state: ",mt:zombieState(),
             " mStack:empty(): ",mStack:empty(),"\n"}
   if (M.safeToUpdate() and mt:safeToCheckZombies() and mStack:empty()) then
      dbg.print{"In unload calling Master.reload\n"}
      M.reloadAll()
      dbg.print{"changePATH: ", mt._changePATHCount, " Zombie state: ",mt:zombieState(),
                " mStack:empty(): ",mStack:empty(),"\n"}
   end

   mcp = mcp_old
   dbg.print{"Setting mcp to ", mcp:name(),"\n"}
   dbg.fini("Master:unload")
   return a
end


function M.reload_sticky(self, force)

   dbg.start{"Master:reload_sticky()"}
   -- Try to reload any sticky modules.
   if (masterTbl().force or force) then
      dbg.fini("Master:reload_sticky")
      return
   end

   local mt       = MT:mt()
   local stuckA   = {}
   local unstuckA = {}
   local stickyA  = mt:getStickyA()
   local mcp_old  = mcp
   mcp            = MCP
   local reload   = false
   for i = 1, #stickyA do
      local entry = stickyA[i]
      local mname = MName:new("entryT",entry)
      local t     = mname:find()
      if (t.fn == entry.FN) then
         local ma = {}
         ma[1] = mname
         mcp:load(ma)
      end
      local sn = mname:sn()
      if (not mt:have(sn,"active")) then
         local j     = #unstuckA+1
         unstuckA[j] = { string.format("%3d)",j) , mname:usrName() }
      else
         reload = true
      end
   end
   mcp = mcp_old

   if (reload) then
      io.stderr:write("\nThe following modules were not unloaded:\n")
      io.stderr:write("   (Use \"module --force purge\" to unload all):\n\n")
      local b  = mt:list("fullName","active")
      local a  = {}
      for i = 1, #b do
         a[#a+1] = {"  " .. tostring(i) .. ")", b[i] }
      end
      local ct = ColumnTable:new{tbl=a, gap=0}
      io.stderr:write(ct:build_tbl(),"\n")
   end
   if (#unstuckA > 0) then
      io.stderr:write("\nThe following sticky modules could not be reloaded:\n")
      local ct = ColumnTable:new{tbl=unstuckA, gap=0}
      io.stderr:write(ct:build_tbl(),"\n")
   end

   dbg.fini("Master:reload_sticky")
end

--------------------------------------------------------------------------
--  All these routines from here to the end are part of "avail"
--------------------------------------------------------------------------


--------------------------------------------------------------------------
-- findDefault(): Find the default module for the current directory
--                [[mpath]].

local function findDefault(mpath, sn, versionA)
   dbg.start{"Master.findDefault(mpath=\"",mpath,"\", "," sn=\"",sn,"\")"}
   local mt   = MT:mt()
   local t    = {}

   local marked   = false
   local localDir = true
   local path     = abspath(pathJoin(mpath,sn))
   local default  = abspath_localdir(pathJoin(path, "default"))
   if (not isFile(default)) then
      marked   = true
   else
      local dfltA = {"/.modulerc", "/.version" }
      local vf    = false
      for i = 1, #dfltA do
         local n   = dfltA[i]
         local vFn = pathJoin(path,n)
         if (isFile(vFn)) then
            vf = versionFile(n, sn, vFn)
            break;
         end
      end
      if (vf) then
         marked = true
         default     = pathJoin(path,vf)
         --dbg.print{"(1) f: ",f," default: ", default, "\n"}
         if (default == nil) then
            local fn = vf .. ".lua"
            default  = pathJoin(path,fn)
            dbg.print{"(2) f: ",f," default: ", default, "\n"}
         end
         --dbg.print{"(3) default: ", default, "\n"}
      end
   end

   if (not default) then
      local d, bn = splitFileName(versionA[#versionA].file)
      default     = pathjoin(abspath(d), bn)
   end
   dbg.print{"default: ", default,"\n"}

   t.default     = default
   t.marked      = marked
   t.numVersions = #versionA

   dbg.fini("Master.findDefault")
   return t
end

--------------------------------------------------------------------------
--  availEntry(): This routine is handed a single entry.  It check to see
--                if matches the search criteria.  It also adds any
--                properties such as default or anything from [[propT]].

local function availEntry(defaultOnly, terse, label, szA, searchA, sn, name,
                          f, defaultModuleT, dbT, legendT, a)
   dbg.start{"Master:availEntry(defaultOnly, terse, label, szA, searchA, "..
                                "sn, name, f, defaultModuleT, dbT, legendT, a)"}

   dbg.print{"sn:" ,sn, ", name: ", name,", defaultOnly: ",defaultOnly,
             ", szA: ",szA,"\n"}
   local dflt        = ""
   local sCount      = #searchA
   local found       = false
   local localdir    = true
   local hidden      = not masterTbl().show_hidden
   local mt          = MT:mt()

   if (sCount == 0) then
      found = true
   else
      for i = 1, sCount do
         local s = searchA[i]
         if (name:find(s) or sn:find(s)) then
            found = true
            break
         end
         if (LMOD_MPATH_AVAIL ~= "no" and label:find(s)) then
           found = true
           break
         end
      end
   end

   local f_orig = f
   local d, bn  = splitFileName(f)
   local d2     = abspath(d)
   f            = pathJoin(d2,bn)
   local fabs   = abspath_localdir(f)

   dbg.print{"defaultOnly: ",defaultOnly, ", defaultModuleT.fn: ",defaultModuleT.fn,
             ", f_orig: ",f_orig,", f: ", f,", d: ", d,", d2: ", d2, ", fabs: ",fabs,"\n"}

   local isDefault = (defaultModuleT.fn == f_orig or defaultModuleT.fn == fabs)

   dbg.print{"isDefault: ",isDefault, "\n"}

   --if (defaultOnly and defaultModuleT.fn ~= abspath(f, localdir)) then
   if (defaultOnly and not isDefault ) then
      found = false
   end

   if (not found) then
      dbg.print{"Not found\n"}
      dbg.fini("Master:availEntry")
      return
   end

   local mname   = MName:new("load", name)
   local version = mname:version() or ""
   if (hidden and version:sub(1,1) == "." or sn:sub(1,1) == ".") then
      dbg.print{"Not printing a dot modulefile\n"}
      dbg.fini("Master:availEntry")
      return
   end


   if (terse) then
      -- Print out directory (e.g. gcc) for tab-completion
      -- But only print it out when reporting defaultOnly.
      if (sn == name and szA > 0) then
         if (not defaultOnly) then
            a[#a+1] = name .. "/"
         end
      else
         a[#a+1] = name
      end
   else
      dbg.print{"defaultModuleT.fn: ",defaultModuleT.fn,
                ", kind: ", defaultModuleT.kind,
                ", num: ",  defaultModuleT.num > 1,
                ", f_orig: ", f_orig,
                ", f: ",f,
                "\n"}


      --if ((defaultModuleT.fn == abspath(f, localdir)) and
      if ((isDefault) and (defaultModuleT.num > 1) and not defaultOnly ) then
         dflt = Default
         legendT[Default] = "Default Module"
      end
      dbg.print{"dflt: ",dflt,"\n"}
      local aa    = {}
      local propT = {}
      local sn    = mname:sn()
      local entry = dbT[sn]
      if (entry) then
         dbg.print{"Found dbT[sn]\n"}
         if (entry[f_orig]) then
            propT =  entry[f_orig].propT or {}
         end
      else
         dbg.print{"Did not find dbT[sn]\n"}
      end
      local resultA = colorizePropA("short", name, propT, legendT)
      aa[#aa + 1] = '  '
      for i = 1,#resultA do
         aa[#aa+1] = resultA[i]
      end
      aa[#aa + 1] = dflt
      a[#a + 1]   = aa
   end
   dbg.fini("Master:availEntry")
end


---------------------------------------------------------------------------
-- availDir(): Handle a single directory and collect any entries through
--             [[availEntry]].


local function availDir(defaultOnly, terse, searchA, label, locationT, availT,
                        dbT, a, legendT)
   dbg.start{"Master.availDir(defaultOnly= ",defaultOnly,", terse= ",terse,
             ", searchA=(",concatTbl(searchA,", "), "), label= \"",label,"\", ",
             ",locationT, availT, dbT, a, legendT)"}
   if (availT == nil) then
      dbg.print{"(1) Skipping non-existant directory: ", label,"\n"}
      dbg.fini("Master.availDir")
      return
   end

   local cmp = (LMOD_CASE_INDEPENDENT_SORTING:lower():sub(1,1) == "y") and 
               case_independent_cmp or nil

   for sn, versionA in pairsByKeys(availT,cmp) do
      dbg.print{"sn: ",sn,"\n"}
      local defaultModuleT = locationT[sn].default
      local aa             = {}
      local szA            = versionA.total - versionA.hidden
      if (szA == 0 and versionA.hidden == 0) then
         local fn    = versionA[0].fn
         dbg.print{"fn: ",fn,"\n"}
         availEntry(defaultOnly, terse, label, szA, searchA, sn, sn, fn,
                    defaultModuleT, dbT, legendT, a)
      else
         if (terse and szA > 0) then
            -- Print out directory (e.g. gcc) for tab-completion
            availEntry(defaultOnly, terse, label, szA, searchA, sn, sn, "",
                       defaultModuleT, dbT, legendT, a)
         end
         for i = 1, #versionA do
            local name = pathJoin(sn, versionA[i].version)
            local f    = versionA[i].fn
            availEntry(defaultOnly, terse, label, szA, searchA, sn, name,
                       f, defaultModuleT, dbT, legendT, a)
         end
      end
   end
   dbg.fini("Master.availDir")
end

--------------------------------------------------------------------------
-- availOptions(): "module avail " takes options that are given here.
--                 Note that these are also available with the Lmod
--                 options. So "module -t avail" and "module avail -t" are
--                 the same thing.

local function availOptions(argA)
   local usage = "Usage: module avail [options] search1 search2 ..."
   local cmdlineParser = Optiks:new{usage=usage, version=""}

   argA[0] = "avail"

   cmdlineParser:add_option{
      name   = {'-t', '--terse'},
      dest   = 'terse',
      action = 'store_true',
   }
   cmdlineParser:add_option{
      name   = {'-d','--default'},
      dest   = 'defaultOnly',
      action = 'store_true',
   }
   local optionTbl, pargs = cmdlineParser:parse(argA)
   return optionTbl, pargs

end

local function regroup_avail_blocks(availStyle, mpathA, availT)
   --------------------------------------------------------------------------
   -- call hook to see if site wants to relabel and re-organize avail layout

   if (availStyle == "system") then
      return mpathA, availT
   end


   local labelT    = {}

   for i = 1, #mpathA do
      local mpath = mpathA[i]
      if ( availT[mpath] ~= nil) then
         labelT[mpath] = mpath
      end
   end

   hook.apply("avail",labelT)

   local label2mpathT = {}

   for i = 1, #mpathA do
      local mpath = mpathA[i]
      if ( availT[mpath] ~= nil) then
         local label = labelT[mpath]
         local a     = label2mpathT[label] or {}
         a[#a+1]     = i
         label2mpathT[label] = a
      end
   end

   if (dbg.active()) then
      for label, vA in pairs(label2mpathT) do
         dbg.print{"label: ",label,":",}
         for i = 1, #vA do
            io.stderr:write(" ",tostring(vA[i]))
         end
         io.stderr:write("\n")
      end
   end

   local orderA = {}
   for label, vA in pairs(label2mpathT) do
      orderA[#orderA + 1] = {vA[1], label}
   end
   sort(orderA, function(a,b) return a[1] < b[1] end )

   if (dbg.active()) then
      for j = 1, #orderA do
         dbg.print{j,", orderA: idx: ",orderA[j][1],", label: ",orderA[j][2],"\n"}
      end
   end

   local availNT = {}
   local labelA  = {}
   for j = 1, #orderA do
      local label    = orderA[j][2]
      local a        = label2mpathT[label]
      labelA[j]      = label
      availNT[label] = {}
      for i = 1, #a do
         local mpath = mpathA[a[i]]
         for k,v in pairs(availT[mpath]) do
            if (availNT[label][k] == nil) then
               availNT[label][k] = v
            else
               local vA = availNT[label][k]
               for iv = 1,#v do
                  vA[#vA+1] = v[iv]
               end
               sort(vA, function(a,b) return a.parseV < b.parseV end)
            end
         end
      end
   end
   return labelA, availNT
end
--------------------------------------------------------------------------
-- Master:avail(): Report the available modules with properties and
--                 defaults.  Run results through pager.
function M.avail(argA)
   dbg.start{"Master.avail(",concatTbl(argA,", "),")"}
   local mt        = MT:mt()
   local shell     = s_master.shell
   local mpathA    = mt:module_pathA()
   local twidth    = TermWidth()
   local masterTbl = masterTbl()

   local optionTbl, searchA = availOptions(argA)
   if (not masterTbl.regexp) then
      for i = 1, #searchA do
         searchA[i] = caseIndependent(searchA[i])
      end
   end
   local defaultOnly = optionTbl.defaultOnly or masterTbl.defaultOnly
   local terse       = optionTbl.terse       or masterTbl.terse
   local legendT     = {}
   local dbT         = {}

   if (terse) then
      dbg.print{"doing --terse\n"}
      local availT    = mt:availT()
      local locationT = mt:locationTbl()
      for ii = 1, #mpathA do
         local mpath = mpathA[ii]
         local a     = {}
         availDir(defaultOnly, terse, searchA, mpath, locationT, availT[mpath], dbT, a, legendT)
         if (next(a)) then
            io.stderr:write(mpath,":\n")
            for i=1,#a do
               io.stderr:write(a[i],"\n")
            end
         end
      end
      dbg.fini("Master:avail")
      return
   end

   local cache     = Cache:cache{quiet = masterTbl.terse}
   local moduleT   = cache:build()

   local baseMpath = mt:getBaseMPATH()
   if (not terse and (baseMpath == nil or baseMpath == '' or next(moduleT) == nil)) then
     LmodError("avail is not possible, MODULEPATH is not set or not set with valid paths.\n")
   end

   local spider     = Spider:new()
   spider:buildSpiderDB({"default"}, moduleT, dbT)

   local labelA     = false
   local availT     = mt:availT()
   local locationT  = mt:locationTbl()
   local availStyle = masterTbl.availStyle

   --------------------------------------------------------------------------
   -- call hook to see if site wants to relabel and re-organize avail layout

   labelA, availT  = regroup_avail_blocks(availStyle, mpathA, availT)

   local aa        = {}

   for j = 1, #labelA do
      local a     = {}
      local label = labelA[j]
      availDir(defaultOnly, terse, searchA, label, locationT, availT[label], dbT, a, legendT)
      if (next(a)) then
         aa[#aa+1] = "\n"
         aa[#aa+1] = banner:bannerStr(label)
         aa[#aa+1] = "\n"
         local ct  = ColumnTable:new{tbl=a, gap=1, len=length}
         aa[#aa+1] = ct:build_tbl()
         aa[#aa+1] = "\n"
      end
   end

   if (next(legendT)) then
      aa[#aa+1] = "\n  Where:\n"
      local a = {}
      for k, v in pairsByKeys(legendT) do
         a[#a+1] = { "   " .. k ..":", v}
      end
      local bt = BeautifulTbl:new{tbl=a, column = twidth-1, len=length}
      aa[#aa+1] = bt:build_tbl()
      aa[#aa+1] = "\n"
   end


   if (not quiet()) then
      aa = hook.apply("msgHook", "avail", aa)
   end
   shell:echo(concatTbl(aa,""))
   dbg.fini("Master.avail")
end

return M
