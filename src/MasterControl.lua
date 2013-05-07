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

local M            = {}
local BeautifulTbl = require("BeautifulTbl")
local Dbg          = require("Dbg")
local MName        = require("MName")
local ModuleStack  = require("ModuleStack")
local Var          = require("Var")
local concatTbl    = table.concat
local format       = string.format
local getenv       = os.getenv
local print	   = print
local setmetatable = setmetatable
local type	   = type

------------------------------------------------------------------------
--module ('MasterControl')
------------------------------------------------------------------------

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

   local dbg              = Dbg:dbg()
   dbg.print("Setting mcp to ", o:name(),"\n")
   return o
end

-------------------------------------------------------------------
-- Load / Unload functions
-------------------------------------------------------------------

function M.load(self, ...)
   local master = Master:master()
   local dbg    = Dbg:dbg()
   local mStack = ModuleStack:moduleStack()

   dbg.start("MasterControl:load(",concatTbl({...},", "),")")
   mStack:loading()

   local a = master.load(...)

   if (not expert()) then

      local mt      = MT:mt()
      local t       = {}
      readAdmin()
      for _, moduleName in ipairs{...} do
         local mname = MName:new("load",moduleName)
         local sn    = mname:sn()
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

   dbg.fini()
   return a
end

function M.try_load(self, ...)
   local dbg = Dbg:dbg()
   dbg.start("MasterControl:try_load(",concatTbl({...},", "),")")
   deactivateWarning()
   self:load(...)
   dbg.fini()
end

function M.unload(self, ...)
   local master = Master:master()
   local mStack = ModuleStack:moduleStack()
   local dbg    = Dbg:dbg()
   local mt     = MT:mt()
   dbg.start("MasterControl:unload(", concatTbl({...},", "),")")

   mStack:loading()

   local aa     = master.unload(...)

   dbg.fini()
   return aa
end

   
function M.unloadsys(self, ...)
   local master = Master:master()
   local mStack = ModuleStack:moduleStack()
   local dbg    = Dbg:dbg()
   local mt     = MT:mt()
   local a      = {}

   dbg.start("MasterControl.unloadsys(",concatTbl({...},", "),")")
   mStack:loading()
   a      = master.unload(...)
   dbg.fini()
   return a
end

function M.bad_unload(self,...)
   local dbg = Dbg:dbg()
   local a   = {}

   dbg.start("MasterControl.bad_unload()")

   LmodWarning("Stubbornly refusing to unload module(s): \"",
               concatTbl({...},"\", \""),"\"",
               "\n   during an unload\n")

   dbg.fini()
end


-------------------------------------------------------------------
-- Path Modification Functions
-------------------------------------------------------------------
LMOD_MP_T = {}

LMOD_MP_T[ModulePath]  = true
LMOD_MP_T[DfltModPath] = true


function M.prepend_path(self, name, value, sep, nodups)
   local mStack = ModuleStack:moduleStack()
   local dbg    = Dbg:dbg()
   dbg.start("MasterControl:prepend_path(\"",name,"\", \"",value,"\",\"",sep,"\")")
   sep          = sep or ":"

   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name, nil, sep)
   end

   nodups = LMOD_MP_T[name]  -- Do not allow dups on MODULEPATH like env vars.

   varTbl[name]:prepend(tostring(value), nodups)
   mStack:setting()
   dbg.fini()
end

function M.append_path(self, name, value, sep, nodups)
   local mStack = ModuleStack:moduleStack()
   local dbg    = Dbg:dbg()
   dbg.start("MasterControl:append_path(\"",name,"\", \"",value,"\",\"",sep,"\")")
   sep          = sep or ":"

   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name, nil, sep)
   end
   varTbl[name]:append(tostring(value), nodups)
   mStack:setting()
   dbg.fini()
end

function M.remove_path(self, name, value, sep, where)
   local mStack = ModuleStack:moduleStack()
   sep          = sep or ":"
   local dbg    = Dbg:dbg()
   dbg.start("MasterControl:remove_path(\"",name,"\", \"",value,"\",\"",
             sep,"\", \"",where,"\")")
   mStack:setting()

   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name,nil, sep)
   end
   varTbl[name]:remove(tostring(value), where)
   dbg.fini()
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

function M.setenv(self, name, value)
   local mStack = ModuleStack:moduleStack()
   local dbg    = Dbg:dbg()
   dbg.start("MasterControl:setenv(\"",name,"\", \"",value,"\")")

   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name)
   end
   varTbl[name]:set(tostring(value))
   mStack:setting()
   dbg.fini()
end

function M.unsetenv(self, name, value)
   local mStack = ModuleStack:moduleStack()
   local dbg    = Dbg:dbg()
   dbg.start("MasterControl:unsetenv(\"",name,"\", \"",value,"\")")

   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name)
   end
   varTbl[name]:unset()
   mStack:setting()
   dbg.fini()
end

function M.bad_unsetenv(self, name, value)
   LmodWarning("Refusing unsetenv variable while unloading: \"",name,"\"\n")
end

-------------------------------------------------------------------
-- stack: push and pop
-------------------------------------------------------------------

function M.pushenv(self, name, value)
   local mStack = ModuleStack:moduleStack()
   local dbg    = Dbg:dbg()
   dbg.start("MasterControl:pushenv(\"",name,"\", \"",value,"\")")

   local stackName = "__LMOD_STACK_" .. name

   if (varTbl[stackName] == nil) then
      varTbl[stackName] = Var:new(stackName, nil, ":")
   end
   varTbl[stackName]:prepend(tostring(value))

   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name)
   end
   varTbl[name]:set(tostring(value))
   
   mStack:setting()
   dbg.fini("MasterControl:pushenv")
end

function M.popenv(self, name, value)
   local mStack = ModuleStack:moduleStack()
   local dbg    = Dbg:dbg()
   dbg.start("MasterControl:popenv(\"",name,"\", \"",value,"\")")

   local stackName = "__LMOD_STACK_" .. name

   local v = nil

   if (varTbl[stackName] == nil) then
      varTbl[stackName] = Var:new(stackName)
   end
      
   dbg.print("stackName: ", stackName, " RTM pop()\n")
   local v = varTbl[stackName]:pop()
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
   local dbg    = Dbg:dbg()
   dbg.start("MasterControl:set_alias(\"",name,"\", \"",value,"\")")


   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name)
   end
   varTbl[name]:setAlias(value)
   mStack:setting()
   dbg.fini()
end

function M.unset_alias(self, name, value)
   local mStack = ModuleStack:moduleStack()
   local dbg    = Dbg:dbg()
   dbg.start("MasterControl:unset_alias(\"",name,"\", \"",value,"\")")

   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name)
   end
   varTbl[name]:unsetAlias(value)
   mStack:setting()
   dbg.fini()
end

function M.bad_unset_alias(self, name)
   LmodWarning("Refusing unset an alias while unloading: \"",name,"\"\n")
end

-------------------------------------------------------------------
-- Shell Routine Functions
-------------------------------------------------------------------

function M.set_shell_function(self, name, bash_function, csh_function)
   local mStack = ModuleStack:moduleStack()
   local dbg    = Dbg:dbg()
   dbg.start("MasterControl:set_shell_function(\"",name,"\", \"",bash_function,"\")",
             "\", \"",csh_function,"\")")


   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name)
   end
   varTbl[name]:setShellFunction(bash_function, csh_function)
   mStack:setting()
   dbg.fini()
end

function M.unset_shell_function(self, name, bash_function, csh_function)
   local mStack = ModuleStack:moduleStack()
   local dbg    = Dbg:dbg()
   dbg.start("MasterControl:unset_shell_function(\"",name,"\", \"",bash_function,"\")",
             "\", \"",csh_function,"\")")

   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name)
   end
   varTbl[name]:unsetShellFunction()
   mStack:setting()
   dbg.fini()
end

function M.bad_unset_shell_function(self, name, bash_function, csh_function)
   LmodWarning("Refusing unset a shell function while unloading: \"",name,"\"\n")
end

-------------------------------------------------------------------
-- Property Functions
-------------------------------------------------------------------

function M.add_property(self, name, value)
   local dbg    = Dbg:dbg()
   dbg.start("MasterControl:add_property(\"",name,"\", \"",value,"\")")
   local mStack  = ModuleStack:moduleStack()
   local mFull   = mStack:fullName()
   local mt      = MT:mt()
   local mname   = MName:new("load",mFull)
   mt:add_property(mname:sn(), name, value)
   dbg.fini()
end

function M.remove_property(self, name, value)
   local dbg     = Dbg:dbg()
   dbg.start("MasterControl:remove_property(\"",name,"\", \"",value,"\")")
   local mStack  = ModuleStack:moduleStack()
   local mFull   = mStack:fullName()
   local mt      = MT:mt()
   local mname   = MName:new("mt",mFull)
   mt:remove_property(mname:sn(), name, value)
   dbg.fini()
end

function M.bad_remove_property(self, name, value)
   LmodWarning("Refusing to remove a property while unloading: \"",name,"\"\n")
end

-------------------------------------------------------------------
-- Message/Error  Functions
-------------------------------------------------------------------

function LmodErrorExit()
   io.stdout:write("false\n")
   os.exit(1)
end

function LmodSystemError(...)
   io.stderr:write("\n", colorize("red", "Lmod Error: "))
   for _,v in ipairs{...} do
      io.stderr:write(v)
   end
   io.stderr:write("\n")
   LmodErrorExit()
end   


function M.error(self, ...)
   LmodSystemError(...)
end

function M.warning(self, ...)
   if (not expert() and  haveWarnings()) then
      io.stderr:write("\n",colorize("red", "Lmod Warning: "))
      for _,v in ipairs{...} do
         io.stderr:write(v)
      end
      io.stderr:write("\n")
      setWarningFlag()
   end
end


function M.message(self, ...)
   for _,v in ipairs{...} do
      io.stderr:write(v)
   end
   io.stderr:write("\n")
end


-------------------------------------------------------------------
-- Misc Functions
-------------------------------------------------------------------

function M.prereq(self, ...)
   local dbg       = Dbg:dbg()
   local mt        = MT:mt()
   local a         = {}
   local mStack    = ModuleStack:moduleStack()
   local mFull     = mStack:fullName()
   local masterTbl = masterTbl()

   dbg.start("MasterControl:prereq(",concatTbl({...},", "),")")

   if (masterTbl.checkSyntax) then
      dbg.print("Ignoring prereq when syntax checking\n")
      dbg.fini()
      return
   end

   for _,v in ipairs{...} do
      local mname    = MName:new("mt", v)
      local sn       = mname:sn()
      local full     = mt:fullName(sn)
      local version  = extractVersion(v, sn)
      dbg.print("sn: ",sn," full: ",full, " version: ",version,"\n")
      if ((not mt:have(sn,"active")) or
          (version and full ~= mname:usrName())) then
         a[#a+1] = v
      end
   end
   dbg.print("number found: ",#a,"\n")
   if (#a > 0) then
      local s = concatTbl(a," ")
      LmodError("Can not load: \"",mFull,"\" module without these modules loaded:\n  ",
            s,"\n")
   end
   dbg.fini()
end

function M.conflict(self, ...)
   local dbg    = Dbg:dbg()
   dbg.start("MasterControl:conflict(",concatTbl({...},", "),")")


   local mt        = MT:mt()
   local a         = {}
   local mStack    = ModuleStack:moduleStack()
   local mFull     = mStack:fullName()
   local masterTbl = masterTbl()

   if (masterTbl.checkSyntax) then
      dbg.print("Ignoring conflicts when syntax checking\n")
      dbg.fini()
      return
   end

   for _,v in ipairs{...} do
      local mname   = MName:new("mt", v)
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
      LmodError("Can not load: \"",mFull,"\" module because these modules are loaded:\n  ",
            s,"\n")
   end
   dbg.fini()
end

function M.prereq_any(self, ...)
   local dbg       = Dbg:dbg()
   local mt        = MT:mt()
   local a         = {}
   local mStack    = ModuleStack:moduleStack()
   local mFull     = mStack:fullName()
   local masterTbl = masterTbl()

   dbg.start("MasterControl:prereq_any(",concatTbl({...},", "),")")

   if (masterTbl.checkSyntax) then
      dbg.print("Ignoring prereq_any when syntax checking\n")
      dbg.fini()
      return
   end

   local found  = false
   for _,v in ipairs{...} do
      local mname = MName:new("mt", v)
      local sn    = mname:sn()
      if (mt:have(sn,"active")) then
         found = true
         break;
      end
   end

   if (not found) then
      local s = concatTbl(a," ")
      LmodError("Can not load: \"",mFull,"\" module.  At least one of these modules must be loaded:\n  ",
            concatTbl({...},", "),"\n")
   end
   dbg.fini()
end



function M.family(self, name)
   local dbg       = Dbg:dbg()
   local mt        = MT:mt()
   local mStack    = ModuleStack:moduleStack()
   local mFull     = mStack:fullName()
   local mname     = MName:new("mt",mFull)
   local sn        = mname:sn()
   local masterTbl = masterTbl()

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
   dbg.fini()
end

function M.myFileName(self)
   local mStack = ModuleStack:moduleStack()
   return mStack:fileName()
end

function M.myModuleFullName(self)
   local mStack = ModuleStack:moduleStack()
   return mStack:fullName()
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
   local dbg    = Dbg:dbg()
   local mt     = MT:mt()

   dbg.start("MasterControl:unset_family(",name,")")
   dbg.print("mt:unsetfamily(\"",name,"\")\n")
   mt:unsetfamily(name)
   dbg.fini()
end

function M.inherit(self)
   local dbg    = Dbg:dbg()
   local master = Master:master()
   dbg.start("MasterControl:inherit()")
   master.inheritModule()
   dbg.fini()
end

function M.is_spider(self)
   local dbg    = Dbg:dbg()
   dbg.start("MasterControl:is_spider()")
   dbg.fini()
   return false
end

function M._setMode(self, mode)
   local dbg    = Dbg:dbg()
   dbg.start("MasterControl:_setMode(\"",mode,"\")")
   self._mode = mode
   dbg.fini()
end

function M.mode(self)
   local dbg    = Dbg:dbg()
   dbg.start("MasterControl:mode()")
   dbg.print("mode: ", self._mode,"\n")
   dbg.fini()
   return self._mode
end   

-------------------------------------------------------------------
-- Quiet Functions
-------------------------------------------------------------------


function M.quiet(self, ...)
   -- very Quiet !!!
end

return M
