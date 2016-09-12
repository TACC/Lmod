--------------------------------------------------------------------------
-- All the functions that are "Lmod" functions are in
-- this file.  Since the behavior of many of the Lmod functions (such as
-- setenv) function when the user is doing a load, unload, show, many of
-- these function they do the following:
--
--     a) They validate their arguments.
--     b) mcp:<function>(...)
--
-- The variable mcp is the master control program object.  It gets
-- constructed in the various modes Lmod gets run in.  The modes include
-- load, unload, show, etc.  See MC_Load.lua and the other MC_*.lua files
-- As well as the base class MasterControl.lua for more details.
--
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

require("parseVersion")
require("utils")
require("string_utils")

local dbg         = require("Dbg"):dbg()
local max         = math.max
local MName       = require("MName")
local ModuleStack = require("ModuleStack")
local Version     = require("Version")
local _concatTbl  = table.concat
local pack        = (_VERSION == "Lua 5.1") and argsPack or table.pack

--------------------------------------------------------------------------
-- Special table concat function that knows about strings and numbers.
-- @param aa  Input array
-- @param sep output separator.
local function concatTbl(aa,sep)
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
   return _concatTbl(a, sep)
end

--------------------------------------------------------------------------
-- Validate a function with only string arguments.
-- @param cmdName The command which is getting its arguments validated.
local function validateStringArgs(cmdName, ...)
   local arg = pack(...)
   for i = 1, arg.n do
      local v = arg[i]
      if (type(v) ~= "string") then
         local fn = myFileName()
         mcp:report("Syntax error in file: ",fn, "\n with command: ",
                   cmdName, " One or more arguments are not strings\n")
         return false
      end
   end
   return true
end

--------------------------------------------------------------------------
-- Validate a function with only string table.
-- @param cmdName The command which is getting its arguments validated.
local function validateStringTable(n, cmdName, t)
   n = max(n,#t)
   for i = 1, n do
      local v = t[i]
      if (type(v) ~= "string") then
         local fn = myFileName()
         mcp:report("Syntax error in file: ",fn, "\n with command: ",
                   cmdName, " One or more arguments are not strings\n")
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
         local fn = myFileName()
         mcp:report("Syntax error in file: ",fn, "\n with command: ",
                    cmdName, " priority must be equal to or greater than 10\n")
      end
   end

   return true
end

--------------------------------------------------------------------------
-- Validate a function with only string module names table.
-- @param cmdName The command which is getting its arguments validated.
local function validateModules(cmdName, ...)
   local arg = pack(...)
   dbg.print{"cmd: ",cmdName, " arg.n: ",arg.n,"\n"}
   local allGood = true
   local fn      = false
   for i = 1, arg.n do
      local v = arg[i]
      if (type(v) == "string") then
         allGood = true
      elseif (type(v) == "table" and v._waterMark == "MName") then
         allGood = true
      else
         allGood = false
         fn = myFileName()
         break
      end
   end
   if (not allGood) then
      mcp:report("vM: Syntax error in file: ",myFileName(), "\n with command: \"",
                 cmdName, "\" One or more arguments are not strings\n")
   end
   return allGood
end

--------------------------------------------------------------------------
-- Validate a function with only string module names table.
-- @param cmdName The command which is getting its arguments validated.
local function validateArgsWithValue(cmdName, ...)
   local arg = pack(...)

   for i = 1, arg.n -1 do
      local v = arg[i]
      if (type(v) ~= "string") then
         local fn = myFileName()
         mcp:report("Syntax error in file: ",fn, " with command: ",
                   cmdName, " One or more arguments are not strings\n")
         return false
      end
   end

   local v = arg[arg.n]
   if (type(v) ~= "string" and type(v) ~= "number" and type(v) ~= "boolean") then
      local fn = myFileName()
      mcp:report("Syntax error in file: ",fn, " with command: ",
                cmdName, " The last argument is  not string or number\n")
      return false
   end
   return true
end

--- Load family functions ----

--------------------------------------------------------------------------
--  The load function.  It can be found in the following forms:
-- "load('name'); load('name/1.2'); load(atleast('name','3.2'))",
function load_module(...)
   dbg.start{"load_module(",concatTbl({...},", "),")"}
   if (not validateModules("load",...)) then return {} end

   dbg.print{"mcp:name(): ",mcp:name(),"\n"}
   local b  = mcp:load_usr(MName:buildA(mcp:MNameType(), ...))
   dbg.fini("load_module")
   return b
end

--------------------------------------------------------------------------
--  The try-load function.  It can be found in the following forms:
-- "try_load('name'); try_load('name/1.2'); try_load(atleast('name','3.2'))",
-- The only difference between 'load' and 'try_load' is that a 'try_load'
-- will not produce a warning if the specified modulefile(s) do not exist.
function try_load(...)
   dbg.start{"try_load(",concatTbl({...},", "),")"}
   if (not validateModules("try_load",...)) then return {} end

   local b = mcp:try_load(MName:buildA(mcp:MNameType(), ...))
   dbg.fini("try_load")
   return b
end

--------------------------------------------------------------------------
-- The unload function reads a module file and reverses all the commands
-- in the modulefile.  It is not an error to unload a module which is
-- not loaded.  The reverse of an unload is a no-op.
function unload(...)
   dbg.start{"unload(",concatTbl({...},", "),")"}
   if (not validateStringArgs("unload",...)) then return {} end

   local b = mcp:unload(MName:buildA("mt",...))
   dbg.fini("unload")
   return b
end


--------------------------------------------------------------------------
-- This function always loads and never unloads.
function always_load(...)
   dbg.start{"always_load(",concatTbl({...},", "),")"}
   if (not validateModules("always_load",...)) then return {} end

   local b  = mcp:always_load(MName:buildA("load",...))
   dbg.fini("always_load")
   return b
end


--------------------------------------------------------------------------
-- This function always unloads and never loads. The reverse of this
-- function is a no-op.
function always_unload(...)
   dbg.start{"always_unload(",concatTbl({...},", "),")"}
   if (not validateStringArgs("always_unload",...)) then return {} end

   local b = mcp:always_unload(MName:buildA("mt",...))
   dbg.fini("always_unload")
   return b
end
--------------------------------------------------------------------------
-- A load and prereq modifier.  It is used like this:
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
-- A load and prereq modifier.  It is used like this:
-- load(between("gcc","4.8","4.9"))
-- @param m module name
-- @param is the starting version
-- @param ie the ending version.
function between(m,is,ie)
   dbg.start{"between(",m,is,ie,")"}

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



--- PATH functions ---
--------------------------------------------------------------------------
-- convert arguments into a table if necessary.
local function convert2table(...)
   local arg = pack(...)
   local t   = {}

   if (arg.n == 1 and type(arg[1]) == "table" ) then
      t = arg[1]
      t[1] = t[1]:trim()
   else
      t[1]    = arg[1]:trim()
      t[2]    = arg[2]
      t.delim = arg[3]
   end
   t.priority = tonumber(t.priority or "0")
   return t
end

--------------------------------------------------------------------------
-- Prepend a value to a path like variable.
function prepend_path(...)
   local t = convert2table(...)
   dbg.start{"prepend_path(",concatTbl(t,", "),")"}
   if (not validateStringTable(2, "prepend_path",t)) then return end

   mcp:prepend_path(t)
   dbg.fini("prepend_path")
end

--------------------------------------------------------------------------
-- Append a value to a path like variable.
function append_path(...)
   local t = convert2table(...)
   dbg.start{"append_path(",concatTbl(t,", "),")"}
   if (not validateStringTable(2, "append_path",t)) then return end

   mcp:append_path(t)
   dbg.fini("append_path")
end

--------------------------------------------------------------------------
-- Remove a value from a path like variable.
function remove_path(...)
   local t = convert2table(...)
   dbg.start{"remove_path(",concatTbl(t,", "),")"}
   if (not validateStringTable(2, "remove_path",t)) then return end

   mcp:remove_path(t)
   dbg.fini("remove_path")
end

--- Set Environment functions ----

--------------------------------------------------------------------------
-- Set the value of environment variable.
function setenv(...)
   dbg.start{"setenv(",concatTbl({...},", "),")"}
   if (not validateArgsWithValue("setenv",...)) then return end

   mcp:setenv(...)
   dbg.fini("setenv")
   return
end

--------------------------------------------------------------------------
-- Unset the value of environment variable.
function unsetenv(...)
   dbg.start{"unsetenv(",concatTbl({...},", "),")"}
   if (not validateArgsWithValue("unsetenv",...)) then return end

   mcp:unsetenv(...)
   dbg.fini("unsetenv")
   return
end

--------------------------------------------------------------------------
-- Set the value of environment variable and maintain a stack.
function pushenv(...)
   dbg.start{"pushenv(",concatTbl({...},", "),")"}
   if (not validateArgsWithValue("pushenv",...)) then return end

   mcp:pushenv(...)
   dbg.fini("pushenv")
   return
end

--- Property functions ----

--------------------------------------------------------------------------
-- Add a property to a module.
function add_property(...)
   dbg.start{"add_property(",concatTbl({...},", "),")"}
   if (not validateStringArgs("add_property",...)) then return end

   mcp:add_property(...)
   dbg.fini("add_property")
end

--------------------------------------------------------------------------
-- Remove a property to a module.
function remove_property(...)
   dbg.start{"remove_property(",concatTbl({...},", "),")"}
   if (not validateStringArgs("remove_property",...)) then return end

   mcp:remove_property(...)
   dbg.fini("remove_property")
end


--- Set Alias/Shell functions ---

--------------------------------------------------------------------------
-- Set an alias for bash and csh
function set_alias(...)
   dbg.start{"set_alias(",concatTbl({...},", "),")"}
   if (not validateArgsWithValue("set_alias",...)) then return end

   mcp:set_alias(...)
   dbg.fini("set_alias")
end

--------------------------------------------------------------------------
-- Unset an alias for bash and csh
function unset_alias(...)
   dbg.start{"unset_alias(",concatTbl({...},", "),")"}
   if (not validateStringArgs("unset_alias",...)) then return end

   mcp:unset_alias(...)
   dbg.fini("unset_alias")
end

--------------------------------------------------------------------------
-- Set an shell function for bash and an alias for csh
function set_shell_function(...)
   dbg.start{"set_shell_function(",concatTbl({...},", "),")"}
   if (not validateStringArgs("set_shell_function",...)) then return end

   mcp:set_shell_function(...)
   dbg.fini()
end

--------------------------------------------------------------------------
-- Unset an shell function for bash and an alias for csh
function unset_shell_function(...)
   dbg.start{"unset_shell_function(",concatTbl({...},", "),")"}
   if (not validateStringArgs("unset_shell_function",...)) then return end

   mcp:unset_shell_function(...)
   dbg.fini("unset_shell_function")
end

--- Prereq / Conflict ---

--------------------------------------------------------------------------
-- Test to see if a prereq module is loaded.  Fail if it is not.
-- If more than one module is listed then it is an and condition.
function prereq(...)
   dbg.start{"prereq(",concatTbl({...},", "),")"}
   if (not validateModules("prereq", ...)) then return end

   mcp:prereq(MName:buildA("load", ...))
   dbg.fini("prereq")
end

--------------------------------------------------------------------------
-- Test to see if a conflict module is loaded.  Fail if it is loaded.
function conflict(...)
   dbg.start{"conflict(",concatTbl({...},", "),")"}
   if (not validateStringArgs("conflict",...)) then return end

   mcp:conflict(MName:buildA("load",...))
   dbg.fini()
end

--------------------------------------------------------------------------
-- Test to see if any of prereq modules are loaded.  Fail if it is not.
-- If more than one module is listed then it is an or condition.
function prereq_any(...)
   dbg.start{"prereq_any(",concatTbl({...},", "),")"}
   if (not validateModules("prereq_any",...)) then return end

   mcp:prereq_any(MName:buildA("load",...))
   dbg.fini("conflict")
end

--- Family function ---

--------------------------------------------------------------------------
-- This function allows only module to claim the name.  It is a
-- generalized prereq/conflict function.
function family(...)
   dbg.start{"family(",concatTbl({...},", "),")"}
   if (not validateStringArgs("family",...)) then return end

   mcp:family(...)
   dbg.fini("family")
end

--- Inherit function ---

--------------------------------------------------------------------------
-- This function finds the same named module in the MODULEPATH and
-- loads it.
function inherit(...)
   dbg.start{"inherit(",concatTbl({...},", "),")"}

   mcp:inherit(...)
   dbg.fini("inherit")
end


-- Whatis / Help functions
--------------------------------------------------------------------------
-- The whatis database function.
function whatis(...)
   dbg.start{"whatis(",concatTbl({...},", "),")"}
   if (not validateStringArgs("whatis",...)) then return end

   mcp:whatis(...)
   dbg.fini("whatis")
end

--------------------------------------------------------------------------
-- the help function.
function help(...)
   dbg.start{"help(...)"}
   if (not validateStringArgs("help",...)) then return end
   mcp:help(...)
   dbg.fini("help")
end

-- Misc --

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
-- Return true if in spider mode.  Use mode function instead.
function is_spider()
   dbg.start{"is_spider()"}
   local b = mcp:is_spider()
   dbg.fini("is_spider")
   return b
end

--------------------------------------------------------------------------
-- Put a command in stdout so it will get executed.
-- @param t the command table.
function execute(t)
   dbg.start{"execute(...)"}
   if (type(t) ~= "table" or not t.cmd or type(t.modeA) ~= "table") then
      mcp:report("Syntax error in file: ", myFileName(), "\n with command: execute",
                 "\nsyntax is:\n",
                 "    execute{cmd=\"command string\",modeA={\"load\",...}}\n")
      return
   end
   local b = mcp:execute(t)
   dbg.fini("execute")
   return b
end

--------------------------------------------------------------------------
-- Return the mode.
function mode()
   dbg.start{"mode()"}
   local b = mcp:mode()
   dbg.fini("mode")
   return b
end

--------------------------------------------------------------------------
-- Return true if the module is loaded.
-- @param m module name
function isloaded(m)
   local mt   = MT:mt()
   if (not validateStringArgs("isloaded",m)) then return false end
   local mname = MName:new("load", m)
   return mname:isloaded()
end


--------------------------------------------------------------------------
-- Return true if the module is in the pending state for a load.
-- @param m module name
function isPending(m)
   local mt = MT:mt()
   if (not validateStringArgs("isPending",m)) then return false end
   local mname = MName:new("mt", m)
   return mname:isPending()
end

--------------------------------------------------------------------------
-- Return the version of Lmod.
function LmodVersion()
   return Version.tag()
end

--------------------------------------------------------------------------
-- Convert version to canonical so that it can be used in a comparison.
function convertToCanonical(s)
   return parseVersion(s)
end

--------------------------------------------------------------------------
-- Return the modules file name.
function myFileName()
   return mcp:myFileName()
end

--------------------------------------------------------------------------
-- Return shell that invoked Lmod.
function myShellName()
   return mcp:myShellName()
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

function userInGroup(group)
   local grps   = capture("groups")
   local found  = false
   local userId = capture("id -u")
   local isRoot = tonumber(userId) == 0
   for g in grps:split("[ \n]") do
      if (g == group or isRoot)  then
         found = true
         break
      end
   end
   return found
end
