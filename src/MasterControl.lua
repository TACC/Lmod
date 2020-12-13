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

require("inherits")
require("myGlobals")
require("colorize")
require("string_utils")
require("utils")

Master                 = require("Master")

local BeautifulTbl     = require("BeautifulTbl")
local FrameStk         = require("FrameStk")
local M                = {}
local MName            = require("MName")
local Var              = require("Var")
local dbg              = require("Dbg"):dbg()
local base64           = require("base64")
local concatTbl        = table.concat
local cosmic           = require("Cosmic"):singleton()
local decode64         = base64.decode64
local encode64         = base64.encode64
local getenv           = os.getenv
local hook             = require("Hook")
local i18n             = require("i18n")
local max              = math.max
local pack             = (_VERSION == "Lua 5.1") and argsPack or table.pack -- luacheck: compat
local remove           = table.remove
local s_adminT         = {}
local s_loadT          = {}
local s_moduleStk      = {}
local s_missDepT       = {}
local s_missingModuleT = {}
local s_missingFlg     = false

--------------------------------------------------------------------------
-- Remember the user's requested load array into an internal table.
-- This is tricky because the module mnames in the *mA* array may not be
-- findable yet (e.g. module load mpich petsc).  The only thing we know
-- is the usrName from the command line.  So we use the *usrName* to be
-- the key and not *sn*.
-- @param mA The array of MName objects.
local function registerUserLoads(mA)
   dbg.start{"registerUserLoads(mA)"}
   for i = 1, #mA do
      local mname       = mA[i]
      local userName    = mname:userName()
      s_loadT[userName] = mname
      dbg.print{"userName: ",userName,"\n"}
   end
   dbg.fini("registerUserLoads")
end

local function unRegisterUserLoads(mA)
   dbg.start{"unRegisterUserLoads(mA)"}
   for i = 1, #mA do
      local mname       = mA[i]
      local userName    = mname:userName()
      s_loadT[userName] = nil
      dbg.print{"userName: ",userName,"\n"}
   end
   dbg.fini("unRegisterUserLoads")
end

local function compareRequestedLoadsWithActual()
   dbg.start{"compareRequestedLoadsWithActual()"}
   local mt = FrameStk:singleton():mt()

   local aa = {}
   local bb = {}
   for userName, mname in pairs(s_loadT) do
      local sn = mname:sn()
      if (not mt:have(sn, "active")) then
         aa[#aa+1] = mname:show()
         bb[#bb+1] = userName
      end
   end
   dbg.fini("compareRequestedLoadsWithActual")
   return aa, bb
end

local function l_createStackName(name)
   return "__LMOD_STACK_" .. name
end

local function l_error_on_missing_loaded_modules(aa,bb)
   if (#aa > 0) then
      local luaprog = "@path_to_lua@"
      local found
      if (luaprog:sub(1,1) == "@") then
         luaprog, found = findInPath("lua")
         if (not found) then
            LmodError{msg="e_Failed_2_Find", name = "lua"}
         end
      end
      local cmdA = {}
      cmdA[#cmdA+1] = luaprog
      cmdA[#cmdA+1] = pathJoin(cmdDir(),cmdName())
      cmdA[#cmdA+1] = "bash"
      cmdA[#cmdA+1] = dbg.active() and "-D" or " "
      cmdA[#cmdA+1] = "--regexp --no_redirect --spider_timeout 2.0 spider"
      local count   = #cmdA

      local uA = {}  -- unknown names
      local iA = {}  -- illegal names
      local kA = {}  -- known modules (show)
      local kB = {}  -- known modules (usrName)


      if (expert()) then
         uA = aa
      else
         local outputDirection = dbg.active() and "2> spider.log" or "2> /dev/null"
         for i = 1, #bb do
            if (bb[i]:sub(1,2) == "__") then
               iA[#iA+1] = bb[i]
            else
               cmdA[count+1] = "'^" .. bb[i]:escape() .. "$'"
               cmdA[count+2] = outputDirection
               local cmd     = concatTbl(cmdA," ")
               local result  = capture(cmd)
               dbg.print{"result: ",result,"\n"}
               if (result:find("\nfalse")) then
                  uA[#uA+1] = aa[i]
               else
                  kA[#kA+1] = aa[i]
                  kB[#kB+1] = bb[i]
               end
            end
         end
      end

      local a = {}

      if (#iA > 0) then
         mcp:report{msg="e_Illegal_Load", module_list = concatTbl(iA, " ") }
      end


      if (#uA > 0) then
         mcp:report{msg="e_Failed_Load", module_list = concatTbl(uA, " ") }
      end

      if (#kA > 0) then
         mcp:report{msg="e_Failed_Load_2", kA = concatTbl(kA, ", "), kB = concatTbl(kB, " ")}
      end
   end
end

function M.name(self)
   return self.my_name
end

--------------------------------------------------------------------------
-- Return the sType.
-- @param self A MasterControl object
function M.MNameType(self)
   return self.my_sType
end

--------------------------------------------------------------------------
-- Return the tcl_mode.
-- @param self A MasterControl object
function M.tcl_mode(self)
   return self.my_tcl_mode
end

--------------------------------------------------------------------------
-- Convert MC name to MC Object.
-- @param nameTbl Name to MC object table.
-- @param name    Name of an MC objects.
local function valid_name(nameTbl, name)
   return nameTbl[name] or nameTbl.default
end

--------------------------------------------------------------------------
-- Set the type (or mode) of the current MasterControl object.
-- @param self A MasterControl object
function M._setMode(self, mode)
   dbg.start{"MasterControl:_setMode(\"",mode,"\")"}
   self._mode = mode
   dbg.fini("MasterControl:_setMode")
end

--------------------------------------------------------------------------
-- The Factory builder for the MasterControl Class.
-- @param name the name of the derived object.
-- @param[opt] mode An optional mode for building the *access* object.
-- @return A derived MasterControl Object.
local s_nameTbl          = false
function M.build(name,mode)

   if (not s_nameTbl) then
      local MCLoad        = require('MC_Load')
      local MCUnload      = require('MC_Unload')
      local MCMgrLoad     = require('MC_MgrLoad')
      local MCRefresh     = require('MC_Refresh')
      local MCDepCk       = require('MC_DependencyCk')
      local MCShow        = require('MC_Show')
      local MCAccess      = require('MC_Access')
      local MCSpider      = require('MC_Spider')
      local MCComputeHash = require('MC_ComputeHash')
      local MCCheckSyntax = require('MC_CheckSyntax')

      s_nameTbl = {
         ["load"]         = MCLoad,        -- Normal loading of modules
         ["mgrload"]      = MCMgrLoad,     -- for collections (loads in modules are ignored)
         ["unload"]       = MCUnload,      -- Unload modules
         ["refresh"]      = MCRefresh,     -- for subshells, sets the aliases again
         ["computeHash"]  = MCComputeHash, -- Generate a hash value for the contents of the module
         ["refresh"]      = MCRefresh,     -- for subshells, sets the aliases again
         ["show"]         = MCShow,        -- show the module function instead.
         ["access"]       = MCAccess,      -- for whatis, help
         ["spider"]       = MCSpider,      -- Process module files for spider operations
         ["checkSyntax"]  = MCCheckSyntax, -- Check the syntax of a module, load, prereq, etc
                                           -- are ignored.
         ["dependencyCk"] = MCDepCk,       -- Report any missing dependency modules
      }
   end

   local o                = valid_name(s_nameTbl, name):create()
   o:_setMode(mode or name)
   o.__first   =  0
   o.__last    = -1
   o.__moduleQ = {}

   dbg.print{"Setting mcp to ", o:name(),"\n"}
   return o
end

-------------------------------------------------------------------
-- Module Queue functions

function M.pushModule(self, value)
   local last  = self.__last + 1
   self.__last = last
   self.__moduleQ[last] = value
end

function M.popModule(self)
   local first = self.__first
   if (first > self.__last) then
      LmodError{msg="e_BrokenQ"}
   end
   local value           = self.__moduleQ[first]
   self.__moduleQ[first] = nil                   -- to allow garbage collection
   self.__first          = first + 1
   return value
end

function M.isEmpty(self)
   return self.__last < self.__first
end

-------------------------------------------------------------------
-- Setenv / Unsetenv Functions
-------------------------------------------------------------------

-------------------------------------------------------------------
-- Set an environment variable.
-- @param self A MasterControl object.
-- @param name the environment variable name.
-- @param value the environment variable value.
-- @param respect If true, then respect the old value.
function M.setenv(self, name, value, respect)
   name = name:trim()
   dbg.start{"MasterControl:setenv(\"",name,"\", \"",value,"\", \"",
              respect,"\")"}

   if (value == nil) then
      LmodError{msg="e_Missing_Value", func = "setenv", name = name}
   end

   if (respect and getenv(name)) then
      dbg.print{"Respecting old value"}
      dbg.fini("MasterControl:setenv")
      return
   end

   local frameStk = FrameStk:singleton()
   local varT     = frameStk:varT()
   if (varT[name] == nil) then
      varT[name] = Var:new(name)
   end
   varT[name]:set(tostring(value))
   dbg.fini("MasterControl:setenv")
end


--------------------------------------------------------------------------
-- Unset an environment variable.
-- @param self A MasterControl object.
-- @param name the environment variable name.
-- @param value the environment variable value.
-- @param respect If true, then respect the old value.
function M.unsetenv(self, name, value, respect)
   name = name:trim()
   dbg.start{"MasterControl:unsetenv(\"",name,"\", \"",value,"\")"}

   if (respect and getenv(name) ~= value) then
      dbg.print{"Respecting old value"}
      dbg.fini("MasterControl:unsetenv")
      return
   end

   local frameStk  = FrameStk:singleton()
   local varT      = frameStk:varT()
   if (varT[name] == nil) then
      varT[name]   = Var:new(name)
   end
   varT[name]:unset()

   -- Unset stack variable if it exists
   local stackName = l_createStackName(name)
   if (varT[stackName]) then
      varT[name]:unset()
   end
   dbg.fini("MasterControl:unsetenv")
end

-------------------------------------------------------------------
-- stack: push and pop
-------------------------------------------------------------------

--------------------------------------------------------------------------
-- Set an environment variable and remember previous values in a stack.
-- @param self A MasterControl object.
-- @param name the environment variable name.
-- @param value the environment variable value.
function M.pushenv(self, name, value)
   name = name:trim()
   dbg.start{"MasterControl:pushenv(\"",name,"\", \"",value,"\")"}

   ----------------------------------------------------------------
   -- If name exists in the env and the stack version of the name
   -- doesn't exist then use the name's value as the initial value
   -- for "stackName".

   if (value == nil) then
      LmodError{msg="e_Missing_Value",func = "pushenv", name = name}
   end

   local stackName = l_createStackName(name)
   local v64       = nil
   local v         = getenv(name)
   if (getenv(stackName) == nil and v) then
      v64          = encode64(v)
   end

   local nodups   = false
   local frameStk = FrameStk:singleton()
   local varT     = frameStk:varT()

   if (varT[stackName] == nil) then
      varT[stackName] = Var:new(stackName, v64, nodups, ":")
   end

   if (value == false) then
      v   = false
      v64 = "false"
   else
      v   = tostring(value)
      v64 = encode64(value)
   end
   local priority = 0

   varT[stackName]:prepend(v64, nodups, priority)

   if (varT[name] == nil) then
      varT[name] = Var:new(name)
   end
   varT[name]:set(v)

   dbg.fini("MasterControl:pushenv")
end

--------------------------------------------------------------------------
-- The reverse action of pushenv.  It pops the old value off of the stack
-- and set the *name* to the previous value from the stack.
-- @param self A MasterControl object.
-- @param name the environment variable name.
-- @param value the environment variable value.
function M.popenv(self, name, value)
   name = name:trim()
   dbg.start{"MasterControl:popenv(\"",name,"\", \"",value,"\")"}

   local stackName = l_createStackName(name)
   local frameStk = FrameStk:singleton()
   local varT     = frameStk:varT()

   if (varT[stackName] == nil) then
      varT[stackName] = Var:new(stackName)
   end

   dbg.print{"stackName: ", stackName, " pop()\n"}

   local v64 = varT[stackName]:pop()
   local v   = nil
   if (v64 == "false") then
      v = false
   elseif (v64) then
      v = decode64(v64)
   end
   dbg.print{"v: ", v,"\n"}

   if (varT[name] == nil) then
      varT[name] = Var:new(name)
   end

   varT[name]:set(v)

   dbg.fini("MasterControl:popenv")
end

-------------------------------------------------------------------
-- Path Modification Functions
-------------------------------------------------------------------


-------------------------------------------------------------------
-- Prepend to a path like variable.
-- @param self A MasterControl object
-- @param t A table containing { name, value, nodups=v1, priority=v2}
function M.prepend_path(self, t)
   dbg.start{"MasterControl:prepend_path(t)"}
   local sep      = t.delim or ":"
   local name     = t[1]
   local value    = t[2]
   local nodups   = not allow_dups( not t.nodups)
   local priority = (-1)*(t.priority or 0)

   local frameStk = FrameStk:singleton()
   local varT     = frameStk:varT()


   dbg.print{"name:\"",name,"\", value: \"",value,
             "\", delim=\"",sep,"\", nodups=\"",nodups,
             "\", priority=",priority,"\n"}

   if (varT[name] == nil) then
      varT[name] = Var:new(name, nil, nodups, sep)
   end

   -- Do not allow dups on MODULEPATH like env vars.
   nodups = (name == ModulePath) or nodups

   varT[name]:prepend(tostring(value), nodups, priority)
   dbg.fini("MasterControl:prepend_path")
end

--------------------------------------------------------------------------
-- Append to a path like variable.
-- @param self A MasterControl object
-- @param t A table containing { name, value, nodups=v1, priority=v2}
function M.append_path(self, t)
   local sep      = t.delim or ":"
   local name     = t[1]
   local value    = t[2]
   local nodups   = not allow_dups( not t.nodups)
   local priority = t.priority or 0
   local frameStk = FrameStk:singleton()
   local varT     = frameStk:varT()

   dbg.start{"MasterControl:append_path{\"",name,"\", \"",value,
             "\", delim=\"",sep,"\", nodups=\"",nodups,
             "\", priority=",priority,
             "}"}

   -- Do not allow dups on MODULEPATH like env vars.
   nodups = name == ModulePath or nodups

   if (varT[name] == nil) then
      varT[name] = Var:new(name, false, nodups, sep)
   end

   varT[name]:append(tostring(value), nodups, priority)
   dbg.fini("MasterControl:append_path")
end

--------------------------------------------------------------------------
-- Remove an entry from a path like variable.
-- @param self A MasterControl object
-- @param t A table containing { name, value, nodups=v1, priority=v2, where=v3, force=v4}
function M.remove_path(self, t)
   local sep      = t.delim or ":"
   local name     = t[1]
   local value    = t[2]
   local nodups   = not allow_dups( not t.nodups)
   local priority = t.priority or 0
   local where    = t.where
   local frameStk = FrameStk:singleton()
   local varT     = frameStk:varT()
   local force    = t.force

   dbg.start{"MasterControl:remove_path{\"",name,"\", \"",value,
             "\", delim=\"",sep,"\", nodups=\"",nodups,
             "\", priority=",priority,
             ", where=",where,
             ", force=",force,
             "}"}

   -- Do not allow dups on MODULEPATH like env vars.
   nodups = (name == ModulePath) or nodups

   if (varT[name] == nil) then
      varT[name] = Var:new(name,nil, nodups, sep)
   end
   varT[name]:remove(tostring(value), where, priority, nodups, force)
   dbg.fini("MasterControl:remove_path")
end

--------------------------------------------------------------------------
-- Remove an entry from a path-like variable.  This version is the reverse
-- of a prepend_path.
-- @param self A MasterControl object
-- @param t A table containing { name, value, nodups=v1, priority=v2}
function M.remove_path_first(self, t)
   t.where = "first"
   M.remove_path(self, t)
end

-- Remove an entry from a path-like variable.  This version is the reverse
-- of a append_path.
-- @param self A MasterControl object
-- @param t A table containing { name, value, nodups=v1, priority=v2}
function M.remove_path_last(self, t)
   t.where = "last"
   M.remove_path(self, t)
end



--------------------------------------------------------------------------
-- Set a shell alias.  This function can handle a single value for both
-- bash and C-shell.
-- @param self A MasterControl Object.
-- @param name the environment variable name.
-- @param value the environment variable value.
function M.set_alias(self, name, value)
   name = name:trim()
   dbg.start{"MasterControl:set_alias(\"",name,"\", \"",value,"\")"}

   local frameStk = FrameStk:singleton()
   local varT     = frameStk:varT()

   if (varT[name] == nil) then
      varT[name] = Var:new(name)
   end
   varT[name]:setAlias(value)
   dbg.fini("MasterControl:set_alias")
end

--------------------------------------------------------------------------
-- Unset a shell alias.
-- @param self A MasterControl Object.
-- @param name the environment variable name.
-- @param value the environment variable value.
function M.unset_alias(self, name, value)
   name = name:trim()
   dbg.start{"MasterControl:unset_alias(\"",name,"\", \"",value,"\")"}

   local frameStk = FrameStk:singleton()
   local varT     = frameStk:varT()

   if (varT[name] == nil) then
      varT[name] = Var:new(name)
   end
   varT[name]:unsetAlias()
   dbg.fini("MasterControl:unset_alias")
end


--------------------------------------------------------------------------
-- Set a shell function for bash and a csh alias.
-- @param self A MasterControl Object.
-- @param name the environment variable name.
-- @param value the environment variable value.
function M.set_shell_function(self, name, bash_function, csh_function)
   name = name:trim()
   dbg.start{"MasterControl:set_shell_function(\"",name,"\", \"",bash_function,"\"",
             "\", \"",csh_function,"\""}


   local frameStk = FrameStk:singleton()
   local varT     = frameStk:varT()

   if (varT[name] == nil) then
      varT[name] = Var:new(name)
   end
   varT[name]:setShellFunction(bash_function, csh_function)
   dbg.fini("MasterControl:set_shell_function")
end

--------------------------------------------------------------------------
-- Unset a shell function for bash and a csh alias.
-- @param self A MasterControl Object.
-- @param name the environment variable name.
-- @param value the environment variable value.
function M.unset_shell_function(self, name, bash_function, csh_function)
   name = name:trim()
   dbg.start{"MasterControl:unset_shell_function(\"",name,"\", \"",bash_function,"\"",
             "\", \"",csh_function,"\""}

   local frameStk = FrameStk:singleton()
   local varT     = frameStk:varT()

   if (varT[name] == nil) then
      varT[name] = Var:new(name)
   end
   varT[name]:unsetShellFunction()
   dbg.fini("MasterControl:unset_shell_function")
end


--------------------------------------------------------------------------
-- Return the type (or mode) of the current MasterControl object.
-- @param self A MasterControl object
function M.mode(self)
   return self._mode
end

--------------------------------------------------------------------------
-- Place a string that will be executed when the output from Lmod eval'ed.
-- @param self A MasterControl object
-- @param t A table containing A mode array and a command.
function M.execute(self, t)
   dbg.start{"MasterControl:execute(t)"}
   local a      = t.modeA or {}
   local myMode = self:mode()
   local Exec   = require("Exec")

   for i = 1,#a do
      if (myMode == a[i] or a[i]:lower() == "all" ) then
         local exec   = Exec:exec()
         exec:register(t.cmd)
         break
      end
   end
   dbg.fini("MasterControl:execute")
end

--------------------------------------------------------------------------
-- Return the user's shell
-- @param self A MasterControl object
function M.myShellName(self)
   return Shell and Shell:name() or "bash"
end

function M.myShellType(self)
   local shell = Shell and Shell:name() or "bash"
   local kindT = {
      bash = "sh",
      zsh  = "sh",
      ksh  = "sh",
      tcsh = "csh",
   }
   return kindT[shell] or shell
end


--------------------------------------------------------------------------
-- Return the current file name.
-- @param self A MasterControl object
function M.myFileName(self)
   local frameStk = FrameStk:singleton()
   return frameStk:fn()
end

--------------------------------------------------------------------------
-- Return the full name of the current module.  Typically name/version.
-- @param self A MasterControl object.
function M.myModuleFullName(self)
   local frameStk = FrameStk:singleton()
   return frameStk:fullName()
end

--------------------------------------------------------------------------
-- Return the user name of the current module.  This is the name the user
-- specified.  It could a full name (name/version) or just the name.
-- @param self A MasterControl object.
function M.myModuleUsrName(self)
   local frameStk = FrameStk:singleton()
   return frameStk:userName()
end

--------------------------------------------------------------------------
-- Return the name of the modules.  That is the name of the module w/o a
-- version.
-- @param self A MasterControl object
function M.myModuleName(self)
   local frameStk = FrameStk:singleton()
   return frameStk:sn()
end

--------------------------------------------------------------------------
-- Return the version if any.  If there is no version, for example a meta
-- module then the version is "".
-- @param self A MasterControl object
function M.myModuleVersion(self)
   local frameStk = FrameStk:singleton()
   return frameStk:version()
end

local function l_generateMsg(kind, label, ...)
   local sA     = {}
   local twidth = TermWidth()
   local argA   = pack(...)
   if (argA.n == 1 and type(argA[1]) == "table") then
      local t   = argA[1]
      local key = t.msg
      local msg = i18n(key, t) or "Unknown Error Message"
      msg       = hook.apply("errWarnMsgHook", kind, key, msg, t) or msg
      sA[#sA+1] = buildMsg(twidth, label, msg)
   else
      sA[#sA+1] = buildMsg(twidth, label, ...)
   end
   return sA
end

function M.msg_raw(self, ...)
   if (quiet()) then
      return
   end
   local argA   = pack(...)
   for i = 1,argA.n do
      io.stderr:write(argA[i])
   end
end


--------------------------------------------------------------------------
-- Print msgs to stderr.
-- @param self A MasterControl object.
function M.message(self, ...)
   if (quiet()) then
      return
   end
   local sA     = {}
   local twidth = TermWidth()
   local argA   = pack(...)
   if (argA.n == 1 and type(argA[1]) == "table") then
      local t   = argA[1]
      local key = t.msg
      local msg = i18n(key, t) or "Unknown Message"
      msg       = hook.apply("errWarnMsgHook", "lmodmessage", key, msg, t) or msg
      sA[#sA+1] = buildMsg(twidth, msg)
   else
      sA[#sA+1] = buildMsg(twidth, ...)
   end
   io.stderr:write(concatTbl(sA,""),"\n")
end

--------------------------------------------------------------------------
-- Print msgs, traceback then set warning flag.
-- @param self A MasterControl object.
function M.warning(self, ...)
   if (not quiet() and  haveWarnings()) then
      local label = colorize("red", i18n("warnTitle",{}))
      local sA    = l_generateMsg("lmodwarning", label, ...)
      sA[#sA+1]   = "\n"
      sA[#sA+1]   = moduleStackTraceBack()
      sA[#sA+1]   = "\n"
      io.stderr:write(concatTbl(sA,""),"\n")
      setWarningFlag()
   end
end

--------------------------------------------------------------------------
-- Print msgs, traceback then exit.
-- @param self A MasterControl object.
function M.error(self, ...)
   -- Check for user loads that failed.
   if (next(s_missingModuleT) ~= nil) then
      local aa = {}
      local bb = {}
      for k, v in pairs(s_missingModuleT) do
         aa[#aa + 1] = v
         bb[#bb + 1] = k
      end
      s_missingModuleT = {}
      l_error_on_missing_loaded_modules(aa, bb)
   end

   local label = colorize("red", i18n("errTitle", {}))
   local sA    = l_generateMsg("lmoderror", label, ...)
   sA[#sA+1]   = "\n"

   local a = concatTbl(stackTraceBackA,"")
   if (a:len() > 0) then
       sA[#sA+1] = a
       sA[#sA+1] = "\n"
   end
   sA[#sA+1]     = moduleStackTraceBack()
   sA[#sA+1]     = "\n"

   io.stderr:write(concatTbl(sA,""),"\n")
   LmodErrorExit()
end

--------------------------------------------------------------------------
-- The quiet function.
-- @param self A MasterControl object
function M.quiet(self, ...)
   -- very Quiet !!!
end

function M.mustLoad(self)
   dbg.start{"MasterControl:mustLoad()"}

   local aa, bb = compareRequestedLoadsWithActual()
   l_error_on_missing_loaded_modules(aa,bb)

   dbg.fini("MasterControl:mustLoad")
end


function M.dependencyCk(self,mA)
   if (dbg.active()) then
      local s = mAList(mA)
      dbg.start{"MasterControl:dependencyCk(mA={"..s.."})"}
   end

   local frameStk = FrameStk:singleton()
   local mt       = frameStk:mt()
   local fullName = frameStk:fullName()
   for i = 1,#mA do
      local mname = mA[i]
      local sn    = mname:sn()
      if (not mt:have(sn,"active")) then
         local a = s_missDepT[mname:userName()] or {}
         a[#a+1] = fullName
         s_missDepT[mname:userName()] = a
      end
   end

   dbg.fini("MasterControl:dependencyCk")
   return {}
end

function M.reportMissingDepModules(self)
   local t = s_missDepT
   if (next(t) ~= nil) then
      local a           = {}
      local term_width  = TermWidth()
      local border      = colorize("red",string.rep("-", term_width-1))

      for k,v in pairsByKeys(t) do
         local s = concatTbl(v,", ")
         a[#a+1] = k .. " (required by: "..s..")"
      end
      io.stderr:write(i18n("w_MissingModules",{border=border,missing=concatTbl(a,", ")}))
   end
end


-------------------------------------------------------------------
-- depends_on() a list of modules.  This is short hand for:
--
--   if (not isloaded("name")) then load("name") end
--

function M.depends_on(self, mA)
   if (dbg.active()) then
      local s = mAList(mA)
      dbg.start{"MasterControl:depends_on(mA={"..s.."})"}
   end

   local mB = {}

   for i = 1,#mA do
      local mname = mA[i]
      if (not mname:isloaded()) then
         mB[#mB + 1] = mname
      end
   end

   registerUserLoads(mB)
   local a = self:load(mB)

   --------------------------------------------
   -- Bump ref count on ALL dependent modules

   local mt = FrameStk:singleton():mt()
   for i = 1,#mA do
      local mname      = mA[i]
      local sn         = mname:sn()
      if (sn and mt:stackDepth(sn) > 0) then
         mt:incr_ref_count(sn)
      end
   end

   dbg.fini("MasterControl:depends_on")
   return a
end

-------------------------------------------------------------------
-- forgo a list of modules.  This is the reverse of depends_on()
--
--   if (not isloaded("name")) then load("name") end
--
-- On unload forgo() unloads iff stackDepth is non-zero and the ref count
-- is zero.


function M.forgo(self,mA)
   local master = Master:singleton()
   if (dbg.active()) then
      local s = mAList(mA)
      dbg.start{"MasterControl:forgo(mA={"..s.."})"}
   end

   local mt = FrameStk:singleton():mt()
   local mB = {}
   for i = 1,#mA do
      repeat
         local mname      = mA[i]
         local sn         = mname:sn()
         if (not sn) then break end
         local ref_count  = mt:decr_ref_count(sn)
         local stackDepth = mt:stackDepth(sn)
         if (stackDepth > 0 and ref_count < 1) then
            mB[#mB+1] = mname
         end
      until true
   end

   unRegisterUserLoads(mB)
   local aa     = master:unload(mB)
   dbg.fini("MasterControl:forgo")
   return aa
end



-------------------------------------------------------------------
-- Load a list of modules.  Check to see if the user requested
-- modules were actually loaded.
-- @param self A MasterControl object
-- @param mA A array of MName objects.
-- @return An array of statuses
function M.load_usr(self, mA)
   if (dbg.active()) then
      local s = mAList(mA)
      dbg.start{"MasterControl:load_usr(mA={"..s.."})"}
   end
   local frameStk = FrameStk:singleton()
   if (checkSyntaxMode() and frameStk:count() > 1) then
      dbg.print{"frameStk:count(): ",frameStk:count(),"\n"}
      dbg.fini("MasterControl:load_usr")
      return {}
   end

   registerUserLoads(mA)
   local a = self:load(mA)
   dbg.fini("MasterControl:load_usr")
   return a
end


--------------------------------------------------------------------------
-- Build a list of user names based on mA.
-- @param mA List of MName objects
function mAList(mA)
   local a = {}
   for i = 1, #mA do
      a[#a + 1] = mA[i]:userName()
   end
   return concatTbl(a, ", ")
end

function M.load(self, mA)
   if (dbg.active()) then
      local s = mAList(mA)
      dbg.start{"MasterControl:load(mA={"..s.."})"}
   end

   local master = Master:singleton()
   local a      = master:load(mA)

   if (not quiet()) then
      self:registerAdminMsg(mA)
   end

   dbg.fini("MasterControl:load")
   return a
end

function M.load_any(self, mA)
   if (dbg.active()) then
      local s = mAList(mA)
      dbg.start{"MasterControl:load_any(mA={"..s.."})"}
   end
   local b
   local uA     = {}
   local result = false

   for i = 1, #mA do
      local mname = mA[i]
      b = self:try_load{mname}
      if (mname:isloaded()) then
         result = true
         break
      else
         uA[#uA+1] = mname:userName()
      end
   end

   if (not result) then
      LmodError{msg="e_Failed_Load_any", module_list=concatTbl(uA," ")}
   end

   dbg.fini("MasterControl:load_any")
   return b
end



function M.mgrload(self, required, active)
   if (dbg.active()) then
      dbg.start{"MasterControl:mgrload(required: ",required,", active=",active.userName,")"}
   end

   if (not required) then
      deactivateWarning()
   else
      activateWarning()
   end

   local status = Master:singleton():mgrload(active)

   dbg.fini("MasterControl:mgrload")
   return status
end

function M.mgr_unload(self, required, active)
   if (dbg.active()) then
      dbg.start{"MasterControl:mgr_unload(required: ",required,", active=",active.userName,")"}
   end

   local status = MCP:unload(MName:new("mt", active.userName))

   dbg.fini("MasterControl:mgr_unload")
   return status
end



-------------------------------------------------------------------
-- Load a list of module but ignore any warnings.
-- @param self A MasterControl object
-- @param mA A array of MName objects.
function M.try_load(self, mA)
   dbg.start{"MasterControl:try_load(mA)"}
   --deactivateWarning()
   self:load(mA)
   dbg.fini("MasterControl:try_load")
end

-------------------------------------------------------------------
-- Unload a list modules.
-- @param self A MasterControl object
-- @param mA A array of MName objects.
-- @return an array of statuses
function M.unload(self, mA)
   local master = Master:singleton()

   if (dbg.active()) then
      local s = mAList(mA)
      dbg.start{"MasterControl:unload(mA={"..s.."})"}
   end

   unRegisterUserLoads(mA)
   local aa     = master:unload(mA)
   dbg.fini("MasterControl:unload")
   return aa
end

-------------------------------------------------------------------
-- Unload a user requested list of modules.
-- @param self A MasterControl object
-- @param mA A array of MName objects.
-- @param force if true then do not reload sticky modules.
-- @return an array of statuses.
function M.unload_usr(self, mA, force)
   dbg.start{"MasterControl:unload_usr(mA)"}

   self:unload(mA)
   local master = Master:singleton()
   local aa = master:reload_sticky(force)

   master:dependencyCk()

   dbg.fini("MasterControl:unload_usr")
   return aa
end


-------------------------------------------------------------------
-- This load is used by Manager Load to ignore load inside a
-- module.
-- @param self A MasterControl object
-- @param mA A array of MName objects.
function M.fake_load(self,mA)
   if (dbg.active()) then
      local s = mAList(mA)
      dbg.start{"MasterControl:fake_load(mA={"..s.."})"}
      dbg.fini("MasterControl:fake_load")
   end
end

--------------------------------------------------------------------------
-- Check the conflicts from *mA*.
-- @param self A MasterControl object.
-- @param mA An array of MNname objects.
function M.conflict(self, mA)
   dbg.start{"MasterControl:conflict(mA)"}


   local frameStk  = FrameStk:singleton()
   local mt        = frameStk:mt()
   local fullName  = frameStk:fullName()
   local masterTbl = masterTbl()
   local a         = {}

   for i = 1, #mA do
      local mname    = mA[i]
      local sn       = mname:sn()  -- this will return false if there is no module loaded.
      local userName = mname:userName()
      if (sn and mt:have(sn,"active") and (userName == sn or extractVersion(userName, sn) == mt:version(sn))) then
         a[#a+1]  = userName
      end
   end

   if (#a > 0) then
      LmodError{msg="e_Conflict", name = fullName, module_list = concatTbl(a," ")}
   end
   dbg.fini("MasterControl:conflict")
end

--------------------------------------------------------------------------
-- Check the prereq from *mA*.
-- @param self A MasterControl object.
-- @param mA An array of MNname objects.
function M.prereq(self, mA)
   dbg.start{"MasterControl:prereq(mA)"}

   local frameStk  = FrameStk:singleton()
   local fullName  = frameStk:fullName()
   local masterTbl = masterTbl()

   local a = {}
   for i = 1, #mA do
      local v = mA[i]:prereq()
      if (v) then
         a[#a+1] = v
      end
   end

   dbg.print{"number found: ",#a,"\n"}
   if (#a > 0) then
      LmodError{msg="e_Prereq", name = fullName, module_list = concatTbl(a," ")}
   end
   dbg.fini("MasterControl:prereq")
end

--------------------------------------------------------------------------
-- Check the prereq from *mA*.  If any of them are acceptable then return.
-- otherwise error out.
-- @param self A MasterControl object.
-- @param mA An array of MNname objects.
function M.prereq_any(self, mA)
   dbg.start{"MasterControl:prereq_any(mA)"}
   local frameStk  = FrameStk:singleton()
   local fullName  = frameStk:fullName()
   local masterTbl = masterTbl()
   local found     = false
   local a         = {}

   for i = 1, #mA do
      local v, msg = mA[i]:prereq()
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
      LmodError{msg="e_Prereq_Any", name = fullName, module_list = concatTbl(a," ")}
   end
   dbg.fini("MasterControl:prereq_any")
end

------------------------------------------------------------------------
-- Save away the modules that are in the same family.
-- @param oldName The old module name that is getting pushed out by *sn*.
-- @param sn The new module name.
function M.familyStackPush(oldName, sn)
   dbg.start{"familyStackPush(",oldName,", ", sn,")"}
   local frameStk       = FrameStk:singleton()
   local mt             = frameStk:mt()
   local old_userName   = mt:userName(oldName)
   dbg.print{"removing old sn: ",oldName,",old userName: ",old_userName,"\n"}

   if (old_userName) then
      s_loadT[old_userName] = nil
   end
   s_moduleStk[#s_moduleStk+1] = { sn=oldName, fullName = mt:fullName(oldName),
                                   userName = mt:userName(oldName)}
   s_moduleStk[#s_moduleStk+1] = { sn=sn,      fullName = mt:fullName(sn),
                                   userName = mt:userName(sn)}
   dbg.fini("familyStackPush")
end

function M.familyStackTop()
   local valueN = s_moduleStk[#s_moduleStk]
   local valueO = s_moduleStk[#s_moduleStk-1]
   return valueO, valueN
end


--------------------------------------------------------------------------
-- Pop the top two value off the stack.
-- @return the top two value on the stack.
function M.familyStackPop()
   local valueN = s_moduleStk[#s_moduleStk]
   remove(s_moduleStk)
   local valueO = s_moduleStk[#s_moduleStk]
   remove(s_moduleStk)
   return valueO, valueN
end

--------------------------------------------------------------------------
-- Check for an empty stack.
-- @return True if the stack is empty.
function M.processFamilyStack(fullName)
   if (next(s_moduleStk) ~= nil) then
      return fullName == s_moduleStk[#s_moduleStk].fullName
   end
   return false
end

--------------------------------------------------------------------------
-- Check for an empty stack.
-- @return True if the stack is empty.
function M.familyStackEmpty()
   return (next(s_moduleStk) == nil)
end

--------------------------------------------------------------------------
-- Process the family function.  The name of the module is found by the
-- *ModuleStack*.
-- @param self A MasterControl object
-- @param name The name of the family
function M.family(self, name)
   dbg.start{"MasterControl:family(",name,")"}
   local frameStk  = FrameStk:singleton()
   local mt        = frameStk:mt()
   local fullName  = frameStk:fullName()
   local mname     = MName:new("mt",fullName)
   local sn        = mname:sn()
   local masterTbl = masterTbl()
   local auto_swap = cosmic:value("LMOD_AUTO_SWAP")

   local oldName = mt:getfamily(name)
   if (oldName ~= nil and oldName ~= sn and not expert() ) then
      if (auto_swap ~= "no") then
         self.familyStackPush(oldName, sn)
      else
         LmodError{msg="e_Family_Conflict", name = name, oldName = oldName, fullName = fullName}
      end
   end
   mt:setfamily(name,sn)
   dbg.fini("MasterControl:family")
end

--------------------------------------------------------------------------
-- Unset the family name.
-- @param self A MasterControl object
-- @param name A family name.
function M.unset_family(self, name)
   dbg.start{"MasterControl:unset_family(",name,")"}
   local mt = FrameStk:singleton():mt()
   mt:unsetfamily(name)
   dbg.fini("MasterControl:unset_family")
end

function M.registerAdminMsg(self, mA)
   dbg.start{"MasterControl:registerAdminMsg(mA)"}
   local mt = FrameStk:singleton():mt()
   local t  = s_adminT
   readAdmin()
   for i = 1, #mA do
      local mname = mA[i]
      local sn    = mname:sn()
      if (mt:have(sn,"active")) then
         local fn       = mt:fn(sn)
         local fullName = mt:fullName(sn)
         local message  = nil
         local key

         for i = 1, #adminA do
            local pattern = adminA[i][1]
            if (fullName:find(pattern) or fullName == pattern) then
               message = adminA[i][2]
               key     = fullName
               break
            end
            if (pattern:sub(1,1) == '/' and (fn:find(pattern) or fn == pattern)) then
               message = adminA[i][2]
               key     = fullName
               break
            end
         end
         if (message) then
            t[key] = message
         end
      end
   end
   dbg.fini("MasterControl:registerAdminMsg")
end

-------------------------------------------------------------------
-- Output any admin message collected from loading.
function M.reportAdminMsgs()
   dbg.start{"MasterControl:reportAdminMsgs()"}
   local t = s_adminT
   if (next(t) ~= nil) then
      local term_width  = TermWidth()
      local bt
      local a       = {}
      local border  = colorize("red",string.rep("-", term_width-1))
      io.stderr:write(i18n("m_Module_Msgs",{border=border}))
      for k, v in pairsByKeys(t) do
         io.stderr:write("\n",k,":\n")
         a[1] = { " ", v}
         local maxLen = 0
         for line in v:split("\n") do
            maxLen = max(line:len(), maxLen)
         end
         if (maxLen < term_width - 1) then
            io.stderr:write(v,"\n")
         else
            bt = BeautifulTbl:new{tbl=a, wrapped=true, column=term_width-1}
            io.stderr:write(bt:build_tbl(), "\n")
         end
      end
      io.stderr:write(border,"\n\n")
   end
   dbg.fini("MasterControl:reportAdminMsgs")
end

--------------------------------------------------------------------------
-- Provide a list of modules for sites to use
function M.loaded_modules(self)
   dbg.start{"MasterControl::loaded_modules()"}
   local frameStk  = FrameStk:singleton()
   local mt        = frameStk:mt()
   local mA        = mt:list("fullName","active")
   dbg.fini("MasterControl::loaded_modules")
   return mA
end


--------------------------------------------------------------------------
-- Set a property value
-- @param self A MasterControl Object.
-- @param name A property name
-- @param value A property value.
function M.add_property(self, name, value)
   local frameStk  = FrameStk:singleton()
   local sn        = frameStk:sn()
   local mt        = frameStk:mt()
   mt:add_property(sn, name:trim(), value)
end


--------------------------------------------------------------------------
-- Unset a property value
-- @param self A MasterControl Object.
-- @param name A property name
-- @param value A property value.
function M.remove_property(self, name, value)
   local frameStk  = FrameStk:singleton()
   local sn        = frameStk:sn()
   local mt        = frameStk:mt()
   mt:remove_property(sn, name:trim(), value)
end

--------------------------------------------------------------------------
-- Return the tcl_mode.
-- @param self A MasterControl object
function M.tcl_mode(self)
   return self.my_tcl_mode
end

--------------------------------------------------------------------------
-- Return True when in spider mode.  This version is always false.
-- @param self A MasterControl object
function M.is_spider(self)
   dbg.start{"MasterControl:is_spider()"}
   dbg.print{"This function is deprecated: use mode instead\n"}
   dbg.fini("MasterControl:is_spider")
   return false
end

--------------------------------------------------------------------------
-- Perform a user requested inheritance.  Note that this function remains
-- the same depending on if it is a load or unload.
-- @param self A MasterControl object
function M.inherit(self)
   dbg.start{"MasterControl:inherit()"}
   local master = Master:singleton()
   master.inheritModule()
   dbg.fini("MasterControl:inherit")
end

function M.color_banner(self,color)
   local term_width  = TermWidth()
   local border      = colorize(color or "red",string.rep("=", term_width-1))
   io.stderr:write(border,"\n")
end


function M.set_errorFunc(self, errorFunc)
   metaT = getmetatable(self).__index
   metaT.error = errFunc
end


function M.userInGroups(self, ...)
   local grps   = capture("groups")
   local argA   = pack(...)
   for g in grps:split("[ \n]") do
      for i = 1, argA.n do
         local group = argA[i]
         if (g == group) then
            return true
         end
      end
   end
   local userId = capture("id -u")
   local isRoot = tonumber(userId) == 0
   if (isRoot) then
      return true
   end
   return false
end   
   
function M.missing_module(self,userName, showName)
   s_missingModuleT[userName] = showName
end

return M
