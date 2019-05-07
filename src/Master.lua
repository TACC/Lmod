require("strict")

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

require("myGlobals")
require("TermWidth")
require("string_utils")
require("loadModuleFile")

local Banner       = require("Banner")
local BeautifulTbl = require("BeautifulTbl")
local ColumnTable  = require("ColumnTable")
local FrameStk     = require("FrameStk")
local M            = {}         
local MRC          = require("MRC")
local MName        = require("MName")
local MT           = require("MT")
local ModuleA      = require("ModuleA")
local Var          = require("Var")
local concatTbl    = table.concat
local cosmic       = require("Cosmic"):singleton()
local dbg          = require("Dbg"):dbg()
local hook         = require("Hook")
local i18n         = require("i18n")
local remove       = table.remove
local sort         = table.sort
local q_load       = 0
local s_same       = true

local mpath_avail  = cosmic:value("LMOD_MPATH_AVAIL")

------------------------------------------------------------------------
-- a private ctor that is used to construct a singleton.

local s_master = false

local function new(self, safe)
   local o = {}

   setmetatable(o,self)
   self.__index = self
   o.__safe     = safe
   return o
end

--------------------------------------------------------------------------
-- Singleton Ctor.
-- @param self A Master object.
-- @param safe A flag.
function M.singleton(self, safe)
   dbg.start{"Master:singleton(safe: ",safe,")"}
   if (not s_master) then
      s_master = new(self, safe)
   end
   dbg.print{"s_master: ",tostring(s_master), ", safe: ",s_master.__safe,"\n"}
   dbg.fini("Master:singleton")
   return s_master
end

--------------------------------------------------------------------------
-- This member function is engine that runs the user
-- commands "help", "whatis" and "show".  In each case
-- mcp is set to MC_Access, MC_Access and MC_Show,
-- respectively.  Using that value of mcp, the
-- modulefile is found and evaluated by loadModuleFile.
-- This causes the help, or whatis or showing the
-- modulefile as the user requested.
-- @param self A Master object.
function M.access(self, ...)
   dbg.start{"Master:access(...)"}
   
   local masterTbl = masterTbl()
   local shell     = _G.Shell
   local frameStk  = FrameStk:singleton()
   local mt        = frameStk:mt()
   local prtHdr    = _G.prtHdr
   local a         = {}
   local shellNm   = shell:name()
   local help      = (_G.help ~= dbg.quiet) and "-h" or nil
   local A         = ShowResultsA
   local result, t

   local argA = pack(...)
   for i = 1, argA.n do
      local userName = argA[i]
      local mname    = mt:have(userName,"any") and MName:new("mt",userName)
                                               or  MName:new("load",userName) 
      local fn       = mname:fn()
      _G.ModuleFn    = fn
      _G.FullName    = mname:fullName()
      if (fn and isFile(fn)) then
         A[#A+1] = prtHdr()
         if (masterTbl.rawDisplay) then
            local f     = io.open(fn, "r")
            local whole = f:read("*all")
            f:close()
            A[#A+1]     = whole
         else
            local mList = concatTbl(mt:list("both","active"),":")
            frameStk:push(mname)
            loadModuleFile{file=fn,help=help, shell=shellNm, mList = mList,
                           reportErr=true}
            frameStk:pop()
            A[#A+1] = "\n"
         end
      else
         a[#a+1] = userName
      end
      mcp:registerAdminMsg({mname})
   end

   shell:echo(concatTbl(A,""))


   if (#a > 0) then
      setWarningFlag()
      LmodWarning{msg="w_Failed_2_Find",quote_comma_list=concatTbl(a,"\", \""),
                             module_list=concatTbl(a," ")}
   end
   dbg.fini("Master:access")
end

--------------------------------------------------------------------------
-- This function marks a module name as loaded and saves
-- it to LOADEDMODULES and _LMFILES_.   This is only for
-- compatibility with Tmod.
local function registerLoaded(fullName, fn)
   local frameStk = FrameStk:singleton()
   local varT     = frameStk:varT()
   local modList  = "LOADEDMODULES"
   local modFn    = "_LMFILES_"
   local nodups   = true
   local priority = 0
   local sep      = ":"
   if (varT[modList] == nil) then
      varT[modList] = Var:new(modList, nil, nodups, sep)
   end

   varT[modList]:append(fullName, nodups, priority)

   if (varT[modFn] == nil) then
      varT[modFn] = Var:new(modFn, nil, nodups, sep)
   end

   varT[modFn]:append(fn, nodups, priority)
end


--------------------------------------------------------------------------
-- This function marks a module name as unloaded and
-- saves it to LOADEDMODULES and _LMFILES_.   This is
-- only for compatibility with Tmod.
local function registerUnloaded(fullName, fn)
   local frameStk = FrameStk:singleton()
   local varT     = frameStk:varT()
   local modList  = "LOADEDMODULES"
   local modFn    = "_LMFILES_"
   local where    = "all"
   local nodups   = true
   local sep      = ":"
   local priority = 0

   if (varT[modList] == nil) then
      varT[modList] = Var:new(modList, nil, nodups, sep)
   end

   varT[modList]:remove(fullName, where, priority)


   if (varT[modFn] == nil) then
      varT[modFn] = Var:new(modFn, nil, nodups, sep)
   end

   varT[modFn]:remove(fn, where, priority)
end

function M.inheritModule(self)
   dbg.start{"Master:inherit()"}
   local shellNm    = _G.Shell:name()
   local frameStk   = FrameStk:singleton()
   local myFn       = frameStk:fn()
   local myVersion  = frameStk:version()
   local myUserName = frameStk:userName()
   local myFullName = frameStk:fullName()
   local sn         = frameStk:sn()
   local mname      = false

   dbg.print{"myFn:  ", myFn,"\n"}
   dbg.print{"mFull: ", myFullName,"\n"}

   if (mode() == "unload") then
      local mt    = frameStk:mt()
      mname = mt:popInheritFn(sn)
   else
      local t = { sn = sn, version = myVersion, userName = myUserName, fn = myFn}
      mname = MName:new("inherit", t)
   end

   local fnI = mname:fn()
   dbg.print{mode(), " fnI: ",fnI,"\n"}
   if (not fnI) then
      LmodError{msg="e_Failed_2_Inherit", name = myFullName}
   else
      local mt    = frameStk:mt()
      local mList = concatTbl(mt:list("both","active"),":")
      frameStk:push(mname)
      loadModuleFile{file=mname:fn(),mList = mList, shell=shellNm, reportErr=true}
      frameStk:pop()
   end

   if (mode() == "load") then
      local mt = frameStk:mt()
      mt:pushInheritFn(sn, mname)
   end

   dbg.fini("Master:inherit")
end

local s_stk = {}

function M.mgrload(self, active)
   dbg.start{"Master:mgrload(",active.userName,")"}

   local mcp_old = mcp
   mcp           = MasterControl.build("mgrload","load")
   dbg.print{"Setting mcp to ", mcp:name(),"\n"}
   local mname   = MName:new("load", active.userName)
   mname:setRefCount(active.ref_count)
   mname:setStackDepth(active.stackDepth)
   local a       = MCP.load(mcp,{mname})
   mcp           = mcp_old
   dbg.print{"Setting mcp to ", mcp:name(),"\n"}
   
   dbg.fini("Master:mgrload")
   return a

end

function M.load(self, mA)
   if (dbg.active()) then
      local s = mAList(mA)
      dbg.start{"Master:load(mA={"..s.."})"}
   end

   local disable_same_name_autoswap = cosmic:value("LMOD_DISABLE_SAME_NAME_AUTOSWAP")

   local masterTbl = masterTbl()
   local tracing   = cosmic:value("LMOD_TRACING")
   local frameStk  = FrameStk:singleton()
   local shell     = _G.Shell
   local shellNm   = shell and shell:name() or "bash"
   local a         = true
   local mt


   for i = 1,#mA do
      repeat
         local mname      = mA[i]
         local userName   = mname:userName()

         dbg.print{"Master:load i: ",i,", userName: ",userName,"\n",}

         mt               = frameStk:mt()
         local sn         = mname:sn()
         if ((sn == nil) and ((i > 1) or (frameStk:stackDepth() > 0))) then
            dbg.print{"Pushing ",mname:userName()," on moduleQ\n"}
            dbg.print{"i: ",i,", stackDepth: ", frameStk:stackDepth(),"\n"}
            mcp:pushModule(mname)
            if (tracing == "yes") then
               local stackDepth = frameStk:stackDepth()
               local indent     = ("  "):rep(stackDepth+1)
               local b          = {}
               b[#b + 1]        = indent
               b[#b + 1]        = "Pushing "
               b[#b + 1]        = userName
               b[#b + 1]        = " on moduleQ\n"
               shell:echo(concatTbl(b,""))
            end
            break  
         end

         local fullName   = mname:fullName()
         local fn         = mname:fn()
         local loaded     = false
     
         if (tracing == "yes") then
            local stackDepth = frameStk:stackDepth()
            local use_cache  = (not masterTbl.terse) or (cosmic:value("LMOD_CACHED_LOADS") ~= "no")
            local moduleA    = ModuleA:singleton{spider_cache=use_cache}
            local isNVV      = moduleA:isNVV()
            local indent     = ("  "):rep(stackDepth+1)
            local b          = {}
            TraceCounter     = TraceCounter + 1
            b[#b + 1]        = indent
            b[#b + 1]        = "(" .. tostring(TraceCounter) .. ")"
            b[#b + 1]        = "(" .. tostring(ReloadAllCntr) .. ")"
            b[#b + 1]        = "Loading: "
            b[#b + 1]        = userName
            b[#b + 1]        = " (fn: "
            b[#b + 1]        = fn or "nil"
            b[#b + 1]        = isNVV and ", using Find-First" or ", using Find-Best"
            b[#b + 1]        = ")\n"
            shell:echo(concatTbl(b,""))
         end

         dbg.print{"Master:load i: ",i," sn: ",sn," fn: ",fn,"\n"}

         if (mt:have(sn,"active")) then
            local version    = mname:version()
            local mt_version = mt:version(sn)

            dbg.print{"mnV: ",version,", mtV: ",mt_version,"\n"}

            if (disable_same_name_autoswap == "yes" and mt_version ~= version) then
               local oldFullName = pathJoin(sn,mt_version)
               LmodError{msg="e_No_AutoSwap", oldFullName = oldFullName, sn = sn, oldVersion = mt_version,
                                              newFullName = fullName,    newVersion = mname:version()}
            end

            local mcp_old = mcp
            local mcp     = MCP
            dbg.print{"Setting mcp to ", mcp:name(),"\n"}
            mcp:unload{MName:new("mt",sn)}
            mname:reset()  -- force a new lazyEval
            local status = mcp:load_usr{mname}
            mcp          = mcp_old
            dbg.print{"Setting mcp to ", mcp:name(),"\n"}
            if (not status) then
               loaded = false
            end
         elseif (not fn and not frameStk:empty()) then
            local msg = "Executing this command requires loading \"" .. userName .. "\" which failed"..
               " while processing the following module(s):\n\n"
            msg = buildMsg(TermWidth(), msg)
            if (haveWarnings()) then
               stackTraceBackA[#stackTraceBackA+1] = moduleStackTraceBack(msg)
            end
         elseif (fn) then
            dbg.print{"Master:loading: \"",userName,"\" from file: \"",fn,"\"\n"}
            local mList = concatTbl(mt:list("both","active"),":")
            frameStk:push(mname)
            mt = frameStk:mt()
            mt:add(mname,"pending")
            loadModuleFile{file = fn, shell = shellNm, mList = mList, reportErr = true}
            mt = frameStk:mt()
            mt:setStatus(sn, "active")
            hook.apply("load",{fn = mname:fn(), modFullName = mname:fullName()})
            frameStk:pop()
            dbg.print{"Marking ",fullName," as active and loaded\n"}
            registerLoaded(fullName, fn)
            loaded = true
         end
         mt = frameStk:mt()
         if (not mt:have(sn,"active")) then
            dbg.print{"failed to load ",mname:show(),"\n"}
            mcp:missing_module(userName, mname:show())
            a = false
         end

         if (mcp.processFamilyStack(fullName)) then
            local stackDepth = frameStk:stackDepth()
            dbg.print{"In M.load() when the family stack is not empty: fullName: ",fullName,", stackDepth: ", stackDepth,"\n"}
            local b = {}
            while (not mcp.familyStackEmpty()) do
               local   b_old, b_new = mcp.familyStackPop()
               LmodMessage{msg="m_Family_Swap", oldFullName=b_old.fullName, newFullName=b_new.fullName}
               local umA   = {MName:new("mt",   b_old.sn) , MName:new("mt",   b_new.sn) }
               local lmA   = {MName:new("load", b_new.userName)}
               b[#b+1]     = {umA = umA, lmA = lmA}
            end


            local force = true
            for j = 1,#b do
               s_stk[#s_stk + 1] = "stuff"
               mcp:unload_usr(b[j].umA, force)
               mcp:load(b[j].lmA)
               remove(s_stk)
            end
         end
      until true
   end
      
   mt = frameStk:mt()
   dbg.print{"safeToUpdate(): ", self.safeToUpdate(), ",  changeMPATH: ", mt:changeMPATH(), ", frameStk:empty(): ",frameStk:empty(),"\n"}

   if (self.safeToUpdate() and mt:changeMPATH() and frameStk:empty() and next(s_stk) == nil) then
      mt:reset_MPATH_change_flag()
      dbg.print{"Master:load calling reloadAll()\n"}
      local same = self:reloadAll()
      dbg.print{"RTM: same: ",same,"\n"}
      if (not same) then
         s_same = false
         dbg.print{"setting s_same: false\n"}
      end
   end

   local clear = false
   if (not s_same) then
      while (not mcp:isEmpty()) do
         local mname = mcp:popModule()
         q_load      = q_load + 1
         dbg.print{"q_load: ",q_load,", Trying to load userName: ",mname:userName(),"\n"}
         if (q_load > 10) then
            break
         end
         local aa = self:load{mname}
         dbg.print{"aa: ",aa,"\n"}
         if (not aa) then
            dbg.print{"setting clear: true\n"}
            clear = true
         end
      end
   end
   if (clear) then
      s_same = true
      dbg.print{"setting s_same: true\n"}
   end
         
   dbg.fini("Master:load")
   return a
end


--------------------------------------------------------------------------
-- Unload modulefile(s) via the module names.
-- @param mA An array of MName objects.
-- @return An array of true/false values indicating success or not.
function M.unload(self,mA)
   if (dbg.active()) then
      local s = mAList(mA)
      dbg.start{"Master:unload(mA={"..s.."})"}
   end

   local tracing  = cosmic:value("LMOD_TRACING")
   local frameStk = FrameStk:singleton()
   local shell    = _G.Shell
   local shellNm  = shell and shell:name() or "bash"
   local a        = {}
   local mt
   
   local mcp_old = mcp

   mcp = _G.MasterControl.build("unload")
   dbg.print{"Setting mcp to ", mcp:name(),"\n"}
   

   for i = 1, #mA do
      mt             = frameStk:mt()
      local mname    = mA[i]
      local userName = mname:userName()
      local fullName = mname:fullName()
      local sn       = mname:sn()
      local fn       = mname:fn()
      local status   = mt:status(sn)
      if (tracing == "yes") then
         local stackDepth = frameStk:stackDepth()
         local indent     = ("  "):rep(stackDepth+1)
         local b          = {}
         TraceCounter     = TraceCounter + 1
         b[#b + 1]        = indent
         b[#b + 1]        = "(" .. tostring(TraceCounter) .. ")"
         b[#b + 1]        = "(" .. tostring(ReloadAllCntr) .. ")"
         b[#b + 1]        = "Unloading: "
         b[#b + 1]        = userName
         b[#b + 1]        = " (status: "
         b[#b + 1]        = status
         b[#b + 1]        = ") (fn: "
         b[#b + 1]        = fn or "nil"
         b[#b + 1]        = ")\n"
         shell:echo(concatTbl(b,""))
      end

      dbg.print{"Trying to unload: ", userName, " sn: ", sn,"\n"}

      if (mt:have(sn,"inactive")) then
         dbg.print{"Removing inactive module: ", userName, "\n"}
         mt:remove(sn)
         registerUnloaded(mt:fullName(sn), mt:fn(sn))
         a[#a + 1] = true
      elseif (mt:have(sn,"active")) then
         dbg.print{"Master:unload: \"",userName,"\" from file: \"",fn,"\"\n"}
         frameStk:push(mname)
         mt = frameStk:mt()
         if (mt:haveProperty(sn, "lmod", "sticky")) then
            dbg.print{"Adding ",sn," to sticky list\n"}
            mt:addStickyA(sn)
         end
         
         mt:setStatus(sn,"pending")
         local mList = concatTbl(mt:list("both","active"),":")
	 loadModuleFile{file=fn, mList=mList, shell=shellNm, reportErr=false}
         mt = frameStk:mt()
         mt:remove(sn)
         registerUnloaded(fullName, fn)
         hook.apply("unload",{fn = mname:fn(), modFullName = mname:fullName()})
         frameStk:pop()
         a[#a+1] = true
      else
         a[#a+1] = false
      end
   end
   
   mt = frameStk:mt()
   dbg.print{"safeToUpdate(): ", self.safeToUpdate(), ",  changeMPATH: ", mt:changeMPATH(), ", frameStk:empty(): ",frameStk:empty(),"\n"}
   if (self.safeToUpdate() and mt:changeMPATH() and frameStk:empty() and next(s_stk) == nil) then
      mt:reset_MPATH_change_flag()
      dbg.print{"Master:load calling reloadAll()\n"}
      self:reloadAll()
   end

   mcp = mcp_old
   dbg.print{"Setting mcp to ", mcp:name(),"\n"}
   dbg.fini("Master:unload")
   return a
end

--------------------------------------------------------------------------
-- Loop over all modules in MT to see if they still
-- can be seen.  We check every active module to see
-- if the file associated with loaded module is the= 
-- same as [[find_module_file()]] reports.  If not
-- then it is unloaded and an attempt is made to reload
-- it.  Each inactive module is re-loaded if possible.
function M.reloadAll(self)
   ReloadAllCntr = ReloadAllCntr + 1
   dbg.start{"Master:reloadAll(count: ",ReloadAllCntr ,")"}
   local frameStk = FrameStk:singleton()
   local mt       = frameStk:mt()
   local mcp_old  = mcp
   local shell    = _G.Shell
   mcp = MCP
   dbg.print{"Setting mcp to ", mcp:name(),"\n"}

   local same     = true
   local a        = mt:list("userName","any")
   local tracing  = cosmic:value("LMOD_TRACING")
   local mA       = {}

   if (tracing == "yes") then
      local stackDepth = frameStk:stackDepth()
      local indent     = ("  "):rep(stackDepth+1)
      local nameA      = {}
      for i = 1, #a do
         nameA[#nameA + 1 ] = a[i].userName
      end
      local b          = {}
      b[#b + 1]        = indent
      b[#b + 1]        = "reloadAll("
      b[#b + 1]        = tostring(ReloadAllCntr)
      b[#b + 1]        = ")("
      b[#b + 1]        = concatTbl(nameA, ", ")
      b[#b + 1]        = ")\n"
      shell:echo(concatTbl(b,""))
   end

   for i = 1, #a do
      repeat
         mt               = frameStk:mt()
         local v          = a[i]
         local sn         = v.sn
         local mname_old  = MName:new("mt",v.userName)
         if (not mname_old:sn()) then break end
         dbg.print{"a[i].userName(1): ",v.userName,"\n"}
         mA[#mA+1]       = mname_old
         dbg.print{"adding sn: ",sn," to mA\n"}

         if (mt:have(sn, "active")) then
            dbg.print{"module sn: ",sn," is active\n"}
            dbg.print{"userName(2):  ",v.name,"\n"}
            local mname    = MName:new("load", mt:userName(sn))
            local fn_new   = mname:fn()
            local fn_old   = mt:fn(sn)
            local fullName = mname:fullName()
            local userName = v.name
            local mt_uName = mt:userName(sn)
            -- This is #issue 394 fix: only reload when the userName has remained the same.
            if (fn_new ~= fn_old) then
               dbg.print{"Master:reloadAll fn_new: \"",fn_new,"\"",
                         " mt:fileName(sn): \"",fn_old,"\"",
                         " mt:userName(sn): \"",mt_uName,"\"",
                         " a[i].userName: \"",userName,"\"",
                         "\n"}
               dbg.print{"Master:reloadAll(",ReloadAllCntr,"): Unloading module: \"",sn,"\"\n"}
               mcp:unload({mname_old})
               mt_uName = mt:userName(sn)
               dbg.print{"Master:reloadAll(",ReloadAllCntr,"): mt:userName(sn): \"",mt_uName,"\"\n"}
               mname    = MName:new("load", mt:userName(sn))
               if (mname:valid()) then
                  dbg.print{"Master:reloadAll(",ReloadAllCntr,"): Loading module: \"",userName,"\"\n"}
                  local status = mcp:load({mname})
                  mt           = frameStk:mt()
                  dbg.print{"status ",status,", fn_old: ",fn_old,", fn: ",mt:fn(sn),"\n"}
                  if (status and fn_old ~= mt:fn(sn)) then
                     same = false
                     dbg.print{"Master:reloadAll module: ",fullName," marked as reloaded\n"}
                  end
               end
            end
         else
            dbg.print{"module sn: ", sn, " is inactive\n"}
            local fn_old = mt:fn(sn)
            local name   = v.name          -- This name is short for default and
                                           -- Full for specific version.
            dbg.print{"Master:reloadAll(",ReloadAllCntr,"): Loading non-active module: \"", name, "\"\n"}
            local status = mcp:load({MName:new("load",name)})
            mt           = frameStk:mt()
            dbg.print{"status: ",status,", fn_old: ",fn_old,", fn: ",mt:fn(sn),"\n"}
            if (status and fn_old ~= mt:fn(sn)) then
               dbg.print{"Master:reloadAll module: ", name, " marked as reloaded\n"}
            end
            if (status) then
               same = false
            end
         end
      until true
   end

   mt = frameStk:mt()

   for i = 1, #mA do
      local mname = mA[i]
      local sn    = mname:sn()
      dbg.print{"checking sn: ",sn,"\n"}
      if (not mt:have(sn, "active")) then
         dbg.print{"Master:reloadAll module: ", sn, " marked as inactive\n"}
         mt:add(mname, "inactive", -i)
      end
   end

   mcp = mcp_old
   dbg.print{"Setting mpc to ", mcp:name(),"\n"}
   dbg.fini("Master:reloadAll")
   ReloadAllCntr = ReloadAllCntr - 1
   return same
end


--------------------------------------------------------------------------
-- Loop over all active modules and reload each one.
-- Since only the "shell" functions are active and all
-- other Lmod functions are inactive because mcp is now
-- MC_Refresh, there is no need to unload and reload the
-- modulefiles.  Just call loadModuleFile() to redefine
-- the aliases/shell functions in a subshell.
function M.refresh()
   dbg.start{"Master:refresh()"}
   local frameStk = FrameStk:singleton() 
   local mt       = frameStk:mt()
   local shellNm  = _G.Shell and _G.Shell:name() or "bash"
   local mcp_old  = mcp
   mcp            = MasterControl.build("refresh","load")

   local activeA  = mt:list("short","active")
   local mList    = concatTbl(mt:list("both","active"),":")

   for i = 1,#activeA do
      local sn       = activeA[i]
      local fn       = mt:fn(sn)
      if (isFile(fn)) then
         frameStk:push(MName:new("mt",sn))
         dbg.print{"loading: ",sn," fn: ", fn,"\n"}
         loadModuleFile{file = fn, shell = shellNm, mList = mList,
                        reportErr=true}
         frameStk:pop()
      end
   end

   mcp = mcp_old
   dbg.print{"Setting mcp to : ",mcp:name(),"\n"}
   dbg.fini("Master:refresh")
end

--------------------------------------------------------------------------
-- Loop over all active modules and reload each one.
-- Since only the "depend_on()" function is active and all
-- other Lmod functions are inactive because mcp is now
-- MC_DependencyCk, there is no need to unload and reload the
-- modulefiles.  Just call loadModuleFile() to check the dependencies.
function M.dependencyCk()
   dbg.start{"Master:dependencyCk()"}
   local frameStk = FrameStk:singleton() 
   local mt       = frameStk:mt()
   local shellNm  = _G.Shell and _G.Shell:name() or "bash"
   local mcp_old  = mcp
   mcp            = MasterControl.build("dependencyCk")

   local activeA  = mt:list("short","active")
   local mList    = concatTbl(mt:list("both","active"),":")

   for i = 1,#activeA do
      local sn       = activeA[i]
      local fn       = mt:fn(sn)
      if (isFile(fn)) then
         frameStk:push(MName:new("mt",sn))
         dbg.print{"loading: ",sn," fn: ", fn,"\n"}
         loadModuleFile{file = fn, shell = shellNm, mList = mList,
                        reportErr=true}
         frameStk:pop()
      end
   end

   mcp = mcp_old
   dbg.print{"Setting mcp to : ",mcp:name(),"\n"}
   dbg.fini("Master:dependencyCk")
end


--------------------------------------------------------------------------
-- Once the purge or unload happens, the sticky modules are reloaded.
-- @param self A Master object
-- @param force If true then don't reload.
function M.reload_sticky(self, force)
   local cwidth    = masterTbl().rt and LMOD_COLUMN_TABLE_WIDTH or TermWidth()

   dbg.start{"Master:reload_sticky(",force,")"}
   -- Try to reload any sticky modules.
   if (masterTbl().force or force) then
      dbg.fini("Master:reload_sticky")
      return
   end

   local frameStk = FrameStk:singleton()
   local mt       = frameStk:mt()
   local stuckA   = {}
   local unstuckA = {}
   local stickyA  = mt:getStickyA()
   local mcp_old  = mcp
   mcp            = MCP
   local reload   = false
   for i = 1, #stickyA do
      local entry = stickyA[i]
      local mname = MName:new("load",entry.userName)
      local fn    = mname:fn()

      if (fn and fn == entry.fn) then
         mcp:load({mname})
      end

      local sn    = mname:sn()
      mt          = frameStk:mt()
      if (not mt:have(sn, "active")) then
         local j     = #unstuckA+1
         unstuckA[j] = { string.format("%3d)",j) , mname:userName() }
      else
         reload = true
      end
   end
   mcp = mcp_old

   if (reload) then
      LmodMessage{msg="m_Sticky_Mods"}
      local b  = mt:list("fullName","active")
      local a  = {}
      for i = 1, #b do
         a[#a+1] = {"  " .. tostring(i) .. ")", b[i].fullName }
      end
      local ct = ColumnTable:new{tbl=a, gap=0, width=cwidth}
      io.stderr:write(ct:build_tbl(),"\n")
   end
   if (#unstuckA > 0) then
      LmodMessage{msg="m_Sticky_Unstuck"}
      local ct = ColumnTable:new{tbl=unstuckA, gap=0, width=cwidth}
      io.stderr:write(ct:build_tbl(),"\n")
   end

   dbg.fini("Master:reload_sticky")
end

--------------------------------------------------------------------------
-- *safe* is set during ctor. It is controlled by the command table in lmod.
-- @return the internal safe flag.
function M.safeToUpdate()
   return s_master.__safe
end

local function availEntry(defaultOnly, label, searchA, defaultT, entry)
   if (defaultOnly) then
      local fn    = entry.fn
      if (not defaultT[fn]) then
         return nil, nil
      end
   end

   local found    = true
   local fullName = entry.fullName
   local sn       = entry.sn
   local fn       = entry.fn
   if (searchA.n > 0) then
      found = false
      for i = 1, searchA.n do
         local s = searchA[i]
         if (fullName:find(s) or sn:find(s)) then
            found = true
            break
         end
         if (mpath_avail ~= "no" and label:find(s)) then
            found = true
            break
         end
      end
   end
   if (found) then
      return sn, fullName, fn
   end
   return nil, nil
end


local function mark_as_default(entry, defaultT)
   local defaultEntry = defaultT[entry.fn]
   return defaultEntry and defaultEntry.count > 1
end

local function regroup_avail_blocks(availStyle, availA)
   if (availStyle == "system") then
      return availA
   end

   dbg.start{"regroup_avail_blocks(",availStyle,", availA)"}
   local labelT       = {}
   local label2mpathT = {}
   
   for i = 1, #availA do         
      local mpath         = availA[i].mpath
      labelT[mpath]       = mpath
   end

   hook.apply("avail",labelT)

   for i = 1,#availA do
      local mpath         = availA[i].mpath
      local label         = labelT[mpath]
      local a             = label2mpathT[label] or {}
      a[#a+1]             = i
      label2mpathT[label] = a
   end


   if (dbg:active()) then
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
   
   if (dbg:active()) then
      for j = 1, #orderA do
         dbg.print{j,", orderA: idx: ",orderA[j][1], ", label: ",orderA[j][2],"\n"}
      end
   end

   local newAvailA = {}
   for k = 1, #orderA do
      local label  = orderA[k][2]
      local a      = label2mpathT[label]
      newAvailA[k] = {mpath = label, A = {}}
      local A      = newAvailA[k].A
      for j = 1, #a do
         local idx  = a[j]
         local oldA = availA[idx].A
         for i = 1,#oldA do
            A[#A+1] = oldA[i]
         end
      end
   end

   local cmp     = (cosmic:value("LMOD_CASE_INDEPENDENT_SORTING") == "yes") and
                    case_independent_cmp or regular_cmp
   for i = 1, #newAvailA do
      local A = newAvailA[i].A
      sort(A, cmp)
   end

   dbg.fini("regroup_avail_blocks")
   return newAvailA
end


function M.avail(self, argA)
   dbg.start{"Master:avail(",concatTbl(argA,", "),")"}
   local a           = {}
   local masterTbl   = masterTbl()
   local mt          = FrameStk:singleton():mt()
   local mpathA      = mt:modulePathA()
   local availStyle  = masterTbl.availStyle

   local numDirs = 0
   for i = 1,#mpathA do
      local mpath = mpathA[i]
      if (isDir(mpath)) then
         numDirs = numDirs + 1
      end
   end

   if (numDirs < 1) then
      if (masterTbl.terse) then
         return a
      end
      LmodError{msg="e_Avail_No_MPATH"}
      return a
   end

   local use_cache   = (not masterTbl.terse) or (cosmic:value("LMOD_CACHED_LOADS") ~= "no")
   local moduleA     = ModuleA:singleton{spider_cache=use_cache}
   local isNVV       = moduleA:isNVV()
   local mrc         = MRC:singleton()
   local availA      = moduleA:build_availA()
   local twidth      = TermWidth()
   local cwidth      = masterTbl.rt and LMOD_COLUMN_TABLE_WIDTH or twidth
   local defaultT    = moduleA:defaultT()
   local searchA     = argA
   local defaultOnly = masterTbl.defaultOnly
   local showSN      = not defaultOnly
   local alias2modT  = mrc:getAlias2ModT()

   dbg.print{"defaultOnly: ",defaultOnly,", showSN: ",showSN,"\n"}

   if (not masterTbl.regexp and argA and next(argA) ~= nil) then
      if (showSN) then
         showSN = argA.n == 0
      end
      searchA = {}
      for i = 1, argA.n do
         searchA[i] = argA[i]:caseIndependent()
      end
      searchA.n = argA.n 
   end
   
   if (masterTbl.terse) then

      --------------------------------------------------
      -- Terse output
      dbg.printT("availA",availA)
      for k, v in pairsByKeys(alias2modT) do
         local fullName = mrc:resolve(v)
         a[#a+1] = k.."(@" .. fullName ..")\n"
      end

      for j = 1,#availA do
         local A      = availA[j].A
         local label  = availA[j].mpath
         local aa     = {}
         local prtSnT = {}  -- Mark if we have printed the sn?

         for i = 1,#A do
            local sn, fullName, fn = availEntry(defaultOnly, label, searchA, defaultT, A[i])
            if (sn) then
               if (not prtSnT[sn] and sn ~= fullName and showSN) then
                  prtSnT[sn] = true
                  aa[#aa+1]  = sn .. "/\n"
               end
               local aliasA = mrc:getFull2AliasesT(fullName)
               if (aliasA) then
                  for i = 1,#aliasA do
                     local fullName = mrc:resolve(aliasA[i])
                     aa[#aa+1]  = aliasA[i] .. "(@".. fullName ..")\n"
                  end
               end
               aa[#aa+1]     = fullName .. "\n"
            end
         end
         if (next(aa) ~= nil) then
            a[#a+1]  = label .. ":\n"
            for i = 1,#aa do
               a[#a+1] = aa[i]
            end
         end
      end
      
      dbg.fini("Master:avail")
      return a
   end

   availA = regroup_avail_blocks(availStyle, availA)

   local banner   = Banner:singleton()
   local legendT  = {}
   local Default  = 'D'
   local numFound = 0

   
   if (next(alias2modT) ~= nil) then
      local b = {}
      for k, v in pairsByKeys(alias2modT) do
         local fullName = mrc:resolve(v)
         b[#b+1] = { "   " .. k, "->", fullName}
      end
      local ct = ColumnTable:new{tbl=b, gap=1, len=length, width = cwidth}
      a[#a+1]  = "\n"
      a[#a+1] = banner:bannerStr("Global Aliases")
      a[#a+1] = "\n"
      a[#a+1]  = ct:build_tbl()
      a[#a+1] = "\n"
   end


   for k = 1,#availA do
      local A = availA[k].A
      local label = availA[k].mpath
      if (next(A) ~= nil) then
         local b = {}
         for j = 1,#A do
            local entry = A[j]
            local sn, fullName, fn = availEntry(defaultOnly, label, searchA, defaultT, entry)
            if (sn) then
               local dflt = false
               if (not defaultOnly and mark_as_default(entry, defaultT)) then
                  dflt             = Default
                  legendT[Default] = i18n("DefaultM")
               end

               if (mt:have(sn, "active") and fn == mt:fn(sn)) then
                  entry.propT           = entry.propT or {}
                  entry.propT["status"] = {active = 1}
               end
               local c = {}
               local resultA = colorizePropA("short", {sn=sn, fullName=fullName, fn=fn}, mrc, entry.propT, legendT)
               c[#c+1] = '  '
               for i = 1,#resultA do
                  c[#c+1] = resultA[i]
               end

               local propStr = c[3] or ""
               local verMapStr = mrc:getMod2VersionT(fullName)
               if (verMapStr) then
                  legendT["Aliases"] = i18n("aliasMsg",{})
                  if (dflt == Default) then
                     dflt = Default .. ":" .. verMapStr
                  else
                     dflt = verMapStr
                  end
               end
               local d = {}
               if (propStr:len() > 0) then
                  d[#d+1] = propStr
               end
               if (dflt) then
                  d[#d+1] = dflt
               end
               c[3] = concatTbl(d,",")
               if (c[3]:len() > 0) then
                  c[3] = "(" .. c[3] .. ")"
               end
               b[#b+1] = c
               
            end
         end
         numFound = numFound + #b

         if (next(b) ~= nil) then
            local ct = ColumnTable:new{tbl=b, gap=1, len = length, width = cwidth}
            a[#a+1] = "\n"
            a[#a+1] = banner:bannerStr(label)
            a[#a+1] = "\n"
            a[#a+1]  = ct:build_tbl()
            a[#a+1] = "\n"
         end
      end
   end

   if (numFound == 0) then
      a[#a+1] = colorize("red",i18n("noModules",{}))
   end

   if (next(legendT) ~= nil) then
      a[#a+1] = i18n("m_Where",{})
      local b = {}
      for k, v in pairsByKeys(legendT) do
         b[#b+1] = { "   " .. k ..":", v}
      end
      local bt = BeautifulTbl:new{tbl=b, column = twidth-1, len=length}
      a[#a+1]  = bt:build_tbl()
      a[#a+1]  = "\n"
   end

   if (isNVV) then
      a[#a+1] = "\n"
      a[#a+1] = i18n("m_IsNVV");
   end
      
   if (not quiet()) then
      a = hook.apply("msgHook", "avail", a) or a
   end

   dbg.fini("Master:avail")
   return a
end


return M
