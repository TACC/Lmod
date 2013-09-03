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
require("string_trim")
require("fillWords")
require("loadModuleFile")

local BeautifulTbl = require('BeautifulTbl')
local ColumnTable  = require('ColumnTable')
local Dbg          = require("Dbg")
local Default      = '(D)'
local M            = {}
local MName        = require("MName")
local ModuleStack  = require("ModuleStack")
local Optiks       = require("Optiks")
local Spider       = require("Spider")
local hook         = require("Hook")
local lfs          = require('lfs')
local posix        = require("posix")

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
   local dbg      = Dbg:dbg()
   dbg.start("followDefault(path=\"",path,"\")")
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
   dbg.print("result: ",result,"\n")
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
   local dbg      = Dbg:dbg()
   dbg.start("find_inherit_module(",fullModuleName,",",oldFn, ")")

   local t        = {fn = nil, modFullName = nil, modName = nil,
                     default = 0, hash = 0}
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
      dbg.print("ii: ",ii," mpath: ",mpath," vv.file: ",vv.file," fn: ",fn,"\n")
      for i = 1, #searchTbl do
         local f        = fn .. searchTbl[i]
         local attr     = lfs.attributes(f)
         local readable = posix.access(f,"r")
         dbg.print('(1) fn: ',fn," f: ",f,"\n")
         if (readable and attr and attr.mode == "file") then
            result = f
            rstripped = result:gsub("%.lua$","")
            break
         end
      end

      dbg.print("(2) result: ", result, " foundOld: ", foundOld,"\n")
      if (foundOld) then
         break
      end


      if (result and rstripped == oldFn_stripped) then
         foundOld = true
         result = nil
      end
      dbg.print("(3) result: ", result, " foundOld: ", foundOld,"\n")
   end

   dbg.print("fullModuleName: ",fullModuleName, " fn: ", result,"\n")
   t.modFullName = fullModuleName
   t.fn          = result
   dbg.fini("find_inherit_module")
   return t
end

--------------------------------------------------------------------------
-- find_module_file(): This local routine is one of the key routines in
--                     Lmod.  This routine uses the MT:locationTbl routine
--                     find an array of directory paths that contain the
--                     module name of interest.  The outer loop searches
--                     over these directory paths.  The inner loop searches
--                     over files in the directory.

--  This routine is setting Lmod policy:
--    1) If it is a meta-module then it finds it immediately.
--    2) If a user specifies a module name (and not the full name) then
--       the following rules are used:
--         a) if a default or a .version file is specified then it is used
--            to pick the default.  (default file trumps .version)
--         b) If not default file is used (or --latest is used) then the
--            last file in the directory is used to pick the latest.
--            (see lastFileInDir() for details).
--         c) If the module name is used (and not full) then the first
--            directory in pathA is used.
--    3) If the user specifies the full name, then the each directory is
--       search in pathA.  It uses the first one that matches.  This is
--       the only way that the second directory is searched.
--    4) Note on --latest.  It just searches the first directory for the
--       "latest"  IT DOESN'T search any other directories in pathA.
--       (This just a restatement of 2c.)


local function find_module_file(mname)
   local dbg      = Dbg:dbg()
   dbg.start("Master:find_module_file(",mname:usrName(),")")

   local t        = { fn = nil, modFullName = nil, modName = nil, default = 0, hash = 0}
   local mt       = MT:mt()
   local fullName = ""
   local modName  = ""
   local sn       = mname:sn()
   dbg.print("sn: ",sn,"\n")

   -- Get all directories that contain the shortname [[sn]].  If none exist
   -- then the module does not exist => exit

   local pathA = mt:locationTbl(sn)
   if (pathA == nil or #pathA == 0) then
      dbg.print("did not find key: \"",sn,"\" in mt:locationTbl()\n")
      dbg.fini("Master:find_module_file")
      return t
   end
   local fn, result

   -- numS is the number of items to search for.  The first two are standard, the
   -- next 2 are the default and .version choices.  So if the user specifies
   -- "--latest" on the command line then set numS to 2 otherwise 4.
   local numS = (masterTbl().latest) and numSrchLatest or numSearch

   -- Outer Loop search over directories.
   for ii = 1, #pathA do
      local vv     = pathA[ii]
      local found  = false
      local mpath  = vv.mpath
      t.default    = 0
      fn           = pathJoin(vv.file, mname:version())
      result       = nil

      -- Inner loop search over search choices.
      for i = 1, numS do
         local v    = searchTbl[i]
         local f    = fn .. v
         local attr = lfs.attributes(f)
         local readable = posix.access(f,"r")

         -- Three choices:

         -- 1) exact match
         -- 2) name/default exists
         -- 3) name/.version exists.

         if (readable and attr and attr.mode == 'file') then
            result    = f
            found     = true
         end
         dbg.print('(1) fn: ',fn,", found: ",found,", v: ",v,", f: ",f,"\n")
         if (found and v == '/default' and ii == 1) then
            result    = followDefault(result)
            dbg.print("(2) result: ",result, " f: ", f, "\n")
            t.default = 1
         elseif (found and v == '/.version' and ii == 1) then
            local vf = M.versionFile(result)
            if (vf) then
               t         = find_module_file(MName:new("load",pathJoin(sn,vf)))
               t.default = 1
               result    = t.fn
            end
         end
         -- One of the three choices matched.
         if (found) then
            local _,j = result:find(mpath,1,true)
            fullName  = result:sub(j+2):gsub("%.lua$","")
            dbg.print("fullName: ",fullName,"\n")
            break
         end
      end

      dbg.print("found:", found, " fn: ",fn,"\n")


      if (not found and ii == 1) then
         ------------------------------------------------------------
         -- Search for "last" file in 1st directory since it wasn't
         -- found with exact or default match.
         t.default  = 1
         result = lastFileInDir(fn)
         if (result) then
            found = true
            local _, j = result:find(mpath,1,true)
            fullName   = result:sub(j+2):gsub("%.lua$","")
            dbg.print("lastFileInDir mpath: ", mpath," fullName: ",fullName,"\n")
         end
      end
      if (found) then break end
   end

   ------------------------------------------------------------------
   -- Build results and return.

   t.fn          = result
   t.modFullName = fullName
   t.modName     = sn
   dbg.print("modName: ",sn," fn: ", result," modFullName: ", fullName,
             " default: ",t.default,"\n")
   dbg.fini("Master:find_module_file")
   return t
end


--------------------------------------------------------------------------
-- Master:master() - Singleton Ctor.

function M.master(self, safe)
   if (next(s_master) == nil) then
      MT       = systemG.MT
      s_master = new(self, safe)
   end
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

   local t    = find_module_file(mname)
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
   local dbg    = Dbg:dbg()
   local mt     = MT:mt()
   local mStack = ModuleStack:moduleStack()
   local prtHdr = systemG.prtHdr
   local a      = {}
   local shellN = s_master.shell:name()
   local help   = (systemG.help ~= dbg.quiet) and "-h" or nil
   local result, t
   io.stderr:write("\n")

   local arg = {n=select('#', ...), ...}
   for i = 1, arg.n do
      local moduleName   = arg[i]
      local mname        = MName:new("load", moduleName)
      local fn, full     = access_find_module_file(mname)
      systemG.ModuleFn   = fn
      systemG.ModuleName = full
      if (fn and isFile(fn)) then
         prtHdr()
         mStack:push(full, moduleName, mname:sn(), fn)
         
         local mList = concatTbl(mt:list("both","active"),":") 

	 loadModuleFile{file=fn,help=help, shell=shellN, mList = mList,
                        reportErr=true}
         mStack:pop()
         io.stderr:write("\n")
      else
         a[#a+1] = moduleName
      end
   end

   if (#a > 0) then
      io.stderr:write("Failed to find the following module(s):  \"",
                      concatTbl(a,"\", \""),"\" in your MODULEPATH\n")
      io.stderr:write("Try: \n",
                      "    \"module spider ", concatTbl(a," "), "\"\n",
                      "\nto see if the module(s) are available across all ",
                      "compilers and MPI implementations.\n")
   end
end

--------------------------------------------------------------------------
-- Master:fakeload()  Loading a user collection has its problems.  A meta
--                    module or manager module (one that loads other
--                    modules) is not actually loaded.  Instead it is
--                    "fake" loaded.  That is it is added to the Module 
--                    Table.  The reasons for this are complicated but
--                    since all manager modules only load and do not set
--                    anything then all the action that a manager module
--                    is going to do has already been done.

function M.fakeload(...)
   local a   = {}
   local mt  = MT:mt()
   local dbg = Dbg:dbg()
   dbg.start("Master:fakeload(",concatTbl({...},", "),")")

   for _, moduleName in ipairs{...} do
      local loaded = false
      local mname  = MName:new("load", moduleName)
      local t      = find_module_file(mname)
      local fn     = t.fn
      if (fn) then
         t.mType = "m"
         mt:add(t,"active")
         loaded = true
      end
      a[#a+1] = loaded
   end
   dbg.fini("Master:fakeload")
end

--------------------------------------------------------------------------
-- Master:inheritModule(): load the module that has the same name as the
--                         one on the top of mStack.  This way a user
--                         can "inherit" the contents of a system module
--                         instead of copying.

function M.inheritModule()
   local dbg     = Dbg:dbg()
   dbg.start("Master:inherit()")

   local mt      = MT:mt()
   local shellN  = s_master.shell:name()
   local mStack  = ModuleStack:moduleStack()
   local myFn    = mStack:fileName()
   local myUsrN  = mStack:usrName()
   local sn      = mStack:sn()
   local mFull   = mStack:fullName()

   dbg.print("myFn:  ", myFn,"\n")
   dbg.print("mFull: ", mFull,"\n")

   local fnI     
   
   if (mode() == "unload") then
      dbg.print("here before pop\n")
      fnI = mt:popInheritFn(sn)
      dbg.print("fnI: ",fnI,"\n")
   else
      local t = find_inherit_module(mFull,myFn)
      fnI = t.fn
   end

   dbg.print("fn: ", fnI,"\n")
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

function M.load(...)
   local mStack = ModuleStack:moduleStack()
   local shellN = s_master.shell:name()
   local mt     = MT:mt()
   local dbg    = Dbg:dbg()
   local a      = {}

   dbg.start("Master:load(",concatTbl({...},", "),")")

   a   = {}
   for _,moduleName in ipairs{...} do
      moduleName    = moduleName
      local mname   = MName:new("load",moduleName)
      local sn      = mname:sn()
      local loaded  = false
      local t	    = find_module_file(mname)
      local fn      = t.fn
      if (mt:have(sn,"active")) then
         dbg.print("Master:load reload module: \"",moduleName,
                   "\" as it is already loaded\n")
         local mcp_old = mcp
         mcp           = MCP
         mcp:unload(moduleName)
         local aa = mcp:load(moduleName)
         mcp           = mcp_old
         loaded = aa[1]
      elseif (fn) then
         dbg.print("Master:loading: \"",moduleName,"\" from f: \"",fn,"\"\n")
         local mList = concatTbl(mt:list("both","active"),":")
         mt:add(t, "pending")
	 mt:beginOP()
         dbg.print("changePATH: ", mt._changePATHCount, "\n")
         mStack:push(t.modFullName, moduleName, sn, fn)
	 loadModuleFile{file=fn, shell = shellN, mList = mList, reportErr=true}
         t.mType = mStack:moduleType()
         mStack:pop()
	 mt:endOP()
         dbg.print("changePATH: ", mt._changePATHCount, "\n")
         dbg.print("Making ", t.modName, " active\n")
         mt:setStatus(sn, "active")
         mt:set_mType(sn, t.mType)
         dbg.print("Marked: ",t.modFullName," as loaded\n")
         loaded = true
         hook.apply("load",t)
      end
      a[#a+1] = loaded
   end

   dbg.print("changePATH: ", mt._changePATHCount, " Zombie state: ",mt:zombieState(),
             " mStack:empty(): ",mStack:empty(),"\n")
   if (M.safeToUpdate() and mt:safeToCheckZombies() and mStack:empty()) then
      dbg.print("Master:load calling reloadAll()\n")
      M.reloadAll()
      dbg.print("changePATH: ", mt._changePATHCount, " Zombie state: ",mt:zombieState(),
             " mStack:empty(): ",mStack:empty(),"\n")
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
   local dbg     = Dbg:dbg()
   local shellN  = s_master.shell:name()
   local mcp_old = mcp
   mcp           = MasterControl.build("refresh","load")
   dbg.start("Master:refresh()")

   local activeA = mt:list("short","active")

   for i = 1,#activeA do
      local sn      = activeA[i]
      local fn      = mt:fileName(sn)
      local usrName = mt:usrName(sn)
      local full    = mt:fullName(sn)
      local mList   = concatTbl(mt:list("both","active"),":")
      mStack:push(full, usrName, sn, fn)
      dbg.print("loading: ",sn," fn: ", fn,"\n")
      loadModuleFile{file = fn, shell = shellN, mList = mList,
                     reportErr=true}
      mStack:pop()
   end

   mcp = mcp_old
   dbg.print("Resetting mcp to : ",mcp:name(),"\n")
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
   local dbg  = Dbg:dbg()
   dbg.start("Master:reloadAll()")

   local mcp_old = mcp
   mcp = MCP

   local same = true
   local a    = mt:list("userName","any")
   for i = 1, #a do
      local v = a[i]
      local sn = v.sn
      if (mt:have(sn, "active")) then
         dbg.print("module sn: ",sn," is active\n")
         dbg.print("userName:  ",v.name,"\n")
         local mname    = MName:new("userName", v.name)
         local t        = find_module_file(mname)
         local fn       = mt:fileName(sn)
         local fullName = t.modFullName
         local userName = v.name
         if (t.fn ~= fn) then
            dbg.print("Master:reloadAll t.fn: \"",t.fn or "nil","\"",
                      " mt:fileName(sn): \"",fn or "nil","\"\n")
            dbg.print("Master:reloadAll Unloading module: \"",sn,"\"\n")
            mcp:unloadsys(sn)
            dbg.print("Master:reloadAll Loading module: \"",userName or "nil","\"\n")
            local loadA = mcp:load(userName)
            dbg.print("Master:reloadAll: fn: \"",fn or "nil",
                      "\" mt:fileName(sn): \"", tostring(mt:fileName(sn)), "\"\n")
            if (loadA[1] and fn ~= mt:fileName(sn)) then
               same = false
               dbg.print("Master:reloadAll module: ",fullName," marked as reloaded\n")
            end
         end
      else
         dbg.print("module sn: ", sn, " is inactive\n")
         local fn    = mt:fileName(sn)
         local name  = v.name          -- This name is short for default and
                                       -- Full for specific version.
         dbg.print("Master:reloadAll Loading module: \"", name, "\"\n")
         local aa = mcp:load(name)
         if (aa[1] and fn ~= mt:fileName(sn)) then
            dbg.print("Master:reloadAll module: ", name, " marked as reloaded\n")
         end
         same = not aa[1]
      end
   end


   for i = 1, #a do
      local v  = a[i]
      local sn = v.sn
      if (not mt:have(sn, "active")) then
         local t = { modFullName = v.full, modName = sn, default = v.defaultFlg}
         dbg.print("Master:reloadAll module: ", sn, " marked as inactive\n")
         mt:add(t, "inactive")
      end
   end

   mcp = mcp_old
   dbg.print("Resetting mpc to ", mcp:name(),"\n")
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

function M.unload(...)
   local mStack = ModuleStack:moduleStack()
   local mt     = MT:mt()
   local dbg    = Dbg:dbg()
   local a      = {}
   local shellN = s_master.shell:name()
   dbg.start("Master:unload(",concatTbl({...},", "),")")

   local mcp_old = mcp

   mcp = MasterControl.build("unload")
   for _, moduleName in ipairs{...} do
      local mname = MName:new("mt", moduleName)
      local sn    = mname:sn()
      dbg.print("Trying to unload: ", moduleName, " sn: ", sn,"\n")

      if (mt:have(sn,"inactive")) then
         dbg.print("Removing inactive module: ", moduleName, "\n")
         mt:remove(sn)
         a[#a + 1] = true
      elseif (mt:have(sn,"active")) then
         dbg.print("Mark ", moduleName, " as pending\n")
         mt:setStatus(sn,"pending")
         local mList          = concatTbl(mt:list("both","active"),":")
         local f              = mt:fileName(sn)
         local fullModuleName = mt:fullName(sn)
         local isSticky       = mt:haveProperty(sn, "lmod", "sticky")
         if (isSticky) then
            mt:addStickyA(sn)
            dbg.print("sn: ", sn, " Sticky: ",isSticky,"\n")
         end

         dbg.print("Master:unload: \"",fullModuleName,"\" from f: ",f,"\n")
         mt:beginOP()
         dbg.print("changePATH: ", mt._changePATHCount, "\n")
         mStack:push(fullModuleName, moduleName, sn, f)
	 loadModuleFile{file=f, mList=mList, shell=shellN, reportErr=false}
         mStack:pop()
         mt:endOP()
         dbg.print("changePATH: ", mt._changePATHCount, "\n")
         dbg.print("calling mt:remove(\"",sn,"\")\n")
         mt:remove(sn)
         a[#a + 1] = true
      else
         a[#a + 1] = false
      end
   end
   dbg.print("changePATH: ", mt._changePATHCount, " Zombie state: ",mt:zombieState(),
             " mStack:empty(): ",mStack:empty(),"\n")
   if (M.safeToUpdate() and mt:safeToCheckZombies() and mStack:empty()) then
      dbg.print("In unload calling Master.reload\n")
      M.reloadAll()
      dbg.print("changePATH: ", mt._changePATHCount, " Zombie state: ",mt:zombieState(),
                " mStack:empty(): ",mStack:empty(),"\n")
   end

   mcp = mcp_old
   dbg.print("Resetting mcp to ", mcp:name(),"\n")
   
   -- Try to reload any sticky modules.

   if (mStack:empty() and not masterTbl().force) then
      local stuckA   = {}
      local unstuckA = {}
      local stickyA  = mt:getStickyA()
      for i = 1, #stickyA do
         local entry = stickyA[i]
         local mname = MName:new("entryT",entry)
         local t     = find_module_file(mname)
         if (t.fn == entry.FN) then
            MCP:load(mname:usrName())
         end
         local sn = mname:sn()
         if (mt:have(sn,"active")) then
            local j   = #stuckA+1
            stuckA[j] = { string.format("%3d)",j) , mt:fullName(sn) }
         else
            local j   = #unstuckA+1
            unstuckA[j] = { string.format("%3d)",j) , mname:usrName() }
         end
      end

      if (#stuckA > 0) then
         io.stderr:write("\nThe following sticky modules were not unloaded:\n")
         io.stderr:write("   (Use \"module --force purge\" to unload):\n\n")
         local ct = ColumnTable:new{tbl=stuckA, gap=0}
         io.stderr:write(ct:build_tbl(),"\n")
      end
      if (#unstuckA > 0) then
         io.stderr:write("\nThe following sticky modules could not be reloaded:\n")
         local ct = ColumnTable:new{tbl=unstuckA, gap=0}
         io.stderr:write(ct:build_tbl(),"\n")
      end
   end

   dbg.fini("Master:unload")
   return a
end

--------------------------------------------------------------------------
-- Master:versionFile(): This routine is given the absolute path to a
--                       .version file.  It checks to make sure that it is
--                       a valid TCL file.  It then uses the
--                       ModulesVersion.tcl script to return what the value
--                       of "ModulesVersion" is.

function M.versionFile(path)
   local dbg     = Dbg:dbg()
   dbg.start("Master:versionFile(",path,")")
   local f       = io.open(path,"r")
   if (not f)                        then
      dbg.print("could not find: ",path,"\n")
      dbg.fini("Master:versionFile")
      return nil
   end
   local s       = f:read("*line")
   f:close()
   if (not s:find("^#%%Module"))      then
      dbg.print("could not find: #%Module\n")
      dbg.fini("Master:versionFile")
      return nil
   end
   local cmd = pathJoin(cmdDir(),"ModulesVersion.tcl") .. " " .. path
   dbg.fini("Master:versionFile")
   return capture(cmd):trim()
end

--------------------------------------------------------------------------
--  All these routines in this block to the end are part of "avail"
--------------------------------------------------------------------------


--------------------------------------------------------------------------
-- findDefault(): Find the default module for the current directory
--                [[mpath]].

local function findDefault(mpath, sn, versionA)
   local dbg  = Dbg:dbg()
   dbg.start("Master.findDefault(mpath=\"",mpath,"\", "," sn=\"",sn,"\")")
   local mt   = MT:mt()

   local pathA  = mt:locationTbl(sn)
   local mpath2 = pathA[1].mpath

   if (mpath2 ~= mpath) then
      dbg.print("(1) default: \"nil\"\n")
      dbg.fini("Master.findDefault")
      return nil
   end

   local localDir = true
   local path     = pathJoin(mpath,sn)
   local default  = abspath(pathJoin(path, "default"), localDir)
   if (default == nil) then
      local vFn = abspath(pathJoin(path,".version"), localDir)
      if (isFile(vFn)) then
         local vf = M.versionFile(vFn)
         if (vf) then
            local f = pathJoin(path,vf)
            default = abspath(f,localDir)
            --dbg.print("(1) f: ",f," default: ", default, "\n")
            if (default == nil) then
               local fn = vf .. ".lua"
               local f  = pathJoin(path,fn)
               default  = abspath(f,localDir)
               dbg.print("(2) f: ",f," default: ", default, "\n")
            end
            --dbg.print("(3) default: ", default, "\n")
         end
      end
   end

   if (not default) then
      default = abspath(versionA[#versionA].file, localDir)
   end
   dbg.print("default: ", default,"\n")
   dbg.fini("Master.findDefault")

   return default, #versionA
end

--------------------------------------------------------------------------
--  availEntry(): This routine is handed a single entry.  It check to see
--                if matches the search criteria.  It also adds any
--                properties such as default or anything from [[propT]].

local function availEntry(defaultOnly, terse, szA, searchA, sn, name,
                          f, defaultModule, dbT, legendT, a)
   local dbg      = Dbg:dbg()
   dbg.start("Master:availEntry(defaultOnly, terse, szA, searchA, "..
                               "sn, name, f, defaultModule, dbT, legendT, a)")

   dbg.print("sn:" ,sn, ", name: ", name,", defaultOnly: ",defaultOnly,
             ", szA: ",szA,"\n")
   local dflt     = ""
   local sCount   = #searchA
   local found    = false
   local localdir = true
   local mt       = MT:mt()

   if (sCount == 0) then
      found = true
   else
      for i = 1, sCount do
         local s = searchA[i]
         if (name:find(s, 1, true) or name:find(s) or
             sn:find(s, 1, true)   or sn:find(s)) then
            found = true
            break
         end
      end
   end

   if (defaultOnly and szA > 1 and  defaultModule ~= abspath(f, localdir)) then
      found = false
   end

   if (not found) then
      dbg.print("Not found\n")
      dbg.fini("Master:availEntry")
      return
   end

   local mname   = MName:new("load", name)
   local version = mname:version() or ""
   if (version:sub(1,1) == ".") then
      dbg.print("Not printing a dot modulefile\n")
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
      if (defaultModule == abspath(f, localdir) and szA > 1 and
          not defaultOnly ) then
         dflt = Default
         legendT[Default] = "Default Module"
      end
      dbg.print("dflt: ",dflt,"\n")
      local aa    = {}
      local propT = {}
      local sn    = mname:sn()
      local entry = dbT[sn]
      if (entry) then
         dbg.print("Found dbT[sn]\n")
         if (entry[f]) then
            propT =  entry[f].propT or {}
         end
      else
         dbg.print("Did not find dbT[sn]\n")
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


local function availDir(defaultOnly, terse, searchA, mpath, availT,
                        dbT, a, legendT)
   local dbg    = Dbg:dbg()
   dbg.start("Master.availDir(defaultOnly= ",defaultOnly,", terse= ",terse,
             ", searchA=(",concatTbl(searchA,", "), "), mpath= \"",mpath,"\", ",
             "availT, dbT, a, legendT)")
   local attr    = lfs.attributes(mpath)
   local mt      = MT:mt()
   if (not attr or type(attr) ~= "table" or attr.mode ~= "directory"
       or not posix.access(mpath,"x")) then
      dbg.print("Skipping non-existant directory: ", mpath,"\n")
      dbg.fini("Master.availDir")
      return
   end


   for sn, versionA in pairsByKeys(availT) do
      local defaultModule = false
      local aa            = {}
      local szA           = #versionA
      if (szA == 0) then
         availEntry(defaultOnly, terse, szA, searchA, sn, sn, "",
                    defaultModule, dbT, legendT, a)
      else
         defaultModule = findDefault(mpath, sn, versionA)
         if (terse) then
            -- Print out directory (e.g. gcc) for tab-completion
            availEntry(defaultOnly, terse, szA, searchA, sn, sn, "",
                       defaultModule, dbT, legendT, a)
         end
         for i = 1, #versionA do
            local name = pathJoin(sn, versionA[i].version)
            local f    = versionA[i].file
            availEntry(defaultOnly, terse, szA, searchA, sn, name,
                       f, defaultModule, dbT, legendT, a)
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

--------------------------------------------------------------------------
-- Master:avail(): Report the available modules with properties and 
--                 defaults.  Run results through pager.
function M.avail(argA)
   local dbg       = Dbg:dbg()
   dbg.start("Master.avail(",concatTbl(argA,", "),")")
   local mt        = MT:mt()
   local mpathA    = mt:module_pathA()
   local twidth    = TermWidth()
   local masterTbl = masterTbl()

   local cache     = Cache:cache{quiet = masterTbl.terse}
   local moduleT   = cache:build()
   local dbT       = {}
   Spider.buildSpiderDB({"default"}, moduleT, dbT)

   local legendT   = {}
   local availT    = mt:availT()

   local aa        = {}

   local optionTbl, searchA = availOptions(argA)

   local defaultOnly = optionTbl.defaultOnly or masterTbl.defaultOnly
   local terse       = optionTbl.terse       or masterTbl.terse


   if (terse) then
      dbg.print("doing --terse\n")
      for ii = 1, #mpathA do
         local mpath = mpathA[ii]
         local a     = {}
         availDir(defaultOnly, terse, searchA, mpath, availT[mpath], dbT, a, legendT)
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

   for _,mpath in ipairs(mpathA) do
      local a = {}
      availDir(defaultOnly, terse, searchA, mpath, availT[mpath], dbT, a, legendT)
      if (next(a)) then
         aa[#aa+1] = "\n"
         aa[#aa+1] = bannerStr(twidth, mpath)
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


   if (not expert()) then
      local a = fillWords("","Use \"module spider\" to find all possible modules.",twidth)
      local b = fillWords("","Use \"module keyword key1 key2 ...\" to search for all " ..
                             "possible modules matching any of the \"keys\".",twidth)
      aa[#aa+1] = "\n"
      aa[#aa+1] = a
      aa[#aa+1] = "\n"
      aa[#aa+1] = b
      aa[#aa+1] = "\n\n"
   end
   pcall(pager,io.stderr,concatTbl(aa,""))
   dbg.fini("Master.avail")
end

return M
