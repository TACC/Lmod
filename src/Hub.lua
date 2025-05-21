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

local Banner        = require("Banner")
local BeautifulTbl  = require("BeautifulTbl")
local Cache         = require("Cache")
local ColumnTable   = require("ColumnTable")
local FrameStk      = require("FrameStk")
local M             = {}
local MRC           = require("MRC")
local MName         = require("MName")
local MT            = require("MT")
local ModuleA       = require("ModuleA")
local Spider        = require("Spider")
local Var           = require("Var")
local concatTbl     = table.concat
local cosmic        = require("Cosmic"):singleton()
local dbg           = require("Dbg"):dbg()
local hook          = require("Hook")
local i18n          = require("i18n")
local remove        = table.remove
local sort          = table.sort
local q_load        = 0
local s_same        = true

local A             = ShowResultsA

------------------------------------------------------------------------
-- a private ctor that is used to construct a singleton.

local s_hub = false

local function l_new(self, safe)
   local o = {}

   setmetatable(o,self)
   self.__index = self
   o.__safe     = safe
   return o
end

--------------------------------------------------------------------------
-- Singleton Ctor.
-- @param self A Hub object.
-- @param safe A flag.
function M.singleton(self, safe)
   dbg.start{"Hub:singleton(safe: ",safe,")"}
   if (not s_hub) then
      s_hub = l_new(self, safe)
   end
   dbg.fini("Hub:singleton")
   return s_hub
end

--------------------------------------------------------------------------
-- This member function is engine that runs the user
-- commands "help", "whatis" and "show".  In each case
-- mcp is set to MC_Access, MC_Access and MC_Show,
-- respectively.  Using that value of mcp, the
-- modulefile is found and evaluated by loadModuleFile.
-- This causes the help, or whatis or showing the
-- modulefile as the user requested.
-- @param self A Hub object.
function M.access(self, ...)
   dbg.start{"Hub:access(...)"}

   local optionTbl = optionTbl()
   local shell     = _G.Shell
   local frameStk  = FrameStk:singleton()
   local mt        = frameStk:mt()
   local prtHdr    = _G.prtHdr
   local a         = {}
   local shellNm   = shell:name()
   local help      = (_G.help ~= dbg.quiet) and "-h" or nil
   local A         = ShowResultsA
   local mrc       = MRC:singleton()
   local result, t

   mrc:set_display_mode("all")

   local argA = pack(...)
   if (optionTbl.location or optionTbl.terse) then
      local userName = argA[1]
      local mname    = mt:have(userName,"any") and MName:new("mt",userName)
                                               or  MName:new("load",userName)
      local fn       = mname:fn() or ""
      shell:echo(fn .. "\n")
      return
   end

   for i = 1, argA.n do
      local userName = argA[i]
      local mname    = mt:have(userName,"any") and MName:new("mt",userName)
                                               or  MName:new("load",userName)
      local fn       = mname:fn()
      _G.ModuleFn    = fn
      _G.FullName    = mname:fullName()
      if (fn and isFile(fn)) then
         A[#A+1] = prtHdr()
         if (optionTbl.rawDisplay) then
            local f     = io.open(fn, "r")
            local whole = f:read("*all")
            f:close()
            A[#A+1]     = whole
         else
            local mList = concatTbl(mt:list("both","active"),":")
            frameStk:push(mname)
            loadModuleFile{file=fn,help=help, shell=shellNm, mList = mList,
                           reportErr=true, forbiddenT = mname:forbiddenT()}
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
      local report = quiet() and LmodWarning or LmodError
      report{msg="e_Failed_2_Find_w_Access",quote_comma_list=concatTbl(a,"\", \""),
             module_list=concatTbl(a," ")}
   end
   dbg.fini("Hub:access")end

--------------------------------------------------------------------------
-- This function marks a module name as loaded and saves
-- it to LOADEDMODULES and _LMFILES_.   This is only for
-- compatibility with Tmod.
local function l_registerLoaded(fullName, fn)
   local frameStk = FrameStk:singleton()
   local varT     = frameStk:varT()
   local modList  = "LOADEDMODULES"
   local modFn    = "_LMFILES_"
   local nodups   = true
   local priority = 0
   local delim    = ":"
   if (varT[modList] == nil) then
      varT[modList] = Var:new(modList, nil, nodups, delim)
   end

   varT[modList]:append(fullName, nodups, priority)

   if (varT[modFn] == nil) then
      varT[modFn] = Var:new(modFn, nil, nodups, delim)
   end

   varT[modFn]:append(fn, nodups, priority)
end


--------------------------------------------------------------------------
-- This function marks a module name as unloaded and
-- saves it to LOADEDMODULES and _LMFILES_.   This is
-- only for compatibility with Tmod.
local function l_registerUnloaded(fullName, fn)
   local frameStk = FrameStk:singleton()
   local varT     = frameStk:varT()
   local modList  = "LOADEDMODULES"
   local modFn    = "_LMFILES_"
   local where    = "all"
   local nodups   = true
   local delim    = ":"
   local priority = 0

   if (varT[modList] == nil) then
      varT[modList] = Var:new(modList, nil, nodups, delim)
   end

   varT[modList]:remove(fullName, where, priority)


   if (varT[modFn] == nil) then
      varT[modFn] = Var:new(modFn, nil, nodups, delim)
   end

   varT[modFn]:remove(fn, where, priority)
end

function M.inheritModule(self)
   dbg.start{"Hub:inheritModule()"}
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

      if (mode() == "show") then
         A[#A+1] = "--> "
         A[#A+1] = fnI
         A[#A+1] = "\n\n"
      end

      loadModuleFile{file=mname:fn(),mList = mList, shell=shellNm, reportErr=true,
                     forbiddenT = mname:forbiddenT()}
      frameStk:pop()
   end

   if (mode() == "show") then
      A[#A+1] = "\n"
   end
   if (mode() == "load") then
      local mt = frameStk:mt()
      mt:pushInheritFn(sn, mname)
   end

   dbg.fini("Hub:inheritModule")
end

local s_stk = {}

function M.mgrload(self, active)
   dbg.start{"Hub:mgrload(",active.userName,")"}

   --local mcp_old   = mcp
   mcpStack:push(mcp)
   mcp             = MainControl.build("mgrload","load")
   dbg.print{"Setting mcp to ", mcp:name(),"\n"}
   local mname     = MName:new("load", active.userName)
   local ref_count = active.ref_count
   if (ref_count) then
      ref_count = ref_count - 1
   end
   mname:set_ref_count(ref_count)
   mname:setStackDepth(active.stackDepth)
   mname:set_depends_on_flag(ref_count)
   local a       = MCP.load(mcp,{mname})
   --mcp           = mcp_old
   mcp           = mcpStack:pop()
   dbg.print{"Setting mcp to ", mcp:name(),"\n"}

   dbg.fini("Hub:mgrload")
   return a

end

function M.load(self, mA)
   if (dbg.active()) then
      local s = mAList(mA)
      dbg.start{"Hub:load(mA={"..s.."})"}
   end

   local disable_same_name_autoswap = cosmic:value("LMOD_DISABLE_SAME_NAME_AUTOSWAP")

   local dsConflicts = cosmic:value("LMOD_DOWNSTREAM_CONFLICTS")
   local optionTbl   = optionTbl()
   local tracing     = cosmic:value("LMOD_TRACING")
   local frameStk    = FrameStk:singleton()
   local shell       = _G.Shell
   local shellNm     = shell and shell:name() or "bash"
   local a           = true
   local mt


   for i = 1,#mA do
      repeat
         local mname      = mA[i]
         local userName   = mname:userName()
         mt               = frameStk:mt()

         local sn         = mname:sn()
         dbg.print{"Hub:load i: ",i,", userName: ",userName,", sn: ",sn,"\n",}

         if ((sn == nil) and ((i > 1) or (frameStk:stackDepth() > 0))) then
            dbg.print{"Pushing ",mname:userName()," on moduleQ\n"}
            dbg.print{"i: ",i,", stackDepth: ", frameStk:stackDepth(),"\n"}
            mcp:pushModule(mname)
            if (tracing == "yes") then
               tracing_msg{"Pushing ", userName, " on moduleQ"}
            end
            break
         end

         local fullName   = mname:fullName()
         local fn         = mname:fn()
         local loaded     = false

         if (tracing == "yes") then
            local use_cache  = (not optionTbl.terse) or (cosmic:value("LMOD_CACHED_LOADS") ~= "no")
            local moduleA    = ModuleA:singleton{spider_cache=use_cache}
            local isNVV      = moduleA:isNVV()
            TraceCounter     = TraceCounter + 1
            tracing_msg{"(" .. tostring(TraceCounter) .. ")",
                        "(" .. tostring(ReloadAllCntr) .. ")",
                        "Loading: ", userName, " (fn: ", fn or "nil",
                        isNVV and ", using Find-First" or ", using Find-Best",
                        ")" }
         end

         dbg.print{"Hub:load i: ",i,", sn: ",sn,", fullName: ",fullName,", fn: ",fn,"\n"}

         if (mt:have(sn,"active")) then
            local version    = mname:version()
            local mt_version = mt:version(sn)

            dbg.print{"mnV: ",version,", mtV: ",mt_version,"\n"}

            if (disable_same_name_autoswap == "yes" and mt_version ~= version) then
               local oldFullName = pathJoin(sn,mt_version)
               LmodError{msg="e_No_AutoSwap", oldFullName = oldFullName, sn = sn, oldVersion = mt_version,
                                              newFullName = fullName,    newVersion = mname:version()}
            end

            --local mcp_old = mcp
            mcpStack:push(mcp)
            local mcp     = MCP
            dbg.print{"Setting mcp to ", mcp:name(),"\n"}
            unload_internal{MName:new("mt",sn)}
            mname:reset()  -- force a new lazyEval
            local status = mcp:load_usr{mname}
            --mcp          = mcp_old
            mcp          = mcpStack:pop()
            dbg.print{"Setting mcp to ", mcp:name(),"\n"}
            if (not status) then
               loaded = false
            end
         elseif (not fn and not frameStk:empty()) then
            local msg = "Executing this command requires loading \"" .. userName .. "\" which failed"..
               " while processing the following module(s):\n\n"
            msg = buildMsg(TermWidth(), {n = 1,msg})
            if (haveWarnings()) then
               stackTraceBackA[#stackTraceBackA+1] = moduleStackTraceBack(msg)
            end
         elseif (fn) then
            dbg.print{"Hub:loading: \"",userName,"\" from file: \"",fn,"\"\n"}
            local mList = concatTbl(mt:list("both","active"),":")
            frameStk:push(mname)
            mt = frameStk:mt()
            mt:add(mname,"pending")
            dbg.print{"dsConflicts: ",dsConflicts,"\n"}
            if (dsConflicts == "yes") then
               local snUpstream = mt:haveDSConflict(mname)
               if (snUpstream) then
                  local fullNameUpstream = mt:fullName(snUpstream)
                  LmodError{msg="e_Conflict_Downstream", fullNameUpstream = fullNameUpstream,
                            userName=userName}
               end
            end


            local status = loadModuleFile{file = fn, shell = shellNm, mList = mList,
                                          reportErr = true, forbiddenT = mname:forbiddenT()}
            mt = frameStk:mt()

            -- A modulefile could the same named module over top of the current modulefile
            -- Say modulefile abc/2.0 loads abc/.cpu/2.0.  Then in the case of abc/2.0 the filename
            -- won't match.
            if (mt:fn(sn) == fn and status) then
               mt:setStatus(sn, "active")
               hook.apply("load",{fn = mname:fn(), modFullName = mname:fullName(), mname = mname})
               dbg.print{"Marking ",fullName," as active and loaded\n"}
               --l_registerLoaded(fullName, fn)
            end
            frameStk:pop()
            loaded = true
         end
         mt = frameStk:mt()
         if (not mt:have(sn,"active")) then
            dbg.print{"failed to load ",mname:show(),", sn: ", sn,"\n"}
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
               unload_usr_internal(b[j].umA, force)
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
      dbg.print{"Hub:load calling reloadAll()\n"}
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

   dbg.fini("Hub:load")
   return a
end

local function l_missingFn_action(actionA)
   dbg.start{"l_missingFn_action(actionA)"}
   local frameStk = FrameStk:singleton()
   local sn       = frameStk:sn()
   local msg      = ""
   local status   = true
   if (next(actionA) == nil) then
      dbg.fini("l_missingFn_action with empty actionA")
      return status
   end
   local whole  = concatTbl(actionA,"\n")
   dbg.print{"whole: ",whole,"\n"}
   status, msg = sandbox_run(whole)
   if (not status) then
      LmodError{msg="e_Missing_Action", name = sn, message = msg}
   end
   dbg.fini("l_missingFn_action")
   return status
end



--------------------------------------------------------------------------
-- Unload modulefile(s) via the module names.
-- @param mA An array of MName objects.
-- @return An array of true/false values indicating success or not.
function M.unload(self,mA)
   if (dbg.active()) then
      local s = mAList(mA)
      dbg.start{"Hub:unload(mA={"..s.."})"}
   end

   local tracing  = cosmic:value("LMOD_TRACING")
   local frameStk = FrameStk:singleton()
   local shell    = _G.Shell
   local shellNm  = shell and shell:name() or "bash"
   local a        = {}
   local mt

   for i = 1, #mA do
      mt             = frameStk:mt()
      local mname    = mA[i]
      local userName = mname:userName()
      local fullName = mname:fullName()
      local sn       = mname:sn()
      local fn       = mname:fn()
      local status   = mt:status(sn)
      if (tracing == "yes") then
         TraceCounter     = TraceCounter + 1
         tracing_msg{"(" .. tostring(TraceCounter) .. ")",
                     "(" .. tostring(ReloadAllCntr) .. ")",
                     "Unloading: ", userName, " (status: ",
                     status, ") (fn: ", fn or "nil", ")" }
      end

      dbg.print{"Trying to unload: ", userName, " sn: ", sn,"\n"}

      if (mt:have(sn,"inactive")) then
         dbg.print{"Removing inactive module: ", userName, "\n"}
         mt:remove(sn)
         --l_registerUnloaded(mt:fullName(sn), mt:fn(sn))
         a[#a + 1] = true
      elseif (mt:have(sn,"active")) then
         dbg.print{"Hub:unload: \"",userName,"\" from file: \"",fn,"\"\n"}
         frameStk:push(mname)
         mt = frameStk:mt()
         if (mt:haveProperty(sn, "lmod", "sticky")) then
            dbg.print{"Adding ",sn," to sticky list\n"}
            mt:addStickyA(sn)
         end

         mt:setStatus(sn,"pending")
         local status
         if (not isFile(fn)) then
            status = l_missingFn_action(mt:get_actionA(sn))
         else
            local mList  = concatTbl(mt:list("both","active"),":")
            status = loadModuleFile{file=fn, mList=mList, shell=shellNm, reportErr=false,
                                    forbiddenT = {}}
            dbg.print{"status from loadModulefile: ",status,"\n"}
         end
         if (status) then
            mt = frameStk:mt()
            mt:remove(sn)
            --l_registerUnloaded(fullName, fn)
            hook.apply("unload",{fn = mname:fn(), modFullName = mname:fullName(), mname = mname})
         end
         frameStk:pop()
         a[#a+1] = status
      else
         frameStk = FrameStk:singleton()
         if (frameStk:stackDepth() == 0 and not purgeFlg()) then
            LmodMessage{msg="m_Unload_unknown", modName = userName}
         end
         a[#a+1] = false
      end
   end

   mt = frameStk:mt()
   dbg.print{"safeToUpdate(): ", self.safeToUpdate(), ",  changeMPATH: ", mt:changeMPATH(), ", frameStk:empty(): ",frameStk:empty(),"\n"}
   if (self.safeToUpdate() and mt:changeMPATH() and frameStk:empty() and next(s_stk) == nil) then
      mt:reset_MPATH_change_flag()
      dbg.print{"Hub:load calling reloadAll()\n"}
      self:reloadAll()
   end

   dbg.print{"Setting mcp to ", mcp:name(),"\n"}
   dbg.fini("Hub:unload")
   return a
end

--------------------------------------------------------------------------
-- Loop over all modules in MT to see if they still
-- can be seen.  We check every active module to see
-- if the file associated with loaded module is the=
-- same as [[find_module_file()]] reports.  If not
-- then it is unloaded and an attempt is made to reload
-- it.  Each inactive module is re-loaded if possible.
function M.reloadAll(self, force_update)
   ReloadAllCntr = ReloadAllCntr + 1
   dbg.start{"Hub:reloadAll(count: ",ReloadAllCntr ,")"}
   local frameStk = FrameStk:singleton()
   local mt       = frameStk:mt()
   local shell    = _G.Shell
   --local mcp_old  = mcp
   mcpStack:push(mcp)
   mcp = MCP
   dbg.print{"Setting mcp to ", mcp:name(),"\n"}

   local same     = true
   local a        = mt:list("userName","any")
   local tracing  = cosmic:value("LMOD_TRACING")
   local mA       = {}

   if (tracing == "yes") then
      local nameA      = {}
      for i = 1, #a do
         nameA[#nameA + 1 ] = a[i].userName
      end
      tracing_msg{"reloadAll(", tostring(ReloadAllCntr),")(",
                  concatTbl(nameA, ", "), ")"}
   end

   for i = 1, #a do
      repeat
         mt               = frameStk:mt()
         local v          = a[i]
         local sn         = v.sn
         dbg.print{"v.userName: ",v.userName,", v.ref_count: ",v.ref_count,"\n"}
         local mname_old  = MName:new("mt",v.userName):set_depends_on_flag(v.ref_count)
         if (not mname_old:sn()) then break end
         dbg.print{"a[i].userName(1): ",v.userName,", ref_count: ",mname_old:ref_count(),"\n"}
         mA[#mA+1]       = mname_old
         dbg.print{"adding sn: ",sn," to mA\n"}

         if (mt:have(sn, "active")) then
            dbg.print{"module sn: ",sn," is active\n"}
            dbg.print{"userName(2):  ",v.name,", ref_count: ",v.ref_count,"\n"}
            local mname     = MName:new("load", mt:userName(sn)):set_depends_on_flag(v.ref_count)
            local fn_new    = mname:fn()
            local fn_old    = mt:fn(sn)
            local fullName  = mname:fullName()
            local userName  = v.name
            local mt_uName  = mt:userName(sn)
            dbg.print{"fn_new: ",fn_new,"\n"}
            dbg.print{"fn_old: ",fn_old,"\n"}
            -- This is Issue #394 fix: only reload when the userName has remained the same.
            if (fn_new ~= fn_old or force_update) then
               dbg.print{"Hub:reloadAll fn_new: \"",fn_new,"\"",
                         " mt:fileName(sn): \"",fn_old,"\"",
                         " mt:userName(sn): \"",mt_uName,"\"",
                         " a[i].userName: \"",userName,"\"",
                         "\n"}
               dbg.print{"Hub:reloadAll(",ReloadAllCntr,"): Unloading module: \"",sn,"\"\n"}
               unload_internal{mname_old}
               mt_uName = mt:userName(sn)
               dbg.print{"Hub:reloadAll(",ReloadAllCntr,"): mt:userName(sn): \"",mt_uName,"\"\n"}
               mname    = MName:new("load", mt:userName(sn)):set_depends_on_flag(v.ref_count)
               if (mname:valid()) then
                  dbg.print{"Hub:reloadAll(",ReloadAllCntr,"): Loading module: \"",userName,"\"\n"}
                  local status = mcp:load({mname})
                  mt           = frameStk:mt()
                  dbg.print{"status ",status,", fn_old: ",fn_old,", fn: ",mt:fn(sn),"\n"}
                  if (status and fn_old ~= mt:fn(sn)) then
                     same = false
                     dbg.print{"Hub:reloadAll module: ",fullName," marked as reloaded\n"}
                  end
               end
            end
         else
            dbg.print{"module sn: ", sn, " is inactive\n"}
            local fn_old = mt:fn(sn)
            local name   = v.name          -- This name is short for default and
                                           -- Full for specific version.
            dbg.print{"Hub:reloadAll(",ReloadAllCntr,"): Loading non-active module: \"", name, "\", ref_count: ", v.ref_count,"\n"}

            local status = mcp:load({MName:new("load",name):set_depends_on_flag(v.ref_count)})
            mt           = frameStk:mt()
            dbg.print{"status: ",status,", fn_old: ",fn_old,", fn: ",mt:fn(sn),"\n"}
            if (status and fn_old ~= mt:fn(sn)) then
               dbg.print{"Hub:reloadAll module: ", name, " marked as reloaded\n"}
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
         dbg.print{"Hub:reloadAll module: ", sn, " marked as inactive\n"}
         mt:add(mname, "inactive", -i)
      end
   end

   --mcp = mcp_old
   mcp = mcpStack:pop()
   dbg.print{"Setting mpc to ", mcp:name(),"\n"}
   dbg.fini("Hub:reloadAll")
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
   dbg.start{"Hub:refresh()"}
   local frameStk = FrameStk:singleton()
   local mt       = frameStk:mt()
   local shellNm  = _G.Shell and _G.Shell:name() or "bash"
   --local mcp_old  = mcp
   mcpStack:push(mcp)
   mcp            = MainControl.build("refresh","load")

   local activeA  = mt:list("short","active")
   local mList    = concatTbl(mt:list("both","active"),":")

   for i = 1,#activeA do
      local sn        = activeA[i]
      local fn        = mt:fn(sn)
      local userName  = mt:userName(sn)
      if (isFile(fn)) then
         frameStk:push(MName:new("mt",userName))
         dbg.print{"loading: ",sn,", userName: ",myModuleUsrName(),", fn: ", fn,"\n"}
         loadModuleFile{file = fn, shell = shellNm, mList = mList,
                        reportErr=true, forbiddenT = {}}
         frameStk:pop()
      end
   end

   --mcp = mcp_old
   mcp = mcpStack:pop()
   dbg.print{"Setting mcp to : ",mcp:name(),"\n"}
   dbg.fini("Hub:refresh")
end

--------------------------------------------------------------------------
-- Loop over all active modules and reload each one.
-- Since only the "depend_on()" function is active and all
-- other Lmod functions are inactive because mcp is now
-- MC_DependencyCk, there is no need to unload and reload the
-- modulefiles.  Just call loadModuleFile() to check the dependencies.
function M.dependencyCk()
   dbg.start{"Hub:dependencyCk()"}
   local frameStk = FrameStk:singleton()
   local mt       = frameStk:mt()
   local shellNm  = _G.Shell and _G.Shell:name() or "bash"
   --local mcp_old  = mcp
   mcpStack:push(mcp)
   mcp            = MainControl.build("dependencyCk")

   local activeA  = mt:list("short","active")
   local mList    = concatTbl(mt:list("both","active"),":")

   for i = 1,#activeA do
      local sn       = activeA[i]
      local fn       = mt:fn(sn)
      if (isFile(fn)) then
         frameStk:push(MName:new("mt",sn))
         dbg.print{"DepCk loading: ",sn," fn: ", fn,"\n"}
         loadModuleFile{file = fn, shell = shellNm, mList = mList,
                        reportErr=true, forbiddenT = {}}
         frameStk:pop()
      end
   end

   --mcp = mcp_old
   mcp = mcpStack:pop()
   dbg.print{"Setting mcp to : ",mcp:name(),"\n"}
   dbg.fini("Hub:dependencyCk")
end


--------------------------------------------------------------------------
-- Once the purge or unload happens, the sticky modules are reloaded.
-- @param self A Hub object
-- @param force If true then don't reload.
function M.reload_sticky(self, force)
   local cwidth    = optionTbl().rt and LMOD_COLUMN_TABLE_WIDTH or TermWidth()

   dbg.start{"Hub:reload_sticky(",force,")"}
   -- Try to reload any sticky modules.
   if (optionTbl().force or force) then
      dbg.fini("Hub:reload_sticky")
      return
   end

   local frameStk = FrameStk:singleton()
   local mt       = frameStk:mt()
   local stuckA   = {}
   local unstuckA = {}
   local stickyA  = mt:getStickyA()
   local reload   = false
   --local mcp_old  = mcp
   mcpStack:push(mcp)
   mcp            = MCP
   for i = #stickyA, 1, -1 do
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
   --mcp = mcp_old
   mcp = mcpStack:pop()

   if (reload and not quiet()) then
      LmodMessage{msg="m_Sticky_Mods"}
      local b  = mt:list("fullName","active")
      local a  = {}
      for i = 1, #b do
         a[#a+1] = {"  " .. tostring(i) .. ")", b[i].fullName }
      end
      local ct = ColumnTable:new{tbl=a, gap=0, width=cwidth}
      io.stderr:write(ct:build_tbl(),"\n")
   end
   if (#unstuckA > 0 and not quiet() ) then
      LmodMessage{msg="m_Sticky_Unstuck"}
      local ct = ColumnTable:new{tbl=unstuckA, gap=0, width=cwidth}
      io.stderr:write(ct:build_tbl(),"\n")
   end

   dbg.fini("Hub:reload_sticky")
end

--------------------------------------------------------------------------
-- *safe* is set during ctor. It is controlled by the command table in lmod.
-- @return the internal safe flag.
function M.safeToUpdate()
   return s_hub.__safe
end

local function l_availEntry(defaultOnly, label, searchA, defaultT, entry)
   local mpath_avail = cosmic:value("LMOD_MPATH_AVAIL")
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
   local provideA = entry.provides
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
      return sn, fullName, fn, provideA
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

local function l_build_searchA(mrc, mpathA, argA)
   local searchA = {}
   for i = 1, argA.n do
      local s  = argA[i]
      local ss = mrc:resolve(mpathA, s)
      if (ss ~= s) then
         searchA[i] = ss:escape()
      else
         searchA[i] = s:caseIndependent()
      end
   end
   searchA.n = argA.n
   return searchA
end

function M.overview(self,argA)
   dbg.start{"Hub:overview(",concatTbl(argA,", "),")"}
   local aa          = {}
   local optionTbl   = optionTbl()
   local mt          = FrameStk:singleton():mt()
   local mpathA      = mt:modulePathA()
   local availStyle  = optionTbl.availStyle
   local mrc         = MRC:singleton()

   mrc:set_display_mode("avail")

   local numDirs = 0
   for i = 1,#mpathA do
      local mpath = mpathA[i]
      if (isDir(mpath)) then
         numDirs = numDirs + 1
      end
   end

   if (numDirs < 1) then
      if (optionTbl.terse) then
         dbg.fini("Hub:overview")
         return a
      end
      LmodError{msg="e_Avail_No_MPATH", name="overview"}
      return a
   end



   local use_cache   = false
   local moduleA     = ModuleA:singleton{spider_cache=use_cache}
   local availA      = moduleA:build_availA()
   local twidth      = TermWidth()
   local cwidth      = optionTbl.rt and LMOD_COLUMN_TABLE_WIDTH or twidth
   local defaultT    = moduleA:defaultT()
   local searchA     = argA
   local showSN      = true
   local defaultOnly = false
   local banner      = Banner:singleton()

   if (not optionTbl.regexp and argA and next(argA) ~= nil) then
      searchA = l_build_searchA(mrc, mpathA, argA)
   end

   availA = regroup_avail_blocks(availStyle, availA)
   local showModuleExt = false

   self:terse_avail(mpathA, availA, searchA, showSN, defaultOnly, defaultT, showModuleExt, aa)

   local label    = ""
   local a        = {}
   local b        = {}
   local sn       = false
   local sn_slash = false
   local count    = 0

   local function print_overview_block()
      -- Write this block of overview
      dbg.print{"printing overview block\n"}
      local ct = ColumnTable:new{tbl=b, gap=1, len = length, width = cwidth}
      a[#a+1] = "\n"
      a[#a+1] = banner:bannerStr(label)
      a[#a+1] = "\n"
      a[#a+1] = ct:build_tbl()
      a[#a+1] = "\n"
      b       = {}
   end

   ---------------------------------------------------------------
   -- This local function stores the current sn and count into the
   -- b array and if the current entry is true then define the next
   -- sn to be entry (minus the trailing slash) and zero count.
   local function register_sn_count_in_b(entry)
      if (sn and count > 0) then
         b[#b+1] = { sn, "(" .. tostring(count) .. ")  "}
      end
      if (entry) then
         sn_slash = entry:escape()
         sn       = entry:sub(1,-2) --> strip trailing slash
         count    = 0
      else
         sn       = false
         sn_slash = false
      end
   end

   for i = 1,#aa do
      local entry = aa[i]:gsub("%s+$",""):gsub(" *<.*","") --> strip trailing newline and any decorations
      repeat
         dbg.print{"RTM: entry: \"",entry,"\"\n"}
         if (entry:find("%(@")) then
            break
         end
         if (entry:find(":$")) then
            register_sn_count_in_b(false)
            if (next(b) ~= nil) then
               print_overview_block()
            end
            label    = entry:sub(1,-2) -- strip trailing colon
            dbg.print{"found label: ",label,"\n"}
            break
         end

         if (entry:find("/$")) then
            register_sn_count_in_b(entry)
            dbg.print{"found sn:", sn,"\n"}
            break
         end
         if (sn_slash and entry:find(sn_slash)) then
            dbg.print{"found another entry: ", entry, " for sn: ",sn,"\n"}
            count = count + 1
            break
         end
         register_sn_count_in_b(false)
         dbg.print{"found meta module: ", entry, "\n"}
         b[#b+1] = { entry, "(1)  "}
      until(true)
   end

   register_sn_count_in_b(false)
   if (next(b) ~= nil) then
      print_overview_block()
   end
   a = hook.apply("msgHook", "overview", a) or a

   dbg.fini("Hub:overview")
   return a
end

function M.buildExtA(self, searchA, mpathA, providedByT, extA)
    dbg.start{"Hub:buildExtA()"}

    local mpathT = {}
    for i = 1, #mpathA do
       mpathT[mpathA[i]] = true
    end

    dbg.printT("mpathT",mpathT)
    dbg.printT("providedByT",providedByT)

    for k,v in pairsByKeys(providedByT) do
       local found = false
       if (searchA.n > 0) then
          for i = 1, searchA.n do
             for kk,vv in pairs(v) do
                local s        = searchA[i]
                for i = 1,#vv do
                   local vvv = vv[i]
                   if (kk:find(s) and mpathT[vvv.mpath] and (not vvv.hidden)) then
                      found = true
                      break
                   end
                end
                if (found) then break end
             end
             if (found) then break end
          end
       else
          for kk,vv in pairs(v) do
             for i = 1,#vv do
                local vvv = vv[i]
                if (mpathT[vvv.mpath] and (not vvv.hidden)) then
                   found = true
                   break
                end
             end
             if (found) then break end
          end
       end
       if (found) then
          extA[#extA + 1] = {"    " .. colorize("blue",k),"(E)"}
       end
    end

    dbg.fini("Hub:buildExtA()")
end

function M.terse_avail(self, mpathA, availA, searchA, showSN, defaultOnly, defaultT, showModuleExt, a)
   dbg.start{"Hub:terse_avail()"}
   local mrc         = MRC:singleton()
   local optionTbl   = optionTbl()

   if (searchA.n > 0) then
      for k, v in mrc:pairsForMRC_aliases(mpathA) do
         local fullName = mrc:resolve(mpathA, v)
         for i = 1, searchA.n do
            local s = searchA[i]
            if (fullName:find(s) or k:find(s)) then
               a[#a+1] = k.."(@" .. fullName ..")\n"
            end
         end
      end
   else
      for k, v in mrc:pairsForMRC_aliases(mpathA) do
         local fullName = mrc:resolve(mpathA, v)
         a[#a+1] = k.."(@" .. fullName ..")\n"
      end
   end


   dbg.printT("availA",availA)

   for j = 1,#availA do
      local A      = availA[j].A
      local mpath  = availA[j].mpath
      local label  = mpath
      local aa     = {}
      local prtSnT = {}  -- Mark if we have printed the sn?

      for i = 1,#A do
         local sn, fullName, fn, provideA = l_availEntry(defaultOnly, label, searchA, defaultT, A[i])
         local entry  = A[i]
         if (sn) then
            if (not prtSnT[sn] and sn ~= fullName and showSN) then
               prtSnT[sn] = true
               aa[#aa+1]  = sn .. "/\n"
            end
            local aliasA = mrc:search_mapT("full2aliasesT", mpath, fullName)
            if (aliasA) then
               for i = 1,#aliasA do
                  local fullName = mrc:resolve(mpathA, aliasA[i])
                  aa[#aa+1]  = aliasA[i] .. "(@".. fullName ..")\n"
               end
            end
            aa[#aa+1]  = decorateModule(fullName, entry, entry.forbiddenT) .. "\n"

            if (showModuleExt and provideA and next(provideA) ~= nil ) then
               for k = 1,#provideA do
                  aa[#aa+1] = "#    " .. provideA[k] .. "\n"
               end
            end
         end
      end
      if (next(aa) ~= nil) then
         a[#a+1]  = label .. ":\n"
         for i = 1,#aa do
            a[#a+1] = aa[i]
         end
      end
   end
   dbg.fini("Hub:terse_avail")
   return a
end


function M.avail(self, argA)
   dbg.start{"Hub:avail(",concatTbl(argA,", "),")"}
   local a           = {}
   local optionTbl   = optionTbl()
   local mt          = FrameStk:singleton():mt()
   local mpathA      = mt:modulePathA()
   local availStyle  = optionTbl.availStyle
   local mrc         = MRC:singleton()

   mrc:set_display_mode("avail")

   local numDirs = 0
   for i = 1,#mpathA do
      local mpath = mpathA[i]
      if (isDir(mpath)) then
         numDirs = numDirs + 1
      end
   end

   if (numDirs < 1) then
      if (optionTbl.terse) then
         dbg.fini("Hub:avail")
         return a
      end
      LmodError{msg="e_Avail_No_MPATH",name = "avail"}
      return a
   end

   local extensions    = cosmic:value("LMOD_AVAIL_EXTENSIONS") == "yes"
   local use_cache     = (not optionTbl.terse) or (cosmic:value("LMOD_CACHED_LOADS") ~= "no")
   local moduleA       = ModuleA:singleton{spider_cache=use_cache}
   local isNVV         = moduleA:isNVV()
   local availA        = moduleA:build_availA()
   local twidth        = TermWidth()
   local cwidth        = optionTbl.rt and LMOD_COLUMN_TABLE_WIDTH or twidth
   local defaultT      = moduleA:defaultT()
   local searchA       = argA
   local defaultOnly   = optionTbl.defaultOnly
   local showSN        = not defaultOnly



   dbg.printT("availA",availA)

   if (showSN) then
      showSN = argA.n == 0
   end

   dbg.print{"defaultOnly: ",defaultOnly,"\n"}

   dbg.printT("defaultT:",defaultT)


   if (not optionTbl.regexp and argA and next(argA) ~= nil) then
      searchA = l_build_searchA(mrc, mpathA, argA)
   end

   if (optionTbl.terse or optionTbl.terseShowExtensions) then
      --------------------------------------------------
      -- Terse output
      self:terse_avail(mpathA, availA, searchA, showSN, defaultOnly,
                       defaultT, optionTbl.terseShowExtensions, a)

      dbg.fini("Hub:avail")
      return a
   end

   availA = regroup_avail_blocks(availStyle, availA)

   local banner   = Banner:singleton()
   local legendT  = {}
   local Default  = 'D'
   local numFound = 0
   local na       = "N/A"
   local pna      = "("..na..")"

   local fndAlias = false
   local b        = {}
   local bb       = {}
   if (searchA.n > 0) then
      for k, v in mrc:pairsForMRC_aliases(mpathA) do
         local fullName = mrc:resolve(mpathA,v)
         for i = 1, searchA.n do
            local s = searchA[i]
            if (fullName:find(s) or k:find(s)) then
               local mname    = MName:new("load",k)
               fullName = mname:fullName() or pna
               if (fullName == pna) then
                  legendT[na] = i18n("m_Global_Alias_na")
               end
               fndAlias = true
               b[#b+1]  = { "   " .. k, "->", fullName}
               break
            end
         end
      end
   else
      for k, v in mrc:pairsForMRC_aliases(mpathA) do
         local mname    = MName:new("load",k)
         local fullName = mname:fullName() or pna
         if (fullName == pna) then
            legendT[na] = i18n("m_Global_Alias_na")
         end
         fndAlias = true
         b[#b+1]  = { "   " .. k, "->", fullName}
      end
   end
   if (fndAlias) then
      local ct = ColumnTable:new{tbl=b, gap=1, len=length, width = cwidth}
      a[#a+1]  = "\n"
      a[#a+1] = banner:bannerStr("Global Aliases")
      a[#a+1] = "\n"
      a[#a+1]  = ct:build_tbl()
      a[#a+1] = "\n"
   end


   for k = 1,#availA do
      local A = availA[k].A
      local mpath = availA[k].mpath
      local label = mpath
      if (next(A) ~= nil) then
         local b = {}
         for j = 1,#A do
            local entry = A[j]
            local sn, fullName, fn = l_availEntry(defaultOnly, label, searchA, defaultT, entry)
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
               local resultA = colorizePropA("short", mt,
                                             {sn=sn, fullName=fullName, fn=fn, mpath = mpath },
                                             mrc, entry.propT, legendT, entry.forbiddenT)
               c[#c+1] = '  '
               for i = 1,#resultA do
                  c[#c+1] = resultA[i]
               end

               local propStr = c[3] or ""
               local verMapStr = mrc:search_mapT("mod2versionT", mpath, fullName)
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
            a[#a+1] = ct:build_tbl()
            a[#a+1] = "\n"
         end
      end
   end

   local cache                  = Cache:singleton{buildCache=true}
   local spiderT,dbT,
         mpathMapT, providedByT = cache:build()

   dbg.printT("providedByT", providedByT)

   if (extensions and providedByT and next(providedByT) ~= nil) then
      local extA = {}
      self:buildExtA(searchA, mpathA, providedByT, extA)

      if (next(extA) ~= nil) then
         legendT['E'] = i18n("Extension")
         numFound = numFound + #extA
         local ct = ColumnTable:new{tbl=extA, gap=1, len = length, width = cwidth}
         a[#a+1] = "\n"
         a[#a+1] = banner:bannerStr(i18n("m_Extensions_head"))
         a[#a+1] = "\n"
         a[#a+1] = ct:build_tbl()
         a[#a+1] = "\n"
         a[#a+1] = i18n("m_Extensions_tail")
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


   if (not quiet()) then
      if (isNVV) then
         a[#a+1] = "\n"
         a[#a+1] = i18n("m_IsNVV");
      end
      a = hook.apply("msgHook", "avail", a) or a
   end

   dbg.fini("Hub:avail")
   return a
end

return M
