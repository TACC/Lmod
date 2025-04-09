--------------------------------------------------------------------------
-- All the functions that are "Lmod" functions are in
-- this file.  Since the behavior of many of the Lmod functions (such as
-- setenv) function when the user is doing a load, unload, show, many of
-- these function they do the following:
--
--     a) They validate their arguments.
--     b) mcp:<function>(...)
--
-- The variable mcp is the MainControl Program object.  It gets
-- constructed in the various modes Lmod gets run in.  The modes include
-- load, unload, show, etc.  See MC_Load.lua and the other MC_*.lua files
-- As well as the base class MainControl.lua for more details.
--
-- UnLoad
-- See tools/Dbg.lua for details on how this debugging tool works.
-- @module modfuncs

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
require("colorize")
require("utils")
require("string_utils")
require("parseVersion")
require("TermWidth")
require("declare")

local l_validateModules
local BeautifulTbl = require("BeautifulTbl")
local MName        = require("MName")
local MRC          = require("MRC")
local Version      = require("Version")
local dbg          = require("Dbg"):dbg()
local hook         = require("Hook")
local max          = math.max
local _concatTbl   = table.concat
local pack         = (_VERSION == "Lua 5.1") and argsPack or table.pack   -- luacheck: compat
local unpack       = (_VERSION == "Lua 5.1") and unpack   or table.unpack -- luacheck: compat


-- Check functions used by the rules table:
local function l_stringCk(value)
   return type(value) == "string", "string"
end

local function l_stringValueCk(value)
   local t = type(value)
   return (t == "string" or t == "number" or t == "boolean"), "string_or_value"
end

local function l_booleanCk(value)
   return type(value) == "boolean", "boolean"
end

local function l_valid_nameCk(name)
   if (not type(name) == "string") then
      return false, "string"
   end
   local l    = name:len()
   local i, j = name:find("^[a-zA-Z_][a-zA-Z0-9_]*")
   if (j ~= l) then
      return false, "valid_name"
   end
   return true
end

local function l_trim_first_arg(argT)
   if type(argT[1]) == "string" then
      argT[1] = argT[1]:trim()
   end
end

local function l_trim_all_strings_args(argT)
   for i = 1, argT.n do
      if type(argT[i]) == "string" then
         argT[i] = argT[i]:trim()
      end
   end
end

local function l_priorityCk(argT)
   local priority = argT.priority
   if (priority == nil or type(priority) == "number") then
      return true
   end
   if (type(priority) == "string" and tonumber(priority) ) then
      argT.priority = tonumber(priority)
      return true
   end
   mcp:report{msg="e_Prioity", priority=argT.priority, fn = myFileName(), cmdName = argT.__cmdName}
   return false
end
   
------------------------------------------------------------------------
-- Check for string characters for the delim.  Convert 3rd arg to argT.delim if it exists

local function l_delimCk(argT)
   if (argT.n == 3) then
      argT.delim = argT[3]
      argT[3]    = nil
      argT.n     = 2
      argT.kind  = "Table"
   end
      
   if (argT.delim == nil or type(argT.delim) == "string") then
      return true
   end
   mcp:report{msg="e_Delim", delim=argT.delim, fn = myFileName(), cmdName = argT.__cmdName}
   return false
end

local s_cleanupDirT = { PATH = true, LD_LIBRARY_PATH = true, LIBRARY_PATH = true, MODULEPATH = true }

local function l_trim_string(value)
   if (type(value) == "string") then
      value = value:trim()
   end
   return value
end

local function l_cleanupPathArgs(argT)
   local name = l_trim_string(argT[1])
   local path = l_trim_string(argT[2])
   
   if (path and s_cleanupDirT[name]) then
      path = path:gsub(":+$",""):gsub("^:+",""):gsub(":+",":")
      if (path == "") then path = false end
      argT[2] = path
   end

   return
end


-- New mode check for the table: checks if modeA exists, is non-empty,
-- and that each mode value is among the allowed ones.
local function l_modeCk(argT)
   if (type(argT.modeA) ~= "table" or #argT.modeA == 0) then
      mcp:report{msg="e_Mode_Not_Set", fn = myFileName(), cmdName = argT.__cmdName}
      return false
   end

   local validModes = { normal = true, load = true, unload = true }
   for i = 1, #argT.modeA do
      if not validModes[argT.modeA[i]] then
         mcp:report{msg="e_Invalid_Mode", fn = myFileName(), cmdName = argT.__cmdName, mode = argT.modeA[i]}
         return false
      end
   end
   return true
end


-- New helper to check for forbidden key modifications in mode-specific functions.
-- For instance, if a call such as:
--    prepend_path{"MODULEPATH", "FOOBAR", modeA={"load"}}
-- is attempted in load mode, this operation is forbidden.
local function l_checkForbiddenEnv(argT)
   local cmd = argT.__cmdName

   -- Only proceed with forbidden key check if the function is mode-select.
   if (not argT.modeA or type(argT.modeA) ~= "table" or #argT.modeA == 0) then
      return true
   end
   --if (argT.modeA and type(argT.modeA) == "table" and #argT.modeA == 1 and argT.modeA[1] == "normal") then
   --   return true
   --end
   if (#argT.modeA == 1 and argT.modeA[1] == "normal") then
      return true
   end

   -- Check if the target variable is in the list of forbidden keys.
   local forbiddenKeys = { MODULEPATH = true }  
   if argT[1] and forbiddenKeys[argT[1]:upper()] then
      local message = cmd .. " operation on " .. argT[1]:upper() .. " is forbidden in load mode."
      mcp:report{msg="e_Forbidden_Env", fn = myFileName(), cmdName = cmd, detail = message}
   end
   return true
end

-- New function to check for invalid function keys
local function l_checkInvalidFuncKey(argT)
   local validKeys = { n = true, delim = true, modeA = true, priority = true, kind = true }
   for k, v in pairs(argT) do
      if type(k) == "string" and k:sub(1,1) ~= "_" then
         if not validKeys[k] then
            local cmd = argT.__cmdName or "unknown"
            local detail = "Invalid key: " .. k
            mcp:report{msg="e_Invalid_Func_Key", fn = myFileName(), cmdName = cmd, detail = detail}
            return false
         end
      end
   end
   return true
end

-- Helper: Build the argument table ensuring a mode array exists.
local function l_build_argTable(cmdName, first_elem, ... )
   local argT
   if (type(first_elem) == "table") then
      if (first_elem.__waterMark == "MName") then
         argT = pack(first_elem, ...)
      else
         argT = first_elem
      end
      argT.__cmdName = cmdName
      argT.kind      = "Table"
      argT.n         = #argT
      if (not argT.modeA or type(argT.modeA) ~= "table" or (#argT.modeA == 0)) then
         if (argT.mode and type(argT.mode) == "table" and (#argT.mode > 0)) then
            argT.modeA = argT.mode
            argT.mode  = nil
         else
            argT.modeA = {"normal"}
         end
      end
   else
      argT = pack(first_elem, ...)
      argT.__cmdName = cmdName
      argT.modeA     = {"normal"}
      argT.kind      = "Array"
   end
   if (dbg.active()) then
      local s = cmdName .. serializeTbl{value=argT}:gsub("\n"," "):gsub(", *}"," }")
      dbg.start{s}
   end
   return argT
end

-- Check the arguments in the table using the provided rules.
local function l_check_argT(argT, rulesT)
   if (argT.n < rulesT.sizeN.min or argT.n > rulesT.sizeN.max) then
      mcp:report{msg="e_wrong_num_args", n = argT.n, fn = myFileName(), cmdName = argT.__cmdName}
      return false
   end
   if (rulesT.trimArg) then
      rulesT.trimArg(argT)
   end
   if (rulesT.checkA) then
      for i = 1, argT.n do
         local checkFunc = rulesT.checkA[i]
         if checkFunc then
            local ok, expectedType = checkFunc(argT[i])
            if not ok then
               mcp:report{msg="e_bad_arg", fn = myFileName(), cmdName = argT.__cmdName, arg = argT[i], expected = expectedType}
               return false
            end
         end
      end
   end
   if (rulesT.checkTblArgs) then
      for i = 1, #rulesT.checkTblArgs do
         local func = rulesT.checkTblArgs[i]
         if (not func(argT)) then return false end
      end
   end
   -- Run any additional "other_tests" if defined.
   if (rulesT.other_tests) then
      for i = 1, #rulesT.other_tests do
         local testFunc = rulesT.other_tests[i]
         -- Should the test signal a forbidden operation, it produces its own report.
         testFunc(argT)
      end
   end
   return true
end

-- Build the argument table and check it against the rules.
local function l_build_check_argT(cmdName, rulesT, first_elem, ... )
   local argT = l_build_argTable(cmdName, first_elem, ...) 
   if (not l_check_argT(argT, rulesT) ) then return nil end
   return argT
end

-- Choose the appropriate mcp based on the mode.
local function l_chose_mcp(argT)
   local my_mode = mode()
   -- In 'show' mode, always execute.
   if my_mode == "show" then
      return mcp
   end

   local modeA = argT.modeA
   -- If the mode is explicitly "normal", always execute.
   for i = 1, #modeA do
      if modeA[i] == "normal" then
         return mcp
      end
   end

   -- Otherwise, if current mode matches one of the declared modes, execute.
   for i = 1, #modeA do
      if my_mode == modeA[i] then
         return MCP
      end
   end

   -- If no match is found, then no-op.
   return MCPQ
end



-- Define the rules table for setenv.
local s_setenv_rulesT = {
   sizeN        = {min=2, max=3},
   trimArg      = l_trim_first_arg,
   checkA       = { l_valid_nameCk, l_stringValueCk, l_stringValueCk},
   checkTblArgs = { l_modeCk },
   other_tests  = { l_checkForbiddenEnv, l_checkInvalidFuncKey },
}

local s_pushenv_rulesT = {
   sizeN        = {min=2, max=2},
   trimArg      = l_trim_first_arg,
   checkA       = { l_valid_nameCk, l_stringValueCk},
   checkTblArgs = { l_modeCk },
   other_tests  = { l_checkForbiddenEnv, l_checkInvalidFuncKey },
}

local s_unsetenv_rulesT = {
   sizeN        = {min=1, max=2},
   trimArg      = l_trim_first_arg,
   checkA       = { l_valid_nameCk, l_stringValueCk},
   checkTblArgs = { l_modeCk },
   other_tests  = { l_checkForbiddenEnv, l_checkInvalidFuncKey },
}

local s_prepend_rulesT = {
   sizeN        = {min=2, max=3},
   trimArg      = l_cleanupPathArgs,
   checkA       = { l_valid_nameCk, l_stringCk, l_stringCk},
   checkTblArgs = { l_modeCk, l_priorityCk, l_delimCk},
   other_tests  = { l_checkForbiddenEnv, l_checkInvalidFuncKey },
}

local s_remove_rulesT = {
   sizeN        = {min=2, max=3},
   trimArg      = l_cleanupPathArgs,
   checkA       = { l_valid_nameCk, l_stringCk, l_stringCk},
   checkTblArgs = { l_modeCk },
   other_tests  = { l_checkForbiddenEnv, l_checkInvalidFuncKey },

}

local huge = math.maxinteger or math.huge
local s_load_rulesT = {
   sizeN        = {min=1, max=huge},
   trimArg      = l_trim_all_strings_args,
   -- Here, checkList is used since load_module accepts a variable list of module names.
   checkList    = l_validateModules,
   checkTblArgs = { l_modeCk },
   other_tests  = { l_checkInvalidFuncKey },
}

--------------------------------------------------------------------------
-- Special table concat function that knows about strings and numbers.
-- @param aa  Input array
-- @param delim output separator.
local function l_concatTbl(aa,delim)
   if (not dbg.active()) then
      return ""
   end
   local a = {}
   for i = 1, #aa do
      local v     = aa[i]
      local vType = type(v)
      if ( vType == "string") then
         a[i] = v
      elseif (vType == "number") then
         a[i] = tostring(v)
      else
         a[i] = vType
      end
   end
   return _concatTbl(a, delim)
end

--------------------------------------------------------------------------
-- Validate a function with only string arguments.
-- @param cmdName The command which is getting its arguments validated.
local function l_validateStringArgs(cmdName, ...)
   local argA = pack(...)
   for i = 1, argA.n do
      local v = argA[i]
      if (type(v) ~= "string") then
         mcp:report{msg="e_Args_Not_Strings", fn = myFileName(), cmdName = cmdName}
         return false
      end
   end
   return true
end

--------------------------------------------------------------------------
-- Validate a function with only string table.
-- @param cmdName The command which is getting its arguments validated.
local function l_validateStringTable(n, cmdName, t)
   n = max(n,#t)
   for i = 1, n do
      local v = t[i]
      if (type(v) ~= "string") then
         mcp:report{msg="e_Args_Not_Strings", fn = myFileName(), cmdName = cmdName}
         return false
      end
   end
   if (t.priority ~= nil) then
      local valid = false
      if (t.priority == 0) then
         valid = true
      elseif (t.priority >= 10) then
         valid = true
      end

      if (not valid) then
         mcp:report{msg="e_Args_Not_Strings", fn = myFileName(), cmdName = cmdName}
         return false
      end
   end

   return true
end

--------------------------------------------------------------------------
-- Validate a function with only string module names table.
-- @param cmdName The command which is getting its arguments validated.
--local function l_validateArgsWithValue(cmdName, ...)
local function l_validateArgsWithValue(cmdName, table)

   local n = table.n or #table 
   for i = 1, n -1 do
      local v = table[i]
      if (type(v) ~= "string") then
         mcp:report{msg="e_Args_Not_Strings", fn = myFileName(), cmdName = cmdName}
         return false
      end
   end

   local v = table[n]
   if (type(v) ~= "string" and type(v) ~= "number" and type(v) ~= "boolean") then
      mcp:report{msg="e_Args_Not_Strings", fn = myFileName(), cmdName = cmdName}
      return false
   end
   return true
end



--------------------------------------------------------------------------
-- Validate a function with only string module names table.
-- @param cmdName The command which is getting its arguments validated.
local function l_validateModules(cmdName, ...)
   local argA = pack(...)
   local allGood = true
   local fn      = false
   for i = 1, argA.n do
      local v = argA[i]
      if (type(v) == "string") then
         allGood = true
      elseif (type(v) == "table" and v.__waterMark == "MName") then
         allGood = true
      else
         allGood = false
         fn = myFileName()
         break
      end
   end
   if (not allGood) then
      mcp:report{msg="e_Args_Not_Strings", fn = myFileName(), cmdName = cmdName}
   end
   return allGood
end


--------------------------------------------------------------------------
--  The load function.  It can be found in the following forms:
-- "load('name'); load('name/1.2'); load(atleast('name','3.2'))",
function load_module(...)
   local argT = l_build_check_argT("load_module", s_load_rulesT, ...)
   if (not argT) then
      dbg.fini("load_module")
      return {}
   end

   local mcp_old = mcp
   mcp = l_chose_mcp(argT)

   local b = mcp:load_usr(MName:buildA(mcp:MNameType(), argT))
   mcp = mcp_old
   dbg.fini("load_module")
   return b
end


function mgrload(required, active)
   dbg.start{"mgrload(",required,", activeA)"}

   local status  = mcp:mgrload(required, active)
   dbg.fini("mgrload")
   return status
end


function load_any(...)
   local argT = l_build_check_argT("load_any", s_load_rulesT, ...)
   if (not argT) then
      dbg.fini("load_any")
      return {}
   end

   local b = mcp:load_any(MName:buildA(mcp:MNameType(), argT))
   dbg.fini("load_any")
   return b
end

local s_cleanupDirT = { PATH = true, LD_LIBRARY_PATH = true, LIBRARY_PATH = true, MODULEPATH = true }

--- PATH functions ---
--------------------------------------------------------------------------
-- convert arguments into a table if necessary.
local function l_convert2table(...)
   local argA = pack(...)
   local t    = {}

   if (argA.n == 1 and type(argA[1]) == "table" ) then
      t = argA[1]
      t[1] = t[1]
   else
      t[1]    = argA[1]
      t[2]    = argA[2]
      t.delim = argA[3]
   end

   t.priority = tonumber(t.priority or "0")
   return t
end

--------------------------------------------------------------------------
-- Prepend a value to a path like variable.
function prepend_path(...)
   local argT = l_build_check_argT("prepend_path", s_prepend_rulesT, ...)
   if (not argT) then
      dbg.fini("prepend_path")
      return
   end


   local mcp_old = mcp
   mcp = l_chose_mcp(argT)

   if (argT[2]) then
      mcp:prepend_path(argT)
   end
   mcp = mcp_old
   dbg.fini("prepend_path")
   return
end

--------------------------------------------------------------------------
-- Append a value to a path like variable.
function append_path(...)
   local argT = l_build_check_argT("append_path", s_prepend_rulesT, ...)
   local mcp_old = mcp
   mcp = l_chose_mcp(argT)

   if (argT[2]) then
      mcp:append_path(argT)
   end
   mcp = mcp_old
   dbg.fini("append_path")
   return
end

--------------------------------------------------------------------------
-- Remove a value from a path like variable.
function remove_path(...)
   local argT = l_build_check_argT("remove_path", s_remove_rulesT, ...)
   if (not argT) then
      dbg.fini("remove_path")
      return
   end

   local mcp_old = mcp
   mcp = l_chose_mcp(argT)

   if (argT[2]) then
      mcp:remove_path(argT)
   end
   mcp = mcp_old
   dbg.fini("remove_path")
   return
end

--- Set Environment functions ----

--------------------------------------------------------------------------
-- Set the value of environment variable and maintain a stack.
function pushenv(...)
   local argT = l_build_check_argT("pushenv", s_pushenv_rulesT, ...)
   if (not argT) then
      dbg.fini("pushenv")
      return
   end

   local mcp_old = mcp
   mcp = l_chose_mcp(argT)

   mcp:pushenv(argT)
   mcp = mcp_old
   dbg.fini("pushenv")
   return
end

--------------------------------------------------------------------------
-- Set the value of environment variable.
--function setenv(...)
--   dbg.start{"setenv(",l_concatTbl({...},", "),")"}
--   if (not l_validateArgsWithValue("setenv",...)) then return end

--   mcp:setenv(...)
--   dbg.fini("setenv")
--   return
--end

-- Set the value of environment variable.
function setenv(...)
   -- Build and validate the argument table using the new rules.
   local argT = l_build_check_argT("setenv", s_setenv_rulesT, ...)
   if (not argT) then
      dbg.fini("setenv")
      return
   end
   
   local mcp_old = mcp
   mcp = l_chose_mcp(argT)

   -- Call the underlying mcp function 
   mcp:setenv(argT)
   mcp = mcp_old
   dbg.fini("setenv")
   return
end


--------------------------------------------------------------------------
-- Unset the value of environment variable.
function unsetenv(...)
   -- Build and validate the argument table using the new rules.
   local argT = l_build_check_argT("unsetenv", s_unsetenv_rulesT, ...)
   if (not argT) then
      dbg.fini("unsetenv")
      return
   end
   
   local mcp_old = mcp
   mcp = l_chose_mcp(argT)

   mcp:unsetenv(argT)
   mcp = mcp_old
   dbg.fini("unsetenv")
   return
end

--------------------------------------------------------------------------
-- Put a command in stdout so it will get executed.
-- @param t the command table.
function execute(t)
   dbg.start{"execute(...)"}
   if (type(t) ~= "table" or not t.cmd or type(t.modeA) ~= "table") then
      mcp:report{msg="e_Execute_Msg", fn = myFileName()}
      return
   end
   local b = mcp:execute(t)
   dbg.fini("execute")
   return b
end

--------------------------------------------------------------------------
-- This function allows only module to claim the name.  It is a
-- generalized prereq/conflict function.
function family(name)
   dbg.start{"family(",name,")"}
   if (not l_validateStringArgs("family",name)) then return end

   mcp:family(name)
   dbg.fini("family")
end

--------------------------------------------------------------------------
-- Provide a list of loaded modules for sites to use
function loaded_modules()
   dbg.start{"loaded_modules()"}
   local a = mcp:loaded_modules()
   dbg.fini("loaded_modules")
   return a
end

--- Inherit function ---

--------------------------------------------------------------------------
-- This function finds the same named module in the MODULEPATH and
-- loads it.
function inherit(...)
   dbg.start{"inherit(",l_concatTbl({...},", "),")"}

   mcp:inherit(...)
   dbg.fini("inherit")
end

--------------------------------------------------------------------------
-- Return the mode.
function mode()
   local b = mcp:mode()
   return b
end

function haveDynamicMPATH()
   dbg.start{"haveDynamicMPATH()"}
   mcp:haveDynamicMPATH()
   dbg.fini("haveDynamicMPATH")
end


--------------------------------------------------------------------------
-- Return true if in spider mode.  Use mode function instead.
function is_spider()
   dbg.start{"is_spider()"}
   local b = mcp:is_spider()
   dbg.fini("is_spider")
   return b
end

--------------------------------------------------------------------------
-- Return true if the module is loaded.
-- @param m module name
function isloaded(m)
   dbg.start{"isloaded(",m,")"}
   if (not l_validateStringArgs("isloaded",m)) then return false end
   local mname = MName:new("mt", m)
   dbg.fini("isloaded")
   return mname:isloaded()
end

function isAvail(m)
   dbg.start{"isAvail(",m,")"}
   if (not l_validateStringArgs("isAvail",m)) then return false end
   local mname = MName:new("load", m)
   dbg.fini("isAvail")
   return mname:valid()
end


------------------------------------------------------------------------
-- export shell function
function export_shell_function(funcName)
   dbg.start{"export_shell_function(",funcName,")"}
   if (not l_validateStringArgs("export_shell_function",funcName)) then return false end
   mcp:export_shell_function(funcName)
   dbg.fini("export_shell_function")
end


function myFileName()
   return mcp:myFileName()
end

--------------------------------------------------------------------------
-- Return the full name of the module
function myModuleFullName()
   return mcp:myModuleFullName()
end

--------------------------------------------------------------------------
-- Return the name of the module (w/o) version.
function myModuleName()
   return mcp:myModuleName()
end

--------------------------------------------------------------------------
-- Return the name of the module that the user specified.
function myModuleUsrName()
   return mcp:myModuleUsrName()
end

--------------------------------------------------------------------------
-- Return the version of the module.
function myModuleVersion()
   return mcp:myModuleVersion()
end

--------------------------------------------------------------------------
-- Return true if the module is in the pending state for a load.
-- @param m module name
function isPending(m)
   if (not l_validateStringArgs("isPending",m)) then return false end
   local mname = MName:new("mt", m)
   return mname:isPending()
end

--------------------------------------------------------------------------
-- Report an error and quit.
function LmodError(...)
   local b = mcp:error(...)
   return b
end

--------------------------------------------------------------------------
-- Report a warning and continue operation.
function LmodWarning(...)
   local b = mcp:warning(...)
   return b
end

--------------------------------------------------------------------------
-- Print a message
function LmodMessage(...)
   local b = mcp:message(...)
   return b
end

--------------------------------------------------------------------------
-- Print a message
function LmodMsgRaw(...)
   local b = mcp:msg_raw(...)
   return b
end

---------------------------------------------------------------------------
-- Return the version of Lmod.
function LmodVersion()
   return Version.tag()
end

-------------------------------------------------------------------------
-- Return shell that invoked Lmod.
function myShellName()
   return mcp:myShellName()
end

function myShellType()
   return mcp:myShellType()
end

--------------------------------------------------------------------------
-- The whatis database function.
function whatis(...)
   dbg.start{"whatis(",l_concatTbl({...},", "),")"}
   if (not l_validateStringArgs("whatis",...)) then return end

   mcp:whatis(...)
   dbg.fini("whatis")
end

--------------------------------------------------------------------------
-- the help function.
function help(...)
   dbg.start{"help(...)"}
   if (not l_validateStringArgs("help",...)) then return end
   mcp:help(...)
   dbg.fini("help")
end


function userInGroups(...)
   dbg.start{"userInGroups(...)"}
   if (not l_validateStringArgs("userInGroups",...)) then return end
   local iret = mcp:userInGroups(...)
   dbg.fini("userInGroups")
   return iret
end

declare("userInGroup")
userInGroup = userInGroups

--------------------------------------------------------------------------
-- Convert version to canonical so that it can be used in a comparison.
function convertToCanonical(s)
   if (not l_validateStringArgs("convertToCanonical",s)) then return end
   return parseVersion(s)
end


--- Prereq / Conflict ---

--------------------------------------------------------------------------
-- Test to see if a prereq module is loaded.  Fail if it is not.
-- If more than one module is listed then it is an and condition.
function prereq(...)
   dbg.start{"prereq(",l_concatTbl({...},", "),")"}
   if (not l_validateModules("prereq", ...)) then return end

   mcp:prereq(MName:buildA(mcp:MNamePrereqType(), pack(...)))
   dbg.fini("prereq")
end

--------------------------------------------------------------------------
-- Test to see if any of prereq modules are loaded.  Fail if it is not.
-- If more than one module is listed then it is an or condition.
function prereq_any(...)
   dbg.start{"prereq_any(",l_concatTbl({...},", "),")"}
   if (not l_validateModules("prereq_any",...)) then return end

   mcp:prereq_any(MName:buildA(mcp:MNamePrereqType(), pack(...)))
   dbg.fini("prereq_any")
end

--------------------------------------------------------------------------
-- Test to see if a conflict module is loaded.  Fail if it is loaded.
function conflict(...)
   dbg.start{"conflict(",l_concatTbl({...},", "),")"}
   if (not l_validateModules("conflict",...)) then return end

   mcp:conflict(MName:buildA("mt", pack(...) ))
   dbg.fini("conflict")
end

--------------------------------------------------------------------------
-- A load, prereq and conflict modifier.  It is used like this:
-- load(atleast("gcc","4.8"))
-- @param m module name
-- @param is the starting version
function atleast(m, is)
   dbg.start{"atleast(",m,", ",is,")"}

   local mname = MName:new("load", m, "atleast", is)

   dbg.fini("atleast")
   return mname
end

--------------------------------------------------------------------------
-- A load, prereq and conflict modifier.  It is used like this:
-- load(atleast("gcc","4.8"))
-- @param m module name
-- @param is the starting version
function atmost(m, ie)
   dbg.start{"atmost(",m,", ",ie,")"}

   local mname = MName:new("load", m, "atmost", false, ie)

   dbg.fini("atmost")
   return mname
end

--------------------------------------------------------------------------
-- A load and prereq modifier.  It is used like this:
-- load(between("gcc","4.8","4.9"))
-- @param m module name
-- @param is the starting version
-- @param ie the ending version.
function between(m,is,ie)
   dbg.start{"between(","\"",m,"\",\"",is,"\",\"",ie,"\")"}

   local mname = MName:new("load", m, "between", is, ie)

   dbg.fini("between")
   return mname
end

--------------------------------------------------------------------------
-- Load the latest version available.  This will ignore defaults.
-- @param m module name
function latest(m)
   dbg.start{"latest(",m,")"}

   local mname = MName:new("load", m, "latest")

   dbg.fini("latest")
   return mname
end

--- Set Alias/Shell functions ---

--------------------------------------------------------------------------
-- Set an alias for bash and csh
function set_alias(...)
   dbg.start{"set_alias(",l_concatTbl({...},", "),")"}
   if (not l_validateArgsWithValue("set_alias", pack(...) )) then return end

   mcp:set_alias(...)
   dbg.fini("set_alias")
end

--------------------------------------------------------------------------
-- Unset an alias for bash and csh
function unset_alias(...)
   dbg.start{"unset_alias(",l_concatTbl({...},", "),")"}
   if (not l_validateStringArgs("unset_alias",...)) then return end

   mcp:unset_alias(...)
   dbg.fini("unset_alias")
end

--------------------------------------------------------------------------
-- Set an shell function for bash and an alias for csh
function set_shell_function(...)
   dbg.start{"set_shell_function(",l_concatTbl({...},", "),")"}
   if (not l_validateStringArgs("set_shell_function",...)) then return end

   mcp:set_shell_function(...)
   dbg.fini()
end

--------------------------------------------------------------------------
-- Unset an shell function for bash and an alias for csh
function unset_shell_function(...)
   dbg.start{"unset_shell_function(",l_concatTbl({...},", "),")"}
   if (not l_validateStringArgs("unset_shell_function",...)) then return end

   mcp:unset_shell_function(...)
   dbg.fini("unset_shell_function")
end

--- Property functions ----

--------------------------------------------------------------------------
-- Add a property to a module.
function add_property(...)
   dbg.start{"add_property(",l_concatTbl({...},", "),")"}
   if (not l_validateStringArgs("add_property",...)) then return end
   mcp:add_property(...)
   dbg.fini("add_property")
end

--------------------------------------------------------------------------
-- Remove a property to a module.
function remove_property(...)
   dbg.start{"remove_property(",l_concatTbl({...},", "),")"}
   if (not l_validateStringArgs("remove_property",...)) then return end

   mcp:remove_property(...)
   dbg.fini("remove_property")
end

--------------------------------------------------------------------------
-- Return the hierarchy based on the file name.
-- @param pkgName the full module name
-- @param levels the number of levels to return.
function hierarchyA(pkgName, levels)
   local fn  = myFileName():gsub("%.lua$","")
   if (levels < 1) then
      return {}
   end

   -- Remove pkgName from end of string by using the
   -- "plain" matching via string.find function
   pkgName = path_regularize(pkgName:gsub("%.lua$",""))
   local i,j = fn:find(pkgName,1,true)
   if (j == fn:len()) then
      fn = fn:sub(1,i-1)
   end

   fn = path_regularize(fn)
   j                = 0
   local numEntries = 0
   while (j) do
      j          = pkgName:find("/",j+1)
      numEntries = numEntries + 1
   end

   local a = {}

   for dir in fn:split("/") do
      a[#a + 1] = dir
   end

   local b = {}
   local n = #a

   for ia = 1, levels do
      local bb = {}
      for ja = 1, numEntries do
         local idx = n - numEntries + ja
         bb[ja] = a[idx]
      end
      b[ia] = _concatTbl(bb,'/')
      n = n - numEntries
   end

   return b
end

--------------------------------------------------------------------------
-- Report the modulefiles stack for error report.
function moduleStackTraceBack(msg)
   local FrameStk = require("FrameStk")
   local frameStk = FrameStk:singleton()
   msg = msg or "While processing the following module(s):\n"
   if (frameStk:empty()) then return "" end

   local aa = {}
   aa[1]    = { "  ", "Module fullname", "Module Filename"}
   aa[2]    = { "  ", "---------------", "---------------"}

   local a  = frameStk:traceBack()

   for i = 1,#a do
      local mname = a[i]
      aa[#aa+1] = {"  ",mname:fullName() or "" , mname:fn() or ""}
   end

   local bt = BeautifulTbl:new{tbl=aa}

   local bb = {}
   bb[#bb+1] = msg
   bb[#bb+1] = bt:build_tbl()
   return _concatTbl(bb,"")
end

function requireFullName()
    if (myModuleUsrName() ~= myModuleFullName()) then
       LmodError{msg="e_RequireFullName", sn = myModuleName(), fullName= myModuleFullName()}
    end
end


--------------------------------------------------------------------------
-- Write "false" to stdout and exit.
function LmodErrorExit()
   Shell:report_failure()
   os.exit(1)
end

--------------------------------------------------------------------------
-- Print msgs, traceback then exit.
function LmodSystemError(...)
   MainControl:error(...)
end

--------------------------------------------------------------------------
--  The try-load function.  It can be found in the following forms:
-- "try_load('name'); try_load('name/1.2'); try_load(atleast('name','3.2'))",
-- The only difference between 'load' and 'try_load' is that a 'try_load'
-- will not produce a warning if the specified modulefile(s) do not exist.
function try_load(...)
   local argT = l_build_check_argT("try_load", s_load_rulesT, ...)
   if (not argT) then
      dbg.fini("try_load")
      return {}
   end

   local mcp_old = mcp
   mcp = l_chose_mcp(argT)
   local b = mcp:try_load(MName:buildA(mcp:MNameType(), argT))
   dbg.fini("try_load")
   return b
end

function unload_usr_internal(mA, force)
   if (dbg.active()) then
      local s = mAList(mA)
      dbg.start{"unload_usr_internal(mA={"..s.."},force=",force,")"}
   end
   local mrc = MRC:singleton()
   mrc:set_display_mode("all")

   local mcp_old = mcp
   mcp = MainControl.build("unload")
   local b = MainControl.unload_usr(mcp, mA, force)
   mcp = mcp_old
   dbg.print{"Setting mcp to ", mcp:name(),"\n"}
   dbg.fini("unload_usr_internal")
   return b
end

function unload_internal(mA)
   if (dbg.active()) then
      local s = mAList(mA)
      dbg.start{"unload_internal(mA={"..s.."})"}
   end
   local mrc = MRC:singleton()
   mrc:set_display_mode("all")

   local mcp_old = mcp
   mcp = mcp:build_unload()
   local b = mcp:unload(mA)
   mcp = mcp_old
   dbg.print{"Setting mcp to ", mcp:name(),"\n"}
   dbg.fini("unload_internal")
   return b
end

--------------------------------------------------------------------------
-- The unload function reads a module file and reverses all the commands
-- in the modulefile.  It is not an error to unload a module which is
-- not loaded.  The reverse of an unload is a no-op.
function unload(...)
   local argT = l_build_check_argT("unload", s_load_rulesT, ...)
   if (not argT) then
      dbg.fini("unload")
      return {}
   end
   local b = unload_internal(MName:buildA("mt", argT))
   dbg.fini("unload")
   return b
end

--------------------------------------------------------------------------
-- This function always loads and never unloads.
function always_load(...)
   local argT = l_build_check_argT("always_load", s_load_rulesT, ...)
   if (not argT) then
      dbg.fini("always_load")
      return {}
   end

   local b  = mcp:always_load(MName:buildA("load",argT))
   dbg.fini("always_load")
   return b
end

--------------------------------------------------------------------------
-- This function always unloads and never loads. The reverse of this
-- function is a no-op.
function always_unload(...)
   dbg.start{"always_unload(",l_concatTbl({...},", "),")"}
   local b = unload(...)
   dbg.fini("always_unload")
   return b
end

function depends_on(...)
   dbg.start{"depends_on(",l_concatTbl({...},", "),")"}
   if (not l_validateModules("depends_on",...)) then return {} end

   local b = mcp:depends_on(MName:buildA(mcp:MNameType(), pack(...)))
   dbg.fini("depends_on")
end

function depends_on_any(...)
   dbg.start{"depends_on_any(",l_concatTbl({...},", "),")"}
   if (not l_validateModules("depends_on_any",...)) then return {} end

   local b = mcp:depends_on_any(MName:buildA(mcp:MNameType(), pack(...)))
   dbg.fini("depends_on_any")
end

function extensions(...)
   dbg.start{"extensions(",l_concatTbl({...},", "),")"}
   if (not l_validateStringArgs("extensions",...)) then return {} end

   local b = mcp:extensions(...)
   dbg.fini("extensions")
end

function color_banner(color)
   mcp:color_banner(color)
end


function source_sh(...)
   dbg.start{"source_sh(",l_concatTbl({...},", "),")"}
   if (not l_validateStringArgs("source_sh", ...)) then return end
   mcp:source_sh(...)
   dbg.fini("source_sh")
end

function complete(shellName, cmd, args)
   dbg.start{"complete(shellName, cmd, args)"}
   if (not l_validateStringArgs("complete", shellName, cmd, args)) then return end
   mcp:complete(shellName:trim():lower(), cmd:trim():lower(), args)
   dbg.fini("complete")
end

function uncomplete(shellName, cmd, args)
   dbg.start{"uncomplete(shellName, cmd, args)"}
   if (not l_validateStringArgs("uncomplete", shellName, cmd, args)) then return end
   mcp:uncomplete(shellName:lower(), cmd, args)
   dbg.fini("uncomplete")
end

function LmodBreak(msg)
   dbg.start{"LmodBreak(",msg,")"}
   if (not (msg == nil or l_validateStringArgs("LmodBreak", msg))) then return end
   mcp:LmodBreak(msg)
   dbg.fini("LmodBreak")
end

function purge(t)
   t = t or {}
   dbg.start{"purge{force=",t.force,"}"}
   mcp:purge(t)
   dbg.fini("purge")
end

function dofile_not_supported()
   mcp:report{msg="e_Dofile_not_supported"}
end


--- subprocess function ---

function subprocess(cmd)
   dbg.start{"subprocess(",cmd,")"}
   local p = io.popen(cmd)
   if p == nil then
      return nil
   end
   local ret = p:read("*all")
   p:close()
   return ret
end



