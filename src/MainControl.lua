_G._DEBUG             = false               -- Required by the new lua posix
local posix           = require("posix")

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

Hub                    = require("Hub")

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
local s_performDepCk   = false
local s_missDepT       = {}
local s_missingModuleT = {}
local s_missingFlg     = false
local s_purgeFlg       = false

--------------------------------------------------------------------------
-- Remember the user's requested load array into an internal table.
-- This is tricky because the module mnames in the *mA* array may not be
-- findable yet (e.g. module load mpich petsc).  The only thing we know
-- is the usrName from the command line.  So we use the *usrName* to be
-- the key and not *sn*.
-- @param mA The array of MName objects.
local function l_registerUserLoads(mA)
   dbg.start{"l_registerUserLoads(mA)"}
   for i = 1, #mA do
      local mname       = mA[i]
      local userName    = mname:userName()
      s_loadT[userName] = mname
      dbg.print{"userName: ",userName,"\n"}
   end
   dbg.fini("l_registerUserLoads")
end

local function l_unRegisterUserLoads(mA)
   dbg.start{"l_unRegisterUserLoads(mA)"}
   for i = 1, #mA do
      local mname       = mA[i]
      local userName    = mname:userName()
      s_loadT[userName] = nil
      dbg.print{"userName: ",userName,"\n"}
   end
   dbg.fini("l_unRegisterUserLoads")
end

local function l_compareRequestedLoadsWithActual()
   dbg.start{"l_compareRequestedLoadsWithActual()"}
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
   dbg.fini("l_compareRequestedLoadsWithActual")
   return aa, bb
end

local function l_check_for_valid_name(kind, name)
   local l    = name:len()
   local i, j = name:find("^[a-zA-Z_][a-zA-Z0-9_]*")
   if (j ~= l) then
      LmodError{msg="e_BadName",kind=kind, name=name}
   end
end

local function l_check_for_valid_alias_name(kind, name)
   if (name:find("[ \t]")) then
      LmodError{msg="e_BadAlias",kind=kind, name=name}
   end
end

local function l_createStackName(name)
   return "__LMOD_STACK_" .. name
end

local function l_error_on_missing_loaded_modules(aa,bb)
   if (#aa > 0) then
      local luaprog = findLuaProg()
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
-- @param self A MainControl object
function M.MNameType(self)
   return self.my_sType
end

--------------------------------------------------------------------------
-- Return the tcl_mode.
-- @param self A MainControl object
function M.tcl_mode(self)
   return self.my_tcl_mode
end

--------------------------------------------------------------------------
-- Convert MC name to MC Object.
-- @param nameTbl Name to MC object table.
-- @param name    Name of an MC objects.
local function l_valid_name(nameTbl, name)
   return nameTbl[name] or nameTbl.default
end

--------------------------------------------------------------------------
-- Set the type (or mode) of the current MainControl object.
-- @param self A MainControl object
function M._setMode(self, mode)
   self._mode = mode
end

--------------------------------------------------------------------------
-- The Factory builder for the MainControl Class.
-- @param name the name of the derived object.
-- @param[opt] mode An optional mode for building the *access* object.
-- @return A derived MainControl Object.
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

   local o                = l_valid_name(s_nameTbl, name):create()
   o:_setMode(mode or name)
   o.__first   =  0
   o.__last    = -1
   o.__moduleQ = {}

   dbg.print{"MC:build: Setting mcp to ", o:name(),"\n"}
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
-- @param self A MainControl object.
-- @param name the environment variable name.
-- @param value the environment variable value.
-- @param respect If true, then respect the old value.
function M.setenv(self, name, value, respect)
   name = name:trim()
   dbg.start{"MainControl:setenv(\"",name,"\", \"",value,"\", \"",
              respect,"\")"}

   l_check_for_valid_name("setenv",name)

   if (value == nil) then
      LmodError{msg="e_Missing_Value", func = "setenv", name = name}
   end

   if (respect and getenv(name)) then
      dbg.print{"Respecting old value"}
      dbg.fini("MainControl:setenv")
      return
   end

   local frameStk = FrameStk:singleton()
   local varT     = frameStk:varT()
   if (varT[name] == nil) then
      varT[name] = Var:new(name)
   end
   varT[name]:set(tostring(value))
   dbg.fini("MainControl:setenv")
end


-------------------------------------------------------------------
-- Set an environment variable.
-- This function just sets the name with value in the current env.
function M.setenv_env(self, name, value, respect)
   name = (name or ""):trim()
   dbg.start{"MainControl:setenv_env(\"",name,"\", \"",value,"\", \"",
              respect,"\")"}
   posix.setenv(name, value, true)
   dbg.fini("MainControl:setenv_env")
end


--------------------------------------------------------------------------
-- Unset an environment variable.
-- @param self A MainControl object.
-- @param name the environment variable name.
-- @param value the environment variable value.
-- @param respect If true, then respect the old value.
function M.unsetenv(self, name, value, respect)
   name = (name or ""):trim()
   dbg.start{"MainControl:unsetenv(\"",name,"\", \"",value,"\")"}

   l_check_for_valid_name("unsetenv",name)

   if (respect and getenv(name) ~= value) then
      dbg.print{"Respecting old value"}
      dbg.fini("MainControl:unsetenv")
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
   dbg.fini("MainControl:unsetenv")
end

-------------------------------------------------------------------
-- stack: push and pop
-------------------------------------------------------------------

--------------------------------------------------------------------------
-- Set an environment variable and remember previous values in a stack.
-- @param self A MainControl object.
-- @param name the environment variable name.
-- @param value the environment variable value.
function M.pushenv(self, name, value)
   name = name:trim()
   dbg.start{"MainControl:pushenv(\"",name,"\", \"",value,"\")"}

   l_check_for_valid_name("pushenv",name)
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

   dbg.print{"stackName: ",stackName,", v64: ",v64,"\n"}
   if (varT[stackName] == nil) then
      varT[stackName] = Var:new(stackName, v64, nodups, ":")
   end

   if (value == false) then
      v   = false
      v64 = "false"
   else
      v   = tostring(value)
      v64 = encode64(v)
   end

   local priority = 0

   varT[stackName]:prepend(v64, nodups, priority)

   if (varT[name] == nil) then
      varT[name] = Var:new(name)
   end
   varT[name]:set(v)

   dbg.fini("MainControl:pushenv")
end

--------------------------------------------------------------------------
-- The reverse action of pushenv.  It pops the old value off of the stack
-- and set the *name* to the previous value from the stack.
-- @param self A MainControl object.
-- @param name the environment variable name.
-- @param value the environment variable value.
function M.popenv(self, name, value)
   name = name:trim()
   dbg.start{"MainControl:popenv(\"",name,"\", \"",value,"\")"}

   l_check_for_valid_name("popenv",name)

   local stackName = l_createStackName(name)
   local frameStk = FrameStk:singleton()
   local varT     = frameStk:varT()

   if (varT[stackName] == nil) then
      varT[stackName] = Var:new(stackName)
   end

   
   local v64 = varT[stackName]:pop()
   dbg.print{"stackName: ", stackName,", varT[stackName]:expand(): \"",varT[stackName]:expand() ,"\", v64: \"",v64,"\"\n"}
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

   dbg.fini("MainControl:popenv")
end

-------------------------------------------------------------------
-- Path Modification Functions
-------------------------------------------------------------------


-------------------------------------------------------------------
-- Prepend to a path like variable.
-- @param self A MainControl object
-- @param t A table containing { name, value, nodups=v1, priority=v2}
function M.prepend_path(self, t)
   dbg.start{"MainControl:prepend_path(t)"}
   local delim    = t.delim or ":"
   local name     = t[1]
   local value    = t[2]
   local nodups   = not allow_dups( not t.nodups)
   local priority = (-1)*(t.priority or 0)

   local frameStk = FrameStk:singleton()
   local varT     = frameStk:varT()


   dbg.print{"name:\"",name,"\", value: \"",value,
             "\", delim=\"",delim,"\", nodups=\"",nodups,
             "\", priority=",priority,"\n"}

   l_check_for_valid_name("prepend_path",name)

   if (varT[name] == nil) then
      varT[name] = Var:new(name, nil, nodups, delim)
   end

   -- Do not allow dups on MODULEPATH like env vars.
   nodups = (name == ModulePath) or nodups

   varT[name]:prepend(tostring(value), nodups, priority)
   dbg.fini("MainControl:prepend_path")
end

--------------------------------------------------------------------------
-- Append to a path like variable.
-- @param self A MainControl object
-- @param t A table containing { name, value, nodups=v1, priority=v2}
function M.append_path(self, t)
   local delim    = t.delim or ":"
   local name     = t[1]
   local value    = t[2]
   local nodups   = not allow_dups( not t.nodups)
   local priority = t.priority or 0
   local frameStk = FrameStk:singleton()
   local varT     = frameStk:varT()

   dbg.start{"MainControl:append_path{\"",name,"\", \"",value,
             "\", delim=\"",delim,"\", nodups=\"",nodups,
             "\", priority=",priority,
             "}"}

   l_check_for_valid_name("append_path",name)

   -- Do not allow dups on MODULEPATH like env vars.
   nodups = name == ModulePath or nodups

   if (varT[name] == nil) then
      varT[name] = Var:new(name, false, nodups, delim)
   end

   varT[name]:append(tostring(value), nodups, priority)
   dbg.fini("MainControl:append_path")
end

--------------------------------------------------------------------------
-- Remove an entry from a path like variable.
-- @param self A MainControl object
-- @param t A table containing { name, value, nodups=v1, priority=v2, where=v3, force=v4}
function M.remove_path(self, t)
   local delim    = t.delim or ":"
   local name     = t[1]
   local value    = t[2]
   local nodups   = not allow_dups( not t.nodups)
   local priority = t.priority or 0
   local where    = t.where
   local frameStk = FrameStk:singleton()
   local varT     = frameStk:varT()
   local force    = t.force

   dbg.start{"MainControl:remove_path{\"",name,"\", \"",value,
             "\", delim=\"",delim,"\", nodups=",nodups,
             ", priority=",priority,
             ", where=",where,
             ", force=",force,
             "}"}

   l_check_for_valid_name("remove_path",name)

   -- Do not allow dups on MODULEPATH like env vars.
   nodups = (name == ModulePath) or nodups

   if (varT[name] == nil) then
      varT[name] = Var:new(name,nil, nodups, delim)
   end
   varT[name]:remove(tostring(value), where, priority, nodups, force)
   dbg.fini("MainControl:remove_path")
end

--------------------------------------------------------------------------
-- Remove an entry from a path-like variable.  This version is the reverse
-- of a prepend_path.
-- @param self A MainControl object
-- @param t A table containing { name, value, nodups=v1, priority=v2}
function M.remove_path_first(self, t)
   t.where = "first"
   M.remove_path(self, t)
end

-- Remove an entry from a path-like variable.  This version is the reverse
-- of a append_path.
-- @param self A MainControl object
-- @param t A table containing { name, value, nodups=v1, priority=v2}
function M.remove_path_last(self, t)
   t.where = "last"
   M.remove_path(self, t)
end



--------------------------------------------------------------------------
-- Set a shell alias.  This function can handle a single value for both
-- bash and C-shell.
-- @param self A MainControl Object.
-- @param name the environment variable name.
-- @param value the environment variable value.
function M.set_alias(self, name, value)
   name = name:trim()
   dbg.start{"MainControl:set_alias(\"",name,"\", \"",value,"\")"}

   l_check_for_valid_alias_name("set_alias",name)


   local frameStk = FrameStk:singleton()
   local varT     = frameStk:varT()

   if (varT[name] == nil) then
      varT[name] = Var:new(name)
   end
   varT[name]:setAlias(value)
   dbg.fini("MainControl:set_alias")
end

--------------------------------------------------------------------------
-- Unset a shell alias.
-- @param self A MainControl Object.
-- @param name the environment variable name.
-- @param value the environment variable value.
function M.unset_alias(self, name, value)
   name = name:trim()
   dbg.start{"MainControl:unset_alias(\"",name,"\", \"",value,"\")"}

   local frameStk = FrameStk:singleton()
   local varT     = frameStk:varT()

   if (varT[name] == nil) then
      varT[name] = Var:new(name)
   end
   varT[name]:unsetAlias()
   dbg.fini("MainControl:unset_alias")
end


--------------------------------------------------------------------------
-- Set a shell function for bash and a csh alias.
-- @param self A MainControl Object.
-- @param name the environment variable name.
-- @param value the environment variable value.
function M.set_shell_function(self, name, bash_function, csh_function)
   name = name:trim()
   dbg.start{"MainControl:set_shell_function(\"",name,"\", \"",bash_function,"\"",
             "\", \"",csh_function,"\""}


   l_check_for_valid_alias_name("set_shell_function",name)

   local frameStk = FrameStk:singleton()
   local varT     = frameStk:varT()

   if (varT[name] == nil) then
      varT[name] = Var:new(name)
   end
   varT[name]:setShellFunction(bash_function, csh_function)
   dbg.fini("MainControl:set_shell_function")
end

--------------------------------------------------------------------------
-- Unset a shell function for bash and a csh alias.
-- @param self A MainControl Object.
-- @param name the environment variable name.
-- @param value the environment variable value.
function M.unset_shell_function(self, name, bash_function, csh_function)
   name = name:trim()
   dbg.start{"MainControl:unset_shell_function(\"",name,"\", \"",bash_function,"\"",
             "\", \"",csh_function,"\""}

   local frameStk = FrameStk:singleton()
   local varT     = frameStk:varT()

   if (varT[name] == nil) then
      varT[name] = Var:new(name)
   end
   varT[name]:unsetShellFunction()
   dbg.fini("MainControl:unset_shell_function")
end


--------------------------------------------------------------------------
-- Return the type (or mode) of the current MainControl object.
-- @param self A MainControl object
function M.mode(self)
   return self._mode
end

--------------------------------------------------------------------------
-- Place a string that will be executed when the output from Lmod eval'ed.
-- @param self A MainControl object
-- @param t A table containing A mode array and a command.
function M.execute(self, t)
   dbg.start{"MainControl:execute(t)"}
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
   dbg.fini("MainControl:execute")
end

--------------------------------------------------------------------------
-- Return the user's shell
-- @param self A MainControl object
function M.myShellName(self)
   return Shell and Shell:name() or "bash"
end

function M.myShellType(self)
   local myType = Shell and Shell:type() or "sh"
   return myType
end


--------------------------------------------------------------------------
-- Return the current file name.
-- @param self A MainControl object
function M.myFileName(self)
   local frameStk = FrameStk:singleton()
   return frameStk:fn()
end

--------------------------------------------------------------------------
-- Return the full name of the current module.  Typically name/version.
-- @param self A MainControl object.
function M.myModuleFullName(self)
   local frameStk = FrameStk:singleton()
   return frameStk:fullName()
end

--------------------------------------------------------------------------
-- Return the user name of the current module.  This is the name the user
-- specified.  It could a full name (name/version) or just the name.
-- @param self A MainControl object.
function M.myModuleUsrName(self)
   local frameStk = FrameStk:singleton()
   return frameStk:userName()
end

--------------------------------------------------------------------------
-- Return the name of the modules.  That is the name of the module w/o a
-- version.
-- @param self A MainControl object
function M.myModuleName(self)
   local frameStk = FrameStk:singleton()
   return frameStk:sn()
end

--------------------------------------------------------------------------
-- Return the version if any.  If there is no version, for example a meta
-- module then the version is "".
-- @param self A MainControl object
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
      local msg = i18n(key, t) 
      if (not msg) then
         msg = "Unknown Error Message with unknown key: \"".. key .. "\""
      end
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
-- @param self A MainControl object.
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
-- @param self A MainControl object.
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
-- @param self A MainControl object.
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
-- @param self A MainControl object
function M.quiet(self, ...)
   -- very Quiet !!!
end

function M.mustLoad(self)
   dbg.start{"MainControl:mustLoad()"}

   local aa, bb = l_compareRequestedLoadsWithActual()
   l_error_on_missing_loaded_modules(aa,bb)

   dbg.fini("MainControl:mustLoad")
end


function M.registerDependencyCk(self)
   s_performDepCk = true
end

function M.performDependencyCk(self)
   if (not s_performDepCk) then return end
   dbg.start{"MainControl:performDependencyCk()"}
   
   local hub = Hub:singleton()
   hub:dependencyCk()
   self:reportMissingDepModules()
   dbg.fini("MainControl:performDependencyCk")
end

function M.dependencyCk(self,mA)
   if (dbg.active()) then
      local s = mAList(mA)
      dbg.start{"MainControl:dependencyCk(mA={"..s.."})"}
   end

   local frameStk = FrameStk:singleton()
   local mt       = frameStk:mt()
   local fullName = frameStk:fullName()
   for i = 1,#mA do
      local mname = mA[i]
      if (not mname:isloaded() ) then
         local a = s_missDepT[mname:userName()] or {}
         a[#a+1] = fullName
         s_missDepT[mname:userName()] = a
      end
   end

   dbg.fini("MainControl:dependencyCk")
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
      LmodWarning{msg="w_MissingModules",border=border,missing=concatTbl(a,", ")}
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
      dbg.start{"MainControl:depends_on(mA={"..s.."})"}
   end


   local mB         = {}
   local mt         = FrameStk:singleton():mt()

   for i = 1,#mA do
      local mname = mA[i]
      if (not mname:isloaded()) then
         mname:set_depends_on_flag(true)
         mB[#mB + 1] = mname
      else
         mt:safely_incr_ref_count(mname)
      end
   end

   l_registerUserLoads(mB)
   local a = self:load(mB)

   self:registerDependencyCk()

   dbg.fini("MainControl:depends_on")
   return a
end

-------------------------------------------------------------------
-- forgo a list of modules.  This is the reverse of depends_on()
--
--   if (not isloaded("name")) then load("name") end
--
-- On unload forgo() unloads the ref count is zero.


function M.forgo(self,mA)
   local hub = Hub:singleton()
   if (dbg.active()) then
      local s = mAList(mA)
      dbg.start{"MainControl:forgo(mA={"..s.."})"}
   end

   local mt = FrameStk:singleton():mt()
   local mB = {}
   for i = 1,#mA do
      repeat
         local mname      = mA[i]
         local sn         = mname:sn()
         if (not sn) then break end
         local ref_count  = mt:decr_ref_count(sn)
         if (ref_count and ref_count < 1) then
            mB[#mB+1] = mname
         end
      until true
   end

   l_unRegisterUserLoads(mB)
   local aa     = unload_internal(mB)
   dbg.fini("MainControl:forgo")
   return aa
end



-------------------------------------------------------------------
-- Load a list of modules.  Check to see if the user requested
-- modules were actually loaded.
-- @param self A MainControl object
-- @param mA A array of MName objects.
-- @return An array of statuses
function M.load_usr(self, mA)
   if (dbg.active()) then
      local s = mAList(mA)
      dbg.start{"MainControl:load_usr(mA={"..s.."})"}
   end
   local frameStk = FrameStk:singleton()
   if (checkSyntaxMode() and frameStk:count() > 1) then
      dbg.print{"frameStk:count(): ",frameStk:count(),"\n"}
      dbg.fini("MainControl:load_usr")
      return {}
   end

   l_registerUserLoads(mA)
   local a = self:load(mA)
   dbg.fini("MainControl:load_usr")
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
      dbg.start{"MainControl:load(mA={"..s.."})"}
   end

   local hub = Hub:singleton()
   local a      = hub:load(mA)

   if (not quiet()) then
      self:registerAdminMsg(mA)
   end

   dbg.fini("MainControl:load")
   return a
end

function M.load_any(self, mA)
   if (dbg.active()) then
      local s = mAList(mA)
      dbg.start{"MainControl:load_any(mA={"..s.."})"}
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

   dbg.fini("MainControl:load_any")
   return b
end



function M.mgrload(self, required, active)
   if (dbg.active()) then
      dbg.start{"MainControl:mgrload(required: ",required,", active=",active.userName,")"}
   end

   if (not required) then
      deactivateWarning()
   else
      activateWarning()
   end

   local status = Hub:singleton():mgrload(active)

   dbg.fini("MainControl:mgrload")
   return status
end

function M.mgr_unload(self, required, active)
   if (dbg.active()) then
      dbg.start{"MainControl:mgr_unload(required: ",required,", active=",active.userName,")"}
   end
   local status = unload_internal(MName:new("mt", active.userName))
   dbg.fini("MainControl:mgr_unload")
   return status
end



-------------------------------------------------------------------
-- Load a list of module but ignore any warnings.
-- @param self A MainControl object
-- @param mA A array of MName objects.
function M.try_load(self, mA)
   dbg.start{"MainControl:try_load(mA)"}
   --deactivateWarning()
   self:load(mA)
   dbg.fini("MainControl:try_load")
end

-------------------------------------------------------------------
-- Unload a list modules.
-- @param self A MainControl object
-- @param mA A array of MName objects.
-- @return an array of statuses
function M.unload(self, mA)
   local hub = Hub:singleton()


   if (dbg.active()) then
      local s = mAList(mA)
      dbg.start{"MainControl:unload(mA={"..s.."})"}
   end

   l_unRegisterUserLoads(mA)
   local aa     = hub:unload(mA)
   dbg.fini("MainControl:unload")
   return aa
end

function M.build_unload(self)
   local mcp = MainControl.build("unload")
   dbg.print{"MC:build_unload: Setting mcp to ", mcp:name(),"\n"}
   return mcp
end

function M.do_not_build_unload(self)
   return self
end


-------------------------------------------------------------------
-- Unload a user requested list of modules.
-- @param self A MainControl object
-- @param mA A array of MName objects.
-- @param force if true then do not reload sticky modules.
-- @return an array of statuses.
function M.unload_usr(self, mA, force)
   dbg.start{"MainControl:unload_usr(mA)"}

   M.unload(self,mA)
   local hub = Hub:singleton()
   local aa = hub:reload_sticky(force)

   self:registerDependencyCk()
   --hub:dependencyCk()

   dbg.fini("MainControl:unload_usr")
   return aa
end

-------------------------------------------------------------------
-- This load is used by Manager Load to ignore load inside a
-- module.
-- @param self A MainControl object
-- @param mA A array of MName objects.
function M.fake_load(self,mA)
   if (dbg.active()) then
      local s = mAList(mA)
      dbg.start{"MainControl:fake_load(mA={"..s.."})"}
      dbg.fini("MainControl:fake_load")
   end
end

--------------------------------------------------------------------------
-- Check the conflicts from *mA*.
-- @param self A MainControl object.
-- @param mA An array of MNname objects.
function M.conflict(self, mA)
   dbg.start{"MainControl:conflict(mA)"}


   local frameStk  = FrameStk:singleton()
   local mt        = frameStk:mt()
   local fullName  = frameStk:fullName()
   local optionTbl = optionTbl()
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
   dbg.fini("MainControl:conflict")
end

--------------------------------------------------------------------------
-- Check the prereq from *mA*.
-- @param self A MainControl object.
-- @param mA An array of MNname objects.
function M.prereq(self, mA)
   dbg.start{"MainControl:prereq(mA)"}

   local frameStk  = FrameStk:singleton()
   local fullName  = frameStk:fullName()
   local optionTbl = optionTbl()

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
   dbg.fini("MainControl:prereq")
end

--------------------------------------------------------------------------
-- Check the prereq from *mA*.  If any of them are acceptable then return.
-- otherwise error out.
-- @param self A MainControl object.
-- @param mA An array of MNname objects.
function M.prereq_any(self, mA)
   dbg.start{"MainControl:prereq_any(mA)"}
   local frameStk  = FrameStk:singleton()
   local fullName  = frameStk:fullName()
   local optionTbl = optionTbl()
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
   dbg.fini("MainControl:prereq_any")
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
-- @param self A MainControl object
-- @param name The name of the family
function M.family(self, name)
   dbg.start{"MainControl:family(",name,")"}
   local frameStk  = FrameStk:singleton()
   local mt        = frameStk:mt()
   local fullName  = frameStk:fullName()
   local mname     = MName:new("mt",fullName)
   local sn        = mname:sn()
   local optionTbl = optionTbl()
   local auto_swap = cosmic:value("LMOD_AUTO_SWAP")

   l_check_for_valid_name("family",name)

   local oldName = mt:getfamily(name)
   if (oldName ~= nil and oldName ~= sn and not expert() ) then
      if (auto_swap ~= "no") then
         self.familyStackPush(oldName, sn)
      else
         LmodError{msg="e_Family_Conflict", name = name, oldName = oldName, fullName = fullName}
      end
   end
   mt:setfamily(name,sn)
   dbg.fini("MainControl:family")
end

--------------------------------------------------------------------------
-- Unset the family name.
-- @param self A MainControl object
-- @param name A family name.
function M.unset_family(self, name)
   dbg.start{"MainControl:unset_family(",name,")"}
   local mt = FrameStk:singleton():mt()
   mt:unsetfamily(name)
   dbg.fini("MainControl:unset_family")
end

function M.registerAdminMsg(self, mA)
   dbg.start{"MainControl:registerAdminMsg(mA)"}
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
   dbg.fini("MainControl:registerAdminMsg")
end

-------------------------------------------------------------------
-- Output any admin message collected from loading.
function M.reportAdminMsgs()
   dbg.start{"MainControl:reportAdminMsgs()"}
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
   dbg.fini("MainControl:reportAdminMsgs")
end

--------------------------------------------------------------------------
-- Provide a list of modules for sites to use
function M.loaded_modules(self)
   dbg.start{"MainControl::loaded_modules()"}
   local frameStk  = FrameStk:singleton()
   local mt        = frameStk:mt()
   local mA        = mt:list("fullName","active")
   dbg.fini("MainControl::loaded_modules")
   return mA
end


--------------------------------------------------------------------------
-- Set a property value
-- @param self A MainControl Object.
-- @param name A property name
-- @param value A property value.
function M.add_property(self, name, value)
   local frameStk  = FrameStk:singleton()
   local sn        = frameStk:sn()
   local mt        = frameStk:mt()
   l_check_for_valid_name("add_property",name)
   mt:add_property(sn, name:trim(), value)
end


--------------------------------------------------------------------------
-- Unset a property value
-- @param self A MainControl Object.
-- @param name A property name
-- @param value A property value.
function M.remove_property(self, name, value)
   local frameStk  = FrameStk:singleton()
   local sn        = frameStk:sn()
   local mt        = frameStk:mt()
   l_check_for_valid_name("remove_property",name)
   mt:remove_property(sn, name:trim(), value)
end


function purgeFlg()
   return s_purgeFlg
end


function M.purge(self,t)
   local force = false
   if (type(t) == "table") then
      force = t.force
   end

   local frameStk = FrameStk:singleton()
   local mt       = frameStk:mt()
   local totalA   = mt:list("short","any") --> "any" does not include "pending"

   if (#totalA < 1) then
      return
   end

   local mA = {}
   for i = #totalA,1,-1 do
      mA[#mA+1] = MName:new("mt",totalA[i])
   end
   s_purgeFlg = true
   unload_usr_internal(mA, force)
   s_purgeFlg = false

   -- A purge should not set the warning flag.
   clearWarningFlag()
   dbg.print{"warningFlag: ", getWarningFlag(),"\n"}
   dbg.fini("MainControl:Purge")
end
   



--------------------------------------------------------------------------
-- Return the tcl_mode.
-- @param self A MainControl object
function M.tcl_mode(self)
   return self.my_tcl_mode
end

--------------------------------------------------------------------------
-- Return True when in spider mode.  This version is always false.
-- @param self A MainControl object
function M.is_spider(self)
   dbg.start{"MainControl:is_spider()"}
   dbg.print{"This function is deprecated: use mode instead\n"}
   dbg.fini("MainControl:is_spider")
   return false
end

--------------------------------------------------------------------------
-- Perform a user requested inheritance.  Note that this function remains
-- the same depending on if it is a load or unload.
-- @param self A MainControl object
function M.inherit(self)
   dbg.start{"MainControl:inherit()"}
   local hub = Hub:singleton()
   hub.inheritModule()
   dbg.fini("MainControl:inherit")
end

function M.source_sh(self, shellName, script)
   dbg.start{"MainControl:source_sh(shellName: \"",shellName,"\", script: \"",script,"\")"}
   local frameStk     = FrameStk:singleton()
   local sn           = frameStk:sn()
   local mt           = frameStk:mt()
   local convertSh2MF = require("convertSh2MF")

   local mcmdA        = mt:get_sh2mf_cmds(sn, script)
   local success
   local msg
   if (mcmdA == nil) then
      success, msg, mcmdA = convertSh2MF(shellName, "lua", script)
      if (not success) then LmodError(msg) end
      mt:add_sh2mf_cmds(sn, script, mcmdA)
   end
 
   local whole = concatTbl(mcmdA,"\n")
   dbg.print{"whole:\n ",whole,"\n"}
   local status, msg = sandbox_run(whole)
   if (not status) then
      LmodError{msg="e_Unable_2_Load", name = mt:userName(sn), fn = mt:fn(sn), message = msg}
   end
   dbg.fini("MainControl:source_sh")
end

function M.un_source_sh(self, shellName, script)
   dbg.start{"MainControl:un_source_sh(shellName: \"",shellName,"\", script: \"",script,"\")"}
   local frameStk    = FrameStk:singleton()
   local sn          = frameStk:sn()
   local mt          = frameStk:mt()
   local mcmdA       = mt:get_sh2mf_cmds(sn, script)
   local whole       = concatTbl(mcmdA,"\n")
   dbg.print{"whole:\n ",whole,"\n"}
   local status, msg = sandbox_run(whole)
   if (not status) then
      LmodError{msg="e_Unable_2_Load", name = mt:userName(sn), fn = mt:nf(sn), message = msg}
   end
   dbg.fini("MainControl:un_source_sh")
end

function M.complete(self, shellName, name, args)
   dbg.start{"MainControl:complete(shellName: \"",shellName,"\", name: \"",name,"\", args: \"",args,"\""}
   if (myShellName() ~= shellName) then
      dbg.fini("MainControl:complete")
      return
   end
   
   local varT = FrameStk:singleton():varT()
   local n    = wrap_complete(name)
   if (varT[n] == nil) then
      varT[n] = Var:new(n)
   end
   varT[n]:complete(args)
   dbg.fini("MainControl:complete")
end

function M.uncomplete(self, shellName, name, args)
   dbg.start{"MainControl:uncomplete(shellName: \"",shellName,"\", name: \"",name,"\", args: \"",args,"\""}
   if (myShellName() ~= shellName) then
      dbg.fini("MainControl:complete")
      return
   end
   local varT = FrameStk:singleton():varT()
   local n    = wrap_complete(name)
   if (varT[n] == nil) then
      varT[n] = Var:new(n)
   end
   varT[n]:uncomplete()

   dbg.fini("MainControl:uncomplete")
end



function M.color_banner(self,color)
   if (quiet()) then
      return
   end
   local term_width  = TermWidth()
   local border      = colorize(color or "red",string.rep("=", term_width-1))
   io.stderr:write(border,"\n")
end


function M.set_errorFunc(self, errorFunc)
   metaT = getmetatable(self).__index
   metaT.error = errFunc
end

function M.LmodBreak(self, msg)
   dbg.start{"MainControl:LmodBreak(msg=\"",msg,"\")"}
   local frameStk  = FrameStk:singleton()
   local tracing   = cosmic:value("LMOD_TRACING")
   local shell     = _G.Shell

   if (tracing == "yes") then
      local stackDepth = frameStk:stackDepth()
      local indent     = ("  "):rep(stackDepth+1)
      local b          = {}
      b[#b + 1]        = indent
      b[#b + 1]        = "LmodBreak called\n"
      shell:echo(concatTbl(b,""))
   end


   if (msg and msg ~= "") then
      LmodMessage(msg)
   end

   -- Remove this module from the list of user requested modules to load.
   local sn    = frameStk:sn()
   local mname = MName:new("mt",sn)
   l_unRegisterUserLoads{mname}

   -- Copy the previous frameStk on top of the current stack
   -- Then throw an error to stop execution of the current module.
   frameStk:LmodBreak()
   error({code="LmodBreak"})
   dbg.fini("MainControl:LmodBreak")
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

function M.haveDynamicMPATH(self)
   -- This function is non-empty when in Spider mode only
end

return M
