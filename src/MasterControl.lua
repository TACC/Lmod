--------------------------------------------------------------------------
--  MasterControl is the base class for all the MC_Load, MC_Unload derived
--  classes.  It has the Factory build member function as well as the
--  functions that execute the commands from the modulefiles.  It may be
--  helpful to understand the flow of control:
--
--    0. An MCP object is constructed (load, unload, show, help, etc)
--    1. A modulefile is read and evaluated.
--    2. A function in modfuncs is called.
--    3. These modfuncs call a member function of the mcp object.
--    4. All these member functions are implemented here.
--
--  So for example if the mcp object is a load version then
--  when a modulefile calls setenv then the steps are:
--    a) setenv(...) is called in modfuncs
--    b) This calls mcp:setenv(...)
--    c) the mcp load version connects it to MasterControl:setenv
--
--  Suppose a user is requesting to unload a module which contains a
--  setenv command.
--    0. An MCP unload object is constructed.
--    1. The module file is read and evaluated
--    2. The setenv function in modfuncs is called
--    3. The unload MCP objects maps this to MasterControl:unsetenv
--    4. The users' environment variable is unset.
--
--  As a convention: MCP is always for loads while the purpose of mcp is
--  dynamic.
--
--  The rational behind this design is to support all the ways a modulefile can
--  be evaluated.
--
--  In a module file, the change to the environment upon loading are specified:
--  set a variable, prepend something to a variable, etc. When you 'unload' the
--  module, these changes need to get reversed. So depending on the 'mode' (load,
--  unloading, ...), 'setenv' will have a different meaning. Instead of using 'if'
--  statements, the current design allows in an elegant way to the define the
--  different 'setenv' commands. There are at least 8 modes and they can be
--  found in the function 'M.build' below.
--
-- @classmod MasterControl

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

require("TermWidth")
require("string_utils")
require("inherits")
require("utils")
require("myGlobals")

local M            = {}
local BeautifulTbl = require("BeautifulTbl")
local abs          = math.abs
local max          = math.max
local dbg          = require("Dbg"):dbg()
local Exec         = require("Exec")
local MName        = require("MName")
local ModulePath   = ModulePath
local ModuleStack  = require("ModuleStack")
local Var          = require("Var")
local base64       = require("base64")
local concatTbl    = table.concat
local decode64     = base64.decode64
local encode64     = base64.encode64
local getenv       = os.getenv
local hook         = require("Hook")
local remove       = table.remove
local pack         = (_VERSION == "Lua 5.1") and argsPack or table.pack
local Exit         = os.exit
local s_moduleStk  = {}
local s_loadT      = {}

--------------------------------------------------------------------------
-- Check list of modules requested from user to see if they got loaded.
-- If not found check with spider to see if a module can be loaded.
function M.mustLoad()

   local aa, bb = mcp.familyLoaded()

   if (#aa > 0) then
      local luaprog = "@path_to_lua@/lua"
      if (luaprog:sub(1,1) == "@") then
         luaprog = find_exec_path("lua")
         if (luaprog == nil) then
            LmodError("Unable to find the lua program")
         end
      end
      local cmdA = {}
      cmdA[#cmdA+1] = luaprog
      cmdA[#cmdA+1] = pathJoin(cmdDir(),cmdName())
      cmdA[#cmdA+1] = "bash"
      cmdA[#cmdA+1] = "-r --spider_timeout 2.0 spider"
      local count   = #cmdA

      local uA = {}  -- unknown names
      local kA = {}  -- known modules (show)
      local kB = {}  -- known modules (usrName)


      if (expert()) then
         uA = aa
      else
         for i = 1, #bb do
            cmdA[count+1] = "'^" .. bb[i]:escape() .. "$'"
            cmdA[count+2] = "2> /dev/null"
            local cmd     = concatTbl(cmdA," ")
            local result  = capture(cmd)
            if (result:find("\nfalse")) then
               uA[#uA+1] = aa[i]
            else
               kA[#kA+1] = aa[i]
               kB[#kB+1] = bb[i]
            end
         end
      end

      local a = {}

      if (#uA > 0) then
         a[#a+1] = "The following module(s) are unknown: "
         a[#a+1] = concatTbl(uA, " ")
         a[#a+1] = "\n\nPlease check the spelling or version number. "
         a[#a+1] = "Also try \"module spider ...\"\n"
      end

      if (#kA > 0) then
         a[#a+1] = "These module(s) exist but cannot be loaded as requested: "
         a[#a+1] = concatTbl(kA,", ")
         a[#a+1] = "\n\n   Try: \"module spider "
         a[#a+1] = concatTbl(kB, " ")
         a[#a+1] = "\" to see how to load the module(s)."
         a[#a+1] = "\n\n"
      end

      if (#a > 0) then
         mcp:report(concatTbl(a,""))
      end
   end
end

--------------------------------------------------------------------------
-- Build a list of user names based on mA.
-- @param mA List of MName objects
local function mAList(mA)
   local a = {}
   for i = 1, #mA do
      a[#a + 1] = mA[i]:usrName()
   end
   return concatTbl(a, ", ")
end

--------------------------------------------------------------------------
-- Return the name of the derived MC object.
-- @param self A MasterControl object
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
-- The Factory builder for the MasterControl Class.
-- @param name the name of the derived object.
-- @param[opt] mode An optional mode for building the *access* object.
-- @return A derived MasterControl Object.
local s_nameTbl     = false
function M.build(name,mode)

   if (not s_nameTbl) then
      local MCLoad        = require('MC_Load')
      local MCUnload      = require('MC_Unload')
      local MCMgrLoad     = require('MC_MgrLoad')
      local MCRefresh     = require('MC_Refresh')
      local MCShow        = require('MC_Show')
      local MCAccess      = require('MC_Access')
      local MCSpider      = require('MC_Spider')
      local MCComputeHash = require('MC_ComputeHash')
      s_nameTbl = {
         ["load"]        = MCLoad,        -- Normal loading of modules
         ["mgrload"]     = MCMgrLoad,     -- for collections (loads in modules are ignored)
         ["unload"]      = MCUnload,      -- Unload modules
         ["refresh"]     = MCRefresh,     -- for subshells, sets the aliases again
         ["computeHash"] = MCComputeHash, -- Generate a hash value for the contents of the module
         ["refresh"]     = MCRefresh,     -- for subshells, sets the aliases again
         ["show"]        = MCShow,        -- show the module function instead.
         ["access"]      = MCAccess,      -- for whatis, help
         ["spider"]      = MCSpider,      -- Process module files for spider operations
      }
      s_nameTbl.default        = MCLoad
   end

   local o                = valid_name(s_nameTbl, name):create()
   o:_setMode(mode or name)


   dbg.print{"Setting mcp to ", o:name(),"\n"}
   return o
end


-------------------------------------------------------------------
-- Load a list of modules.  Check to see if the user requested
-- modules were actually loaded.
-- @param self A MasterControl object
-- @param mA A array of MName objects.
-- @return An array of statuses
function M.load_usr(self, mA)
   self.familyLoadRegister(mA)
   local a = self:load(mA)
   return a
end

-------------------------------------------------------------------
-- Load a list of modules. Check to see if there are any admin
-- messages.
-- @param self A MasterControl object
-- @param mA A array of MName objects.
-- @return An array of statuses

s_adminT = {}

function M.load(self, mA)
   local master = Master:master()

   if (dbg.active()) then
      local s = mAList(mA)
      dbg.start{"MasterControl:load(mA={"..s.."})"}
   end

   local a = master.load(mA)
   if (not quiet()) then
      self:registerAdminMsg(mA)
   end

   dbg.fini("MasterControl:load")

   return a
end

function M.registerAdminMsg(self, mA)
   local mt      = MT:mt()
   local t       = s_adminT
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
end


-------------------------------------------------------------------
-- Output any admin message collected from loading.
function M.reportAdminMsgs()
   local t = s_adminT
   if (next(t) ) then
      local term_width  = TermWidth()
      local bt
      local a       = {}
      local border  = colorize("red",string.rep("-", term_width-1))
      io.stderr:write("\n",border,"\n",
                      "There are messages associated with the following module(s):\n",
                      border,"\n")
      for k, v in pairsByKeys(t) do
         io.stderr:write("\n",k,":\n")
         a[1] = { " ", v}
         bt = BeautifulTbl:new{tbl=a, wrapped=true, column=term_width-1}
         io.stderr:write(bt:build_tbl(), "\n")
      end
      io.stderr:write(border,"\n\n")
   end
end

-------------------------------------------------------------------
-- Load a list of module but ignore any warnings.
-- @param self A MasterControl object
-- @param mA A array of MName objects.
function M.try_load(self, mA)
   dbg.start{"MasterControl:try_load(mA)"}
   deactivateWarning()
   self:load(mA)
   dbg.fini("MasterControl:try_load")
end

-------------------------------------------------------------------
-- Unload a list modules.
-- @param self A MasterControl object
-- @param mA A array of MName objects.
-- @return an array of statuses
function M.unload(self, mA)
   local master = Master:master()
   local mt     = MT:mt()

   if (dbg.active()) then
      local s = mAList(mA)
      dbg.start{"MasterControl:unload(mA={"..s.."})"}
   end

   local aa     = master.unload(mA)
   if (dbg.active()) then
      dbg.fini("MasterControl:unload")
   end
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
   local master = Master:master()
   local aa = master:reload_sticky(force)
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


-------------------------------------------------------------------
-- Path Modification Functions
-------------------------------------------------------------------
LMOD_MP_T = {}

LMOD_MP_T[ModulePath]  = true
LMOD_MP_T[DfltModPath] = true


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
   dbg.print{"name:\"",name,"\", value: \"",value,
             "\", delim=\"",sep,"\", nodups=\"",nodups,
             "\", priority=",priority,"\n"}

   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name, nil, sep)
   end

   -- Do not allow dups on MODULEPATH like env vars.
   nodups = LMOD_MP_T[name] or nodups

   varTbl[name]:prepend(tostring(value), nodups, priority)
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
   local nodups   = t.nodups
   local priority = t.priority or 0
   dbg.start{"MasterControl:append_path{\"",name,"\", \"",value,
             "\", delim=\"",sep,"\", nodups=\"",nodups,
             "\", priority=",priority,
             "}"}

   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name, nil, sep)
   end

   -- Do not allow dups on MODULEPATH like env vars.
   nodups = LMOD_MP_T[name] or nodups

   varTbl[name]:append(tostring(value), nodups, priority)
   dbg.fini("MasterControl:append_path")
end

--------------------------------------------------------------------------
-- Remove an entry from a path like variable.
-- @param self A MasterControl object
-- @param t A table containing { name, value, nodups=v1, priority=v2, where=v3}
function M.remove_path(self, t)
   local sep      = t.delim or ":"
   local name     = t[1]
   local value    = t[2]
   local nodups   = t.nodups
   local priority = t.priority or 0
   local where    = t.where
   dbg.start{"MasterControl:remove_path{\"",name,"\", \"",value,
             "\", delim=\"",sep,"\", nodups=\"",nodups,
             "\", priority=",priority,
             ", where=",where,
             "}"}

   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name,nil, sep)
   end
   varTbl[name]:remove(tostring(value), where, priority, nodups)
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


-------------------------------------------------------------------
-- Setenv / Unsetenv Functions
-------------------------------------------------------------------

--------------------------------------------------------------------------
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
      LmodError("setenv(\"",name,"\") is not valid, a value is required")
   end

   if (respect and getenv(name)) then
      dbg.print{"Respecting old value"}
      dbg.fini("MasterControl:setenv")
      return
   end


   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name)
   end
   varTbl[name]:set(tostring(value))
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

   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name)
   end
   varTbl[name]:unset()
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
      LmodError("pushenv(\"",name,"\") is not valid, a value is required")
   end

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
   local nodups  = false
   local priority = 0

   varTbl[stackName]:prepend(v64, nodups, priority)

   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name)
   end
   varTbl[name]:set(v)

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

   local stackName = "__LMOD_STACK_" .. name
   if (varTbl[stackName] == nil) then
      varTbl[stackName] = Var:new(stackName)
   end

   dbg.print{"stackName: ", stackName, " pop()\n"}

   local v64 = varTbl[stackName]:pop()
   local v   = nil
   if (v64) then
      v = decode64(v64)
   end
   dbg.print{"v: ", v,"\n"}

   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name)
   end

   varTbl[name]:set(v)

   dbg.fini("MasterControl:popenv")
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


   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name)
   end
   varTbl[name]:setAlias(value)
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

   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name)
   end
   varTbl[name]:unsetAlias()
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


   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name)
   end
   varTbl[name]:setShellFunction(bash_function, csh_function)
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

   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name)
   end
   varTbl[name]:unsetShellFunction()
   dbg.fini("MasterControl:unset_shell_function")
end

-------------------------------------------------------------------
-- Property Functions
-------------------------------------------------------------------

--------------------------------------------------------------------------
-- Set a property value
-- @param self A MasterControl Object.
-- @param name A property name
-- @param value A property value.
function M.add_property(self, name, value)
   local mStack  = ModuleStack:moduleStack()
   local mFull   = mStack:fullName()
   local mt      = MT:mt()
   local mname   = MName:new("load",mFull)
   mt:add_property(mname:sn(), name:trim(), value)
end

--------------------------------------------------------------------------
-- Unset a property value
-- @param self A MasterControl Object.
-- @param name A property name
-- @param value A property value.
function M.remove_property(self, name, value)
   name = name:trim()
   local mStack  = ModuleStack:moduleStack()
   local mFull   = mStack:fullName()
   local mt      = MT:mt()
   local mname   = MName:new("mt",mFull)
   mt:remove_property(mname:sn(), name:trim(), value)
end


--------------------------------------------------------------------------
-- Report the modulefiles stack for error report.
function moduleStackTraceBack(msg)
   local mStack = ModuleStack:moduleStack()
   msg = msg or "While processing the following module(s):\n"
   if (mStack:empty()) then return "" end

   local aa = {}
   aa[1]    = { "  ", "Module fullname", "Module Filename"}
   aa[2]    = { "  ", "---------------", "---------------"}

   local a  = mStack:traceBack()

   for i = 1,#a do
      local entry = a[i]
      aa[#aa+1] = {"  ",entry.fullName, entry.fn}
   end

   local bt = BeautifulTbl:new{tbl=aa}

   local bb = {}
   bb[#bb+1] = msg
   bb[#bb+1] = bt:build_tbl()
   return concatTbl(bb,"")
end

--------------------------------------------------------------------------
-- Write "false" to stdout and exit.
function LmodErrorExit()
   io.stdout:write("false\n")
   Exit(1)
end

--------------------------------------------------------------------------
-- Print msgs, traceback then exit.
function LmodSystemError(...)
   local label  = colorize("red", "Lmod has detected the following error: ")
   local twidth = TermWidth()
   local s      = {}
   s[#s+1] = buildMsg(twidth, label, ...)
   s[#s+1] = "\n"

   local a = concatTbl(stackTraceBackA,"")
   if (a:len() > 0) then
       s[#s+1] = a
       s[#s+1] = "\n"
   end

   a = moduleStackTraceBack()
   if (a ~= "") then
       s[#s+1] = a
       s[#s+1] = "\n"
   end

   s = hook.apply("msgHook","lmoderror",s)
   s = concatTbl(s,"")

   io.stderr:write(s,"\n")
   LmodErrorExit()
end


--------------------------------------------------------------------------
-- Print msgs, traceback then exit.
-- @param self A MasterControl object.
function M.error(self, ...)
   LmodSystemError(...)
end

--------------------------------------------------------------------------
-- Print msgs, traceback then set warning flag.
-- @param self A MasterControl object.
function M.warning(self, ...)
   if (not quiet() and  haveWarnings()) then
      local label  = colorize("red", "Lmod Warning: ")
      local twidth = TermWidth()
      local s      = {}
      s[#s+1] = buildMsg(twidth, label, ...)
      s[#s+1] = "\n"

      local a = moduleStackTraceBack()
      if (a ~= "") then
          s[#s+1] = a
          s[#s+1] = "\n"
      end

      s = hook.apply("msgHook","lmodwarning",s)
      s = concatTbl(s,"")

      io.stderr:write(s,"\n")
      setWarningFlag()
   end
end


--------------------------------------------------------------------------
-- Print msgs to stderr.
-- @param self A MasterControl object.
function M.message(self, ...)
   if (quiet()) then
      return
   end
   local arg = pack(...)
   for i = 1, arg.n do
      io.stderr:write(tostring(arg[i]))
   end
   io.stderr:write("\n")
end



--------------------------------------------------------------------------
-- Check the prereq from *mA*.
-- @param self A MasterControl object.
-- @param mA An array of MNname objects.
function M.prereq(self, mA)
   local mt        = MT:mt()
   local mStack    = ModuleStack:moduleStack()
   local mFull     = mStack:fullName()
   local masterTbl = masterTbl()

   dbg.start{"MasterControl:prereq(mA)"}

   if (masterTbl.checkSyntax) then
      dbg.print{"Ignoring prereq when syntax checking\n"}
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

   dbg.print{"number found: ",#a,"\n"}
   if (#a > 0) then
      local s = concatTbl(a," ")
      LmodError("Cannot load module \"",mFull,"\" without these module(s) loaded:\n  ",
            s,"\n")
   end
   dbg.fini("MasterControl:prereq")
end

--------------------------------------------------------------------------
-- Check the conflicts from *mA*.
-- @param self A MasterControl object.
-- @param mA An array of MNname objects.
function M.conflict(self, mA)
   dbg.start{"MasterControl:conflict(mA)"}


   local mt        = MT:mt()
   local mStack    = ModuleStack:moduleStack()
   local mFull     = mStack:fullName()
   local masterTbl = masterTbl()

   if (masterTbl.checkSyntax) then
      dbg.print{"Ignoring conflicts when syntax checking\n"}
      dbg.fini("MasterControl:conflict")
      return
   end

   local a = {}
   for i = 1, #mA do
      local mname = mA[i]
      local sn    = mname:sn()
      if (mt:have(sn,"active")) then
         a[#a+1]  = mname:usrName()
      end
   end

   --for i = 1, #mA do
   --   local mname   = mA[i]
   --   local v       = mname:usrName()
   --   local sn      = mname:sn()
   --   local version = extractVersion(v, sn)
   --   local found   = false
   --   if (version) then
   --      found = mt:fullName(sn) == mname:usrName()
   --   else
   --      found = mt:have(sn,"active")
   --   end
   --   if (found) then
   --      a[#a+1] = v
   --   end
   --end

   if (#a > 0) then
      local s = concatTbl(a," ")
      LmodError("Cannot load module \"",mFull,"\" because these module(s) are loaded:\n  ",
            s,"\n")
   end
   dbg.fini("MasterControl:conflict")
end

--------------------------------------------------------------------------
-- Check the prereq from *mA*.  If any of them are acceptable then return.
-- otherwise error out.
-- @param self A MasterControl object.
-- @param mA An array of MNname objects.
function M.prereq_any(self, mA)
   local mt        = MT:mt()
   local mStack    = ModuleStack:moduleStack()
   local mFull     = mStack:fullName()
   local masterTbl = masterTbl()

   dbg.start{"MasterControl:prereq_any(mA)"}

   if (masterTbl.checkSyntax) then
      dbg.print{"Ignoring prereq_any when syntax checking\n"}
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
      LmodError("Cannot load module \"",mFull,"\".  At least one of these module(s) must be loaded:\n  ",
            concatTbl(a,", "),"\n")
   end
   dbg.fini("MasterControl:prereq_any")
end


--------------------------------------------------------------------------
-- Remember the user's requested load array into an internal table.
-- This is tricky because the module mnames in the *mA* array may not be
-- findable yet (e.g. module load mpich petsc).  The only thing we know
-- is the usrName from the command line.  So we use the *usrName* to be
-- the key and not *sn*.
-- @param mA The array of MName objects.
function M.familyLoadRegister(mA)
   dbg.start{"familyLoadRegister(mA)"}
   for i = 1, #mA do
      local mname      = mA[i]
      local usrName    = mname:usrName()
      s_loadT[usrName] = mname
      dbg.print{"usrName: ",usrName,"\n"}
   end

   dbg.fini("familyLoadRegister")
end

--------------------------------------------------------------------------
-- Check the currently loaded table modules to see if any didn't get
-- loaded.
-- @return An array of descripted name of missing modules.
-- @return An array of the user names of missing modules.
function M.familyLoaded()
   dbg.start{"MC:familyLoaded()"}
   local mt        = MT:mt()

   local aa = {}
   local bb = {}

   for usrName, mname in pairs(s_loadT) do
      local sn = mname:sn()
      dbg.print{"usrName: ",usrName, " is ", not not mt:have(sn, "active"), "\n"}
      if (not mt:have(sn, "active")) then
         aa[#aa+1] = mname:show()
         bb[#bb+1] = usrName
      end
   end

   dbg.fini("MC:familyLoaded")
   return aa, bb
end

------------------------------------------------------------------------
-- Save away the modules that are in the same family.
-- @param oldName The old module name that is getting pushed out by *sn*.
-- @param sn The new module name.
function M.familyStackPush(oldName, sn)
   dbg.start{"familyStackPush(",oldName,", ", sn,")"}
   local mt             = MT:mt()
   local old_usrName    = mt:usrName(oldName)
   dbg.print{"removing old sn: ",oldName,",old usrName: ",old_usrName,"\n"}

   s_loadT[old_usrName] = nil
   s_moduleStk[#s_moduleStk+1] = { sn=oldName, fullName = mt:fullName(oldName),
                                   usrName = mt:usrName(oldName)}
   s_moduleStk[#s_moduleStk+1] = { sn=sn,      fullName = mt:fullName(sn),
                                   usrName = mt:usrName(sn)}
   dbg.fini("familyStackPush")
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
function M.familyStackEmpty()
   return (next(s_moduleStk) == nil)
end

--------------------------------------------------------------------------
-- Process the family function.  The name of the module is found by the
-- *ModuleStack*.
-- @param self A MasterControl object
-- @param name The name of the family
function M.family(self, name)
   local mt        = MT:mt()
   local mStack    = ModuleStack:moduleStack()
   local mFull     = mStack:fullName()
   local mname     = MName:new("mt",mFull)
   local sn        = mname:sn()
   local masterTbl = masterTbl()

   dbg.start{"MasterControl:family(",name,")"}
   if (masterTbl.checkSyntax) then
      dbg.print{"Ignoring family when syntax checking\n"}
      dbg.fini()
      return
   end

   dbg.print{"mt:setfamily(\"",name,"\",\"",sn,"\")\n"}
   local oldName = mt:getfamily(name)
   if (oldName ~= nil and oldName ~= sn and not expert() ) then
      if (LMOD_AUTO_SWAP ~= "no") then
         dbg.print{"RTM Fmly Push sn: ",sn,", oldName: ",oldName,"\n"}
         self.familyStackPush(oldName, sn)
      else
         LmodError("You can only have one ",name," module loaded at a time.\n",
                   "You already have ", oldName," loaded.\n",
                   "To correct the situation, please enter the following command:\n\n",
                   "  module swap ",oldName, " ", mFull,"\n\n",
                   "Please submit a consulting ticket if you require additional assistance.\n")
      end
   end
   mt:setfamily(name,sn)
   dbg.fini("MasterControl:family")
end

--------------------------------------------------------------------------
-- Return the user's shell
-- @param self A MasterControl object
function M.myShellName(self)
   local master = _G.Master:master()
   return master.shell:name()
end

--------------------------------------------------------------------------
-- Return the current file name.
-- @param self A MasterControl object
function M.myFileName(self)
   local mStack = ModuleStack:moduleStack()
   return mStack:fileName()
end

--------------------------------------------------------------------------
-- Return the full name of the current module.  Typically name/version.
-- @param self A MasterControl object.
function M.myModuleFullName(self)
   local mStack = ModuleStack:moduleStack()
   return mStack:fullName()
end

--------------------------------------------------------------------------
-- Return the user name of the current module.  This is the name the user
-- specified.  It could a full name (name/version) or just the name.
-- @param self A MasterControl object.
function M.myModuleUsrName(self)
   local mStack = ModuleStack:moduleStack()
   return mStack:usrName()
end

--------------------------------------------------------------------------
-- Return the name of the modules.  That is the name of the module w/o a
-- version.
-- @param self A MasterControl object
function M.myModuleName(self)
   local mStack = ModuleStack:moduleStack()
   return mStack:sn()
end

--------------------------------------------------------------------------
-- Return the version if any.  If there is no version, for example a meta
-- module then the version is "".
-- @param self A MasterControl object
function M.myModuleVersion(self)
   local mStack = ModuleStack:moduleStack()
   return mStack:version()
end

--------------------------------------------------------------------------
-- Unset the family name.
-- @param self A MasterControl object
-- @param name A family name.
function M.unset_family(self, name)
   local mt     = MT:mt()

   dbg.start{"MasterControl:unset_family(",name,")"}
   dbg.print{"mt:unsetfamily(\"",name,"\")\n"}
   mt:unsetfamily(name)
   dbg.fini("MasterControl:unset_family")
end

--------------------------------------------------------------------------
-- Perform a user requested inheritance.  Note that this function remains
-- the same depending on if it is a load or unload.
-- @param self A MasterControl object
function M.inherit(self)
   local master = Master:master()
   dbg.start{"MasterControl:inherit()"}

   master.inheritModule()
   dbg.fini("MasterControl:inherit")
end


--------------------------------------------------------------------------
-- Return True when in spider mode.  This version is always false.
-- @param self A MasterControl object
function M.is_spider(self)
   dbg.start{"MasterControl:is_spider()"}
   dbg.fini("MasterControl:is_spider")
   return false
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
-- Return the type (or mode) of the current MasterControl object.
-- @param self A MasterControl object
function M.mode(self)
   dbg.start{"MasterControl:mode()"}
   dbg.print{"mode: ", self._mode,"\n"}
   dbg.fini("MasterControl:mode")
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
-- The quiet function.
-- @param self A MasterControl object
function M.quiet(self, ...)
   -- very Quiet !!!
end

return M
