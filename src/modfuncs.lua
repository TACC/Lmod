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
-- modfuncs.lua:  All the functions that are "Lmod" functions are in
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

-- See src/tools/Dbg.lua for details on how this debugging tool works.
--------------------------------------------------------------------------

require("strict")
require("parseVersion")
require("utils")

local dbg         = require("Dbg"):dbg()
local MName       = require("MName")
local ModuleStack = require("ModuleStack")
local Version     = require("Version")
local _concatTbl  = table.concat

local function concatTbl(aa,sep)
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


local function validateStringArgs(cmdName, ...)
   local arg = { n = select('#', ...), ...}
   dbg.print("cmd: ",cmdName, " arg.n: ",arg.n,"\n")
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

local function validateArgsWithValue(cmdName, ...)
   local arg = { n = select('#', ...), ...}

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

function load_module(...)
   dbg.start("load_module(",concatTbl({...},", "),")")
   if (not validateStringArgs("load",...)) then return {} end

   local b = mcp:load(MName:buildA("load",...))
   dbg.fini("load_module")
   return b
end

function try_load(...)
   dbg.start("try_load(",concatTbl({...},", "),")")
   if (not validateStringArgs("try_load",...)) then return {} end

   local b = mcp:try_load(MName:buildA("load",...))
   dbg.fini("try_load")
   return b
end

try_add = try_load

function unload(...)
   dbg.start("unload(",concatTbl({...},", "),")")
   if (not validateStringArgs("unload",...)) then return {} end

   local b = mcp:unload(MName:buildA("mt",...))
   dbg.fini("unload")
   return b
end


function always_load(...)
   dbg.start("always_load(",concatTbl({...},", "),")")
   if (not validateStringArgs("always_load",...)) then return {} end

   local b = mcp:always_load(MName:buildA("load",...))
   dbg.fini("always_load")
   return b
end

function always_unload(...)
   dbg.start("always_unload(",concatTbl({...},", "),")")
   if (not validateStringArgs("always_unload",...)) then return {} end

   local b = mcp:always_unload(MName:buildA("mt",...))
   dbg.fini("always_unload")
   return b
end

--- PATH functions ---

function prepend_path(...)
   dbg.start("prepend_path(",concatTbl({...},", "),")")
   if (not validateStringArgs("prepend_path",...)) then return end

   mcp:prepend_path(...)
   dbg.fini("prepend_path")
end

function append_path(...)
   dbg.start("append_path(",concatTbl({...},", "),")")
   if (not validateStringArgs("append_path",...)) then return end

   mcp:append_path(...)
   dbg.fini("append_path")
end

function remove_path(...)
   dbg.start("remove_path(",concatTbl({...},", "),")")
   if (not validateStringArgs("remove_path",...)) then return end

   mcp:remove_path(...)
   dbg.fini("remove_path")
end

--- Set Environment functions ----

function setenv(...)
   dbg.start("setenv(",concatTbl({...},", "),")")
   if (not validateArgsWithValue("setenv",...)) then return end

   mcp:setenv(...)
   dbg.fini("setenv")
   return
end

function unsetenv(...)
   dbg.start("unsetenv(",concatTbl({...},", "),")")
   if (not validateArgsWithValue("unsetenv",...)) then return end

   mcp:unsetenv(...)
   dbg.fini("unsetenv")
   return
end

function pushenv(...)
   dbg.start("pushenv(",concatTbl({...},", "),")")
   if (not validateArgsWithValue("pushenv",...)) then return end

   mcp:pushenv(...)
   dbg.fini("pushenv")
   return
end

--- Property functions ----

function add_property(...)
   dbg.start("add_property(",concatTbl({...},", "),")")
   if (not validateStringArgs("add_property",...)) then return end

   mcp:add_property(...)
   dbg.fini("add_property")
end

function remove_property(...)
   dbg.start("remove_property(",concatTbl({...},", "),")")
   if (not validateStringArgs("remove_property",...)) then return end

   mcp:remove_property(...)
   dbg.fini("remove_property")
end


--- Set Alias/Shell functions ---

function set_alias(...)
   dbg.start("set_alias(",concatTbl({...},", "),")")
   if (not validateArgsWithValue("set_alias",...)) then return end

   mcp:set_alias(...)
   dbg.fini("set_alias")
end

function unset_alias(...)
   dbg.start("unset_alias(",concatTbl({...},", "),")")
   if (not validateStringArgs("unset_alias",...)) then return end

   mcp:unset_alias(...)
   dbg.fini("unset_alias")
end

function set_shell_function(...)
   dbg.start("set_shell_function(",concatTbl({...},", "),")")
   if (not validateStringArgs("set_shell_function",...)) then return end

   mcp:set_shell_function(...)
   dbg.fini()
end

function unset_shell_function(...)
   dbg.start("unset_shell_function(",concatTbl({...},", "),")")
   if (not validateStringArgs("unset_shell_function",...)) then return end

   mcp:unset_shell_function(...)
   dbg.fini("unset_shell_function")
end

--- Prereq / Conflict ---

function prereq(...)
   dbg.start("prereq(",concatTbl({...},", "),")")
   if (not validateStringArgs("prereq",...)) then return end
   
   mcp:prereq(MName:buildA("mt",...))
   dbg.fini("prereq")
end

function conflict(...)
   dbg.start("conflict(",concatTbl({...},", "),")")
   if (not validateStringArgs("conflict",...)) then return end

   mcp:conflict(MName:buildA("mt",...))
   dbg.fini()
end

function prereq_any(...)
   dbg.start("prereq_any(",concatTbl({...},", "),")")
   if (not validateStringArgs("prereq_any",...)) then return end

   mcp:prereq_any(MName:buildA("mt",...))
   dbg.fini("conflict")
end

--- Family function ---

function family(...)
   dbg.start("family(",concatTbl({...},", "),")")
   if (not validateStringArgs("family",...)) then return end

   mcp:family(...)
   dbg.fini("family")
end

--- Inherit function ---

function inherit(...)
   dbg.start("inherit(",concatTbl({...},", "),")")

   mcp:inherit(...)
   dbg.fini("inherit")
end


-- Whatis / Help functions

function whatis(...)
   dbg.start("whatis(",concatTbl({...},", "),")")
   if (not validateStringArgs("whatis",...)) then return end

   mcp:whatis(...)
   dbg.fini("whatis")
end

function help(...)
   dbg.start("help(...)")
   if (not validateStringArgs("help",...)) then return end
   mcp:help(...)
   dbg.fini("help")
end

-- Misc --

function LmodError(...)
   local b = mcp:error(...)
   return b
end

function LmodWarning(...)
   local b = mcp:warning(...)
   return b
end

function LmodMessage(...)
   local b = mcp:message(...)
   return b
end

function is_spider()
   dbg.start("is_spider()")
   local b = mcp:is_spider()
   dbg.fini("is_spider")
   return b
end

function execute(t)
   dbg.start("execute(...)")
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

function mode()
   dbg.start("mode()")
   local b = mcp:mode()
   dbg.fini("mode")
   return b
end

function isloaded(m)
   local mt = MT:mt()
   if (not validateStringArgs("isloaded",m)) then return false end
   local mname = MName:new("mt", m)
   return mt:have(mname:sn(),"active")
end

function isPending(m)
   local mt = MT:mt()
   if (not validateStringArgs("isPending",m)) then return false end
   local mname = MName:new("mt", m)
   return mt:have(mname:sn(),"pending")
end

function LmodVersion()
   return Version.tag()
end

function convertToCanonical(s)
   return concatTbl(parseVersion(s))
end

function myFileName()
   return mcp:myFileName()
end

function myShellName()
   return mcp:myShellName()
end

function myModuleFullName()
   return mcp:myModuleFullName()
end

function myModuleName()
   return mcp:myModuleName()
end

function myModuleUsrName()
   return mcp:myModuleUsrName()
end

function myModuleVersion()
   return mcp:myModuleVersion()
end

function hierarchyA(package, levels)
   local fn  = myFileName():gsub("%.lua$","")

   if (levels < 1) then
      return {}
   end

   -- Remove package from end of string by using the
   -- "plain" matching via string.find function
   package = path_regularize(package:gsub("%.lua$",""))
   local i,j = fn:find(package,1,true)
   if (j == fn:len()) then
      fn = fn:sub(1,i-1)
   end

   fn = path_regularize(fn)
   local j          = 0
   local numEntries = 0
   while (j) do
      j          = package:find("/",j+1)
      numEntries = numEntries + 1
   end

   local a = {}

   for dir in fn:split("/") do
      a[#a + 1] = dir
   end

   local b = {}
   local n = #a

   for i = 1, levels do
      local bb = {}
      for j = 1, numEntries do
         local idx = n - numEntries + j
         bb[j] = a[idx]
      end
      b[i] = concatTbl(bb,'/')
      n = n - numEntries
   end

   return b
end
