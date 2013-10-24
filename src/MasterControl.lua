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
--  MasterControl is the base class for all the MC_Load, MC_Unload derived
--  classes.  It has the Factory build member function as well as the
--  functions that execute the commands from the modulefiles.  It may be
--  helpful to understand the flow of control:

--  0) An MCP object is constructed (load, unload, show, help, etc)
--  1) A modulefile is read and evaluated.
--  2) A function in modfuncs is called.
--  3) These modfuncs call a member function of the mcp object.
--  4) All these member functions are implemented here.

--  So for example if the mcp object is a load version then
--  when a modulefile calls setenv then the steps are:
--  a) setenv(...) is called in modfuncs
--  b) This calls mcp:setenv(...)
--  c) the mcp load version connects it to MasterControl:setenv

--  Suppose a user is requesting to unload a module which contains a
--  setenv command.
--  0) An MCP unload object is constructed.
--  1) The module file is read and evaluated
--  2) The setenv function in modfuncs is called
--  3) The unload MCP objects maps this to MasterControl:unsetenv
--  4) The users' environment variable is unset.
--------------------------------------------------------------------------

-- MasterControl
require("strict")
require("TermWidth")
require("inherits")
require("utils")

local M            = {}
local BeautifulTbl = require("BeautifulTbl")
local dbg          = require("Dbg"):dbg()
local Exec         = require("Exec")
local MName        = require("MName")
local ModuleStack  = require("ModuleStack")
local Var          = require("Var")
local base64       = require("base64")
local concatTbl    = table.concat
local decode64     = base64.decode64
local encode64     = base64.encode64
local getenv       = os.getenv
local pack         = (_VERSION == "Lua 5.1") and argsPack or table.pack

------------------------------------------------------------------------
--module ('MasterControl')
------------------------------------------------------------------------

local function mustLoad(mA)
   local aa = {}
   local bb = {}

   local mt = MT:mt()
   for i = 1, #mA do
      local mname = mA[i]
      local sn    = mname:sn()
      if (not mt:have(sn, "active")) then
         aa[#aa+1] = mname:show()
         bb[#bb+1] = mname:usrName()
      end
   end

   if (#aa > 0) then
      local s = concatTbl(aa, ", ")
      mcp:report("Did not find: ",s,"\n\n",
                 "Try: \"module spider ", concatTbl(bb," "),"\"\n" )
   end
end


function M.name(self)
   return self.my_name
end


local function valid_name(nameTbl, name)
   if (not nameTbl[name]) then
      return nameTbl.default
   end
   return nameTbl[name]
end

function M.build(name,mode)

   local nameTbl          = {}
   local MCLoad           = require('MC_Load')
   local MCUnload         = require('MC_Unload')
   local MCRefresh        = require('MC_Refresh')
   local MCShow           = require('MC_Show')
   local MCAccess         = require('MC_Access')
   local MCSpider         = require('MC_Spider')
   local MCComputeHash    = require('MC_ComputeHash')
   nameTbl["load"]        = MCLoad
   nameTbl["unload"]      = MCUnload
   nameTbl["refresh"]     = MCRefresh
   nameTbl["show"]        = MCShow
   nameTbl["access"]      = MCAccess
   nameTbl["spider"]      = MCSpider
   nameTbl["computeHash"] = MCComputeHash
   nameTbl.default        = MCLoad

   local o                = valid_name(nameTbl, name):create()
   o:_setMode(mode or name)

   dbg.print("Setting mcp to ", o:name(),"\n")
   return o
end

-------------------------------------------------------------------
-- Load / Unload functions
-------------------------------------------------------------------
function M.load_usr(self, mA)
   local a = self:load(mA)
   if (haveWarnings()) then
      mustLoad(mA)
   end
   return a
end
function M.load(self, mA)
   local master = Master:master()
   local mStack = ModuleStack:moduleStack()

   if (dbg.active()) then
      local a = {}
      for i = 1, #mA do
         a[#a + 1] = mA[i]:usrName()
      end
      local s = concatTbl(a, ", ")
      dbg.start("MasterControl:load(mA={"..s.."})")
   end
   mStack:loading()

   local a = master.load(mA)
   if (not expert()) then

      local mt      = MT:mt()
      local t       = {}
      readAdmin()
      for i = 1, #mA do
         local mname      = mA[i]
         local sn         = mname:sn()
         if (mt:have(sn,"active")) then
            local moduleFn  = mt:fileName(sn)
            local modFullNm = mt:fullName(sn)
            local message
            local key
            if (adminT[moduleFn]) then
               message = adminT[moduleFn]
               key     = moduleFn
            elseif (adminT[modFullNm]) then
               message = adminT[modFullNm]
               key     = modFullNm
            end

            if (message) then
               t[key] = message
            end
         end
      end

      if (next(t)) then
         local term_width  = TermWidth()
         if (term_width < 40) then
            term_width = 80
         end
         local bt
         local a       = {}
         local border  = string.rep("-", term_width-1)
         io.stderr:write("\n",border,"\n","Module(s):\n",border,"\n")
         for k, v in pairs(t) do
            io.stderr:write("\n",k," :\n")
            a[1] = { " ", v}
            bt = BeautifulTbl:new{tbl=a, wrapped=true, column=term_width-1}
            io.stderr:write(bt:build_tbl(), "\n")
         end
         io.stderr:write(border,"\n\n")
      end
   end

   dbg.fini("MasterControl:load")
   return a
end

function M.try_load(self, mA)
   dbg.start("MasterControl:try_load(mA)")
   deactivateWarning()
   self:load(mA)
   dbg.fini("MasterControl:try_load")
end

function M.unload(self, mA)
   dbg.start("MasterControl:unload(mA)")
   local master = Master:master()
   local mStack = ModuleStack:moduleStack()
   local mt     = MT:mt()

   mStack:loading()
   local aa     = master.unload(mA)



   dbg.fini("MasterControl:unload")
   return aa
end

function M.unload_usr(self, mA)
   dbg.start("MasterControl:unload_usr(mA)")

   self:unload(mA)
   local master = Master:master()
   local aa = master:reload_sticky()
   dbg.fini("MasterControl:unload_usr")
   return aa
end


function M.bad_unload(self,mA)
   local a   = {}

   dbg.start("MasterControl.bad_unload(mA)")

   LmodWarning("Stubbornly refusing to unload module(s) during an unload\n")

   dbg.fini("MasterControl.bad_unload")
end


-------------------------------------------------------------------
-- Path Modification Functions
-------------------------------------------------------------------
LMOD_MP_T = {}

LMOD_MP_T[ModulePath]  = true
LMOD_MP_T[DfltModPath] = true


function M.prepend_path(self, name, value, sep, nodups)
   dbg.start("MasterControl:prepend_path(\"",name,"\", \"",value,"\",\"",sep,"\")")
   local mStack = ModuleStack:moduleStack()
   sep          = sep or ":"

   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name, nil, sep)
   end

   nodups = LMOD_MP_T[name]  -- Do not allow dups on MODULEPATH like env vars.

   varTbl[name]:prepend(tostring(value), nodups)
   mStack:setting()
   dbg.fini("MasterControl:prepend_path")
end

function M.append_path(self, name, value, sep, nodups)
   local mStack = ModuleStack:moduleStack()
   dbg.start("MasterControl:append_path(\"",name,"\", \"",value,"\",\"",sep,"\")")
   sep          = sep or ":"

   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name, nil, sep)
   end
   varTbl[name]:append(tostring(value), nodups)
   mStack:setting()
   dbg.fini("MasterControl:append_path")
end

function M.remove_path(self, name, value, sep, where)
   local mStack = ModuleStack:moduleStack()
   sep          = sep or ":"
   dbg.start("MasterControl:remove_path(\"",name,"\", \"",value,"\",\"",
             sep,"\", \"",where,"\")")
   mStack:setting()

   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name,nil, sep)
   end
   varTbl[name]:remove(tostring(value), where)
   dbg.fini("MasterControl:remove_path")
end

function M.remove_path_first(self, name, value, sep)
   M.remove_path(self, name, value, sep, "first")
end

function M.remove_path_last(self, name, value, sep)
   M.remove_path(self, name, value, sep, "last")
end


function M.bad_remove_path(self, name,value)
   LmodWarning("Refusing remove a path element variable while unloading: \"",name,"\"\n")
end

-------------------------------------------------------------------
-- Setenv / Unsetenv Functions
-------------------------------------------------------------------

function M.setenv(self, name, value, respect)
   local mStack = ModuleStack:moduleStack()
   dbg.start("MasterControl:setenv(\"",name,"\", \"",value,"\", \"",
              respect,")")
   
   if (respect and getenv(name)) then
      dbg.print("Respecting old value")
      dbg.fini("MasterControl:setenv")
      return
   end


   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name)
   end
   varTbl[name]:set(tostring(value))
   mStack:setting()
   dbg.fini("MasterControl:setenv")
end

function M.unsetenv(self, name, value, respect)
   local mStack = ModuleStack:moduleStack()
   dbg.start("MasterControl:unsetenv(\"",name,"\", \"",value,"\")")

   if (respect and getenv(name) ~= value) then
      dbg.print("Respecting old value")
      dbg.fini("MasterControl:unsetenv")
      return
   end
      
   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name)
   end
   varTbl[name]:unset()
   mStack:setting()
   dbg.fini("MasterControl:unsetenv")
end

function M.bad_unsetenv(self, name, value)
   LmodWarning("Refusing unsetenv variable while unloading: \"",name,"\"\n")
end

-------------------------------------------------------------------
-- stack: push and pop
-------------------------------------------------------------------

function M.pushenv(self, name, value)
   local mStack = ModuleStack:moduleStack()
   dbg.start("MasterControl:pushenv(\"",name,"\", \"",value,"\")")

   ----------------------------------------------------------------
   -- If name exists in the env and the stack version of the name
   -- doesn't exist then use the name's value as the initial value
   -- for "stackName".

   local stackName = "__LMOD_STACK_" .. name
   local v64       = nil
   local v         = getenv(name)
   if (getenv(stackName) == nil and v) then
      v64          = encode64(v)
   end


   if (varTbl[stackName] == nil) then
      varTbl[stackName] = Var:new(stackName, v64, ":")
   end


   v   = tostring(value)
   v64 = encode64(value)

   varTbl[stackName]:prepend(v64)

   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name)
   end
   varTbl[name]:set(v)

   mStack:setting()
   dbg.fini("MasterControl:pushenv")
end

function M.popenv(self, name, value)
   local mStack = ModuleStack:moduleStack()
   dbg.start("MasterControl:popenv(\"",name,"\", \"",value,"\")")

   local stackName = "__LMOD_STACK_" .. name

   local v = nil

   if (varTbl[stackName] == nil) then
      varTbl[stackName] = Var:new(stackName)
   end

   dbg.print("stackName: ", stackName, " pop()\n")
   local v64 = varTbl[stackName]:pop()
   local v   = nil
   if (v64) then
      v = decode64(v64)
   end
   dbg.print("v: ", v,"\n")

   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name)
   end

   varTbl[name]:set(v)

   mStack:setting()
   dbg.fini("MasterControl:popenv")
end


-------------------------------------------------------------------
-- Alias Functions
-------------------------------------------------------------------

function M.set_alias(self, name, value)
   local mStack = ModuleStack:moduleStack()
   dbg.start("MasterControl:set_alias(\"",name,"\", \"",value,"\")")


   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name)
   end
   varTbl[name]:setAlias(value)
   mStack:setting()
   dbg.fini("MasterControl:set_alias")
end

function M.unset_alias(self, name, value)
   local mStack = ModuleStack:moduleStack()
   dbg.start("MasterControl:unset_alias(\"",name,"\", \"",value,"\")")

   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name)
   end
   varTbl[name]:unsetAlias(value)
   mStack:setting()
   dbg.fini("MasterControl:unset_alias")
end

function M.bad_unset_alias(self, name)
   LmodWarning("Refusing unset an alias while unloading: \"",name,"\"\n")
end

-------------------------------------------------------------------
-- Shell Routine Functions
-------------------------------------------------------------------

function M.set_shell_function(self, name, bash_function, csh_function)
   local mStack = ModuleStack:moduleStack()
   dbg.start("MasterControl:set_shell_function(\"",name,"\", \"",bash_function,"\")",
             "\", \"",csh_function,"\")")


   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name)
   end
   varTbl[name]:setShellFunction(bash_function, csh_function)
   mStack:setting()
   dbg.fini("MasterControl:set_shell_function")
end

function M.unset_shell_function(self, name, bash_function, csh_function)
   local mStack = ModuleStack:moduleStack()
   dbg.start("MasterControl:unset_shell_function(\"",name,"\", \"",bash_function,"\")",
             "\", \"",csh_function,"\")")

   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name)
   end
   varTbl[name]:unsetShellFunction()
   mStack:setting()
   dbg.fini("MasterControl:unset_shell_function")
end

function M.bad_unset_shell_function(self, name, bash_function, csh_function)
   LmodWarning("Refusing unset a shell function while unloading: \"",name,"\"\n")
end

-------------------------------------------------------------------
-- Property Functions
-------------------------------------------------------------------

function M.add_property(self, name, value)
   dbg.start("MasterControl:add_property(\"",name,"\", \"",value,"\")")
   local mStack  = ModuleStack:moduleStack()
   local mFull   = mStack:fullName()
   local mt      = MT:mt()
   local mname   = MName:new("load",mFull)
   mStack:setting()
   mt:add_property(mname:sn(), name, value)
   dbg.fini("MasterControl:add_property")
end

function M.remove_property(self, name, value)
   dbg.start("MasterControl:remove_property(\"",name,"\", \"",value,"\")")
   local mStack  = ModuleStack:moduleStack()
   local mFull   = mStack:fullName()
   local mt      = MT:mt()
   local mname   = MName:new("mt",mFull)
   mStack:setting()
   mt:remove_property(mname:sn(), name, value)
   dbg.fini("MasterControl:remove_property")
end

function M.bad_remove_property(self, name, value)
   LmodWarning("Refusing to remove a property while unloading: \"",name,"\"\n")
end

-------------------------------------------------------------------
-- Message/Error  Functions
-------------------------------------------------------------------

local function moduleStackTraceBack()
   local mStack = ModuleStack:moduleStack()
   if (mStack:empty()) then return end

   local aa = {}
   aa[1] = { "Module fullname", "Module Filename"}
   aa[2] = { "---------------", "---------------"}

   while (not mStack:empty()) do
      aa[#aa+1] = {mStack:fullName(), mStack:fileName()}
      mStack:pop()
   end

   local bt = BeautifulTbl:new{tbl=aa}
   io.stderr:write("\n","While processing the following module(s):\n\n",
                   bt:build_tbl(),"\n")
end

local function msg(lead, ...)
   local twidth = TermWidth()
   local arg = { n = select('#', ...), ...}
   io.stderr:write("\n")
   arg[1] = lead .. arg[1]
   local whole = concatTbl(arg,"")
   for s in whole:split("\n") do
      io.stderr:write(fillWords("",s, twidth),"\n")
   end
   io.stderr:write("\n")
   moduleStackTraceBack()
end

function LmodErrorExit()
   io.stdout:write("false\n")
   os.exit(1)
end

function LmodSystemError(...)
   io.stderr:write("\n", colorize("red", "Lmod has detected the following error: "))
   local arg = pack(...)
   for i = 1, arg.n do
      io.stderr:write(tostring(arg[i]))
   end
   io.stderr:write("\n")
   moduleStackTraceBack()
   LmodErrorExit()
end


function M.error(self, ...)
   LmodSystemError(...)
end

function M.warning(self, ...)
   if (not expert() and  haveWarnings()) then
      io.stderr:write("\n",colorize("red", "Lmod Warning: "))
      local arg = pack(...)
      for i = 1, arg.n do
         io.stderr:write(tostring(arg[i]))
      end
      io.stderr:write("\n")
      moduleStackTraceBack()
      setWarningFlag()
   end
end


function M.message(self, ...)
   local arg = pack(...)
   for i = 1, arg.n do
      io.stderr:write(tostring(arg[i]))
   end
   io.stderr:write("\n")
end


-------------------------------------------------------------------
-- Misc Functions
-------------------------------------------------------------------

function M.prereq(self, mA)
   local mt        = MT:mt()
   local a         = {}
   local mStack    = ModuleStack:moduleStack()
   local mFull     = mStack:fullName()
   local masterTbl = masterTbl()

   mStack:setting()
   dbg.start("MasterControl:prereq(mA)")

   if (masterTbl.checkSyntax) then
      dbg.print("Ignoring prereq when syntax checking\n")
      dbg.fini("MasterControl:prereq")
      return
   end

   local a = {}
   for i = 1, #mA do
      local v = mA[i]:prereq()
      if (v) then
         a[#a+1] = v
      end
   end

   dbg.print("number found: ",#a,"\n")
   if (#a > 0) then
      local s = concatTbl(a,", ")
      LmodError("Cannot load module \"",mFull,"\" without these modules loaded:\n  ",
            s,"\n")
   end
   dbg.fini("MasterControl:prereq")
end

function M.conflict(self, mA)
   dbg.start("MasterControl:conflict(mA)")


   local mt        = MT:mt()
   local a         = {}
   local mStack    = ModuleStack:moduleStack()
   local mFull     = mStack:fullName()
   local masterTbl = masterTbl()
   mStack:setting()

   if (masterTbl.checkSyntax) then
      dbg.print("Ignoring conflicts when syntax checking\n")
      dbg.fini("MasterControl:conflict")
      return
   end

   local a = {}
   for i = 1, #mA do
      local mname   = mA[i]
      local v       = mname:usrName()
      local sn      = mname:sn()
      local version = extractVersion(v, sn)
      local found   = false
      if (version) then
         found = mt:fullName(sn) == mname:usrName()
      else
         found = mt:have(sn,"active")
      end
      if (found) then
         a[#a+1] = v
      end
   end
   if (#a > 0) then
      local s = concatTbl(a," ")
      LmodError("Cannot load module \"",mFull,"\" because these modules are loaded:\n  ",
            s,"\n")
   end
   dbg.fini("MasterControl:conflict")
end

function M.prereq_any(self, mA)
   local mt        = MT:mt()
   local a         = {}
   local mStack    = ModuleStack:moduleStack()
   local mFull     = mStack:fullName()
   local masterTbl = masterTbl()
   mStack:setting()

   dbg.start("MasterControl:prereq_any(mA)")

   if (masterTbl.checkSyntax) then
      dbg.print("Ignoring prereq_any when syntax checking\n")
      dbg.fini("MasterControl:prereq_any")
      return
   end

   local found  = false
   local a      = {}
   for i = 1, #mA do
      local v,msg = mA[i]:prereq()
      if (not v) then
         found = true
         break
      end
      if (msg) then
         a[#a+1] = msg .."(\"" .. v .. "\")"
      else
         a[#a+1] = v
      end
   end

   if (not found) then
      local s = concatTbl(a," ")
      LmodError("Cannot load module \"",mFull,"\".  At least one of these modules must be loaded:\n  ",
            concatTbl(a,", "),"\n")
   end
   dbg.fini("MasterControl:prereq_any")
end



function M.family(self, name)
   local mt        = MT:mt()
   local mStack    = ModuleStack:moduleStack()
   local mFull     = mStack:fullName()
   local mname     = MName:new("mt",mFull)
   local sn        = mname:sn()
   local masterTbl = masterTbl()
   mStack:setting()

   dbg.start("MasterControl:family(",name,")")
   if (masterTbl.checkSyntax) then
      dbg.print("Ignoring family when syntax checking\n")
      dbg.fini()
      return
   end

   dbg.print("mt:setfamily(\"",name,"\",\"",sn,"\")\n")
   local oldName = mt:setfamily(name,sn)
   if (oldName ~= nil and oldName ~= sn and not expert() ) then
      LmodError("You can only have one ",name," module loaded at a time.\n",
                "You already have ", oldName," loaded.\n",
                "To correct the situation, please enter the following command:\n\n",
                "  module swap ",oldName, " ", mFull,"\n\n",
                "Please submit a consulting ticket if you require additional assistance.\n")
   end
   dbg.fini("MasterControl:family")
end

function M.myShellName(self)
   local master = _G.Master:master()
   return master.shell:name()
end

function M.myFileName(self)
   local mStack = ModuleStack:moduleStack()
   return mStack:fileName()
end

function M.myModuleFullName(self)
   local mStack = ModuleStack:moduleStack()
   return mStack:fullName()
end

function M.myModuleUsrName(self)
   local mStack = ModuleStack:moduleStack()
   return mStack:usrName()
end

function M.myModuleName(self)
   local mStack = ModuleStack:moduleStack()
   return mStack:sn()
end

function M.myModuleVersion(self)
   local mStack = ModuleStack:moduleStack()
   return mStack:version()
end

function M.unset_family(self, name)
   local mt     = MT:mt()

   dbg.start("MasterControl:unset_family(",name,")")
   dbg.print("mt:unsetfamily(\"",name,"\")\n")
   mt:unsetfamily(name)
   dbg.fini("MasterControl:unset_family")
end

function M.inherit(self)
   local master = Master:master()
   local mStack = ModuleStack:moduleStack()
   mStack:setting()
   dbg.start("MasterControl:inherit()")

   master.inheritModule()
   dbg.fini("MasterControl:inherit")
end

function M.is_spider(self)
   dbg.start("MasterControl:is_spider()")
   dbg.fini("MasterControl:is_spider")
   return false
end

function M._setMode(self, mode)
   dbg.start("MasterControl:_setMode(\"",mode,"\")")
   self._mode = mode
   dbg.fini("MasterControl:_setMode")
end

function M.mode(self)
   dbg.start("MasterControl:mode()")
   dbg.print("mode: ", self._mode,"\n")
   dbg.fini("MasterControl:mode")
   return self._mode
end

--------------------------------------------------------------------------
-- MasterControl:execute() - place a string that will be executed when
--                           the output from Lmod eval'ed.  Note this command
--                           makes the module a worker-bee module and not a
--                           manager module.

function M.execute(self, t)
   dbg.start("MasterControl:execute(t)")
   local mStack = ModuleStack:moduleStack()
   mStack:setting()
   local a      = t.modeA or {}
   local myMode = self:mode()

   for i = 1,#a do
      if (myMode == a[i] or a[i]:lower() == "all" ) then
         local exec   = Exec:exec()
         exec:register(t.cmd)
         break
      end
   end
   dbg.fini("MasterControl:execute")
end   


-------------------------------------------------------------------
-- Quiet Functions
-------------------------------------------------------------------


function M.quiet(self, ...)
   -- very Quiet !!!
end

return M
