#!/usr/bin/env lua
-- -*- lua -*-

package.path = "../tools/?.lua;" .. package.path

require("strict")
require("string_utils")
require("serializeTbl")
local dbg = require("Dbg"):dbg()

function argsPack(...)
   local argA = { n = select("#", ...), ...}
   return argA
end

local pack         = (_VERSION == "Lua 5.1") and argsPack or table.pack   -- luacheck: compat
local unpack       = (_VERSION == "Lua 5.1") and unpack   or table.unpack -- luacheck: compat
local huge         = math.maxinteger or math.huge

------------------------------------------------------------------------
-- Fake Lmod variables and functions


local mcp          = "mcp"
local MCP          = "MCP"
local MCPQ         = "quiet"
function mode()
   return "load"
   --return "unload"
   --return "show"
end

local s_purgeFlg = false

function purgeFlg()
   return s_purgeFlg
end

------------------------------------------------------------------------
-- Mode function check.  It checks to see that argT.modeA is a table
-- Does not return when error is found

local s_validModeT = {
   normal = true,
   load   = true,
   unload = true,
}
                      

local function l_modeCk(argT)
   local modeA = argT.modeA
   if (type(modeA) ~= "table") then
      print(argT.__cmdName.." has a bad mode \""..tostring(modeA).."\". It must be a table.")
      os.exit(1)
   end
      
   for i = 1, #modeA do
      local my_mode = modeA[i]
      if (not s_validModeT[my_mode]) then
         print(argT.__cmdName.." has a bad mode \""..my_mode.."\"")
         os.exit(1)
      end
   end
end

------------------------------------------------------------------------
-- Check functions for prepend_path type functions
-- These do not return on error

local function l_priorityCk(argT)
   if (argT.priority == nil or type(argT.priority) == "number") then
      return true
   end
   print(argT.__cmdName.." has a bad priority \""..tostring(argT.priority) .. "\". It must be a number")
   os.exit(1)
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
   print(argT.__cmdName.." has a bad delim \""..tostring(argT.delim) .. "\". It must be a string")
   os.exit(1)
end

------------------------------------------------------------------------
-- Check function for validating modules
-- Does not return on error

local function l_validateModules(argT)
   local allGood = true
   for i = 1, argT.n do
      local v = argT[i]
      if (type(v) == "string") then
         allGood = true
      elseif (type(v) == "table" and v.__waterMark == "MName") then
         allGood = true
      else
         allGood = false
         break
      end
   end
   if (not allGood) then
      print(argT.__cmdName.." has a bad module")
      os.exit(1)
      --mcp:report{msg="e_Args_Not_Strings", fn = myFileName(), cmdName = cmdName}
   end
end

------------------------------------------------------------------------
-- This function is used by the rules.checkA table
-- Does not return on error

local function l_validateArgs(argT, checkA)
   for i = 1, argT.n do
      local arg = argT[i]
      local result, my_kind = checkA[i](arg)
      if (not result) then
         -- replace with mcp:report
         print(argT.__cmdName.." has a bad argument \""..tostring(arg).."\". It should be type ".. my_kind)
         os.exit(1)
      end
   end
end   

------------------------------------------------------------------------
-- This function is used by the rules.checkTblArg table
-- Does not return on error 

local function l_validateTblArgs(argT, checkTblArgs)
   for i = 1, #checkTblArgs do
      checkTblArgs[i](argT)  -- Will not return if error
   end
end

------------------------------------------------------------------------
-- Check functions for arguments.  Used in rulesT.checkA table

local function l_stringCk(value)
   return type (value) == "string", "string"
end

local function l_booleanCk(value)
   return type (value) == "boolean", "boolean"
end

local function l_stringValueCk(value)
   local my_type = type(value)
   return my_type == "string" or my_type == "number" or my_type == "boolean", "string_or_value"
end




------------------------------------------------------------------------
-- Trim requested arguments
local function l_trim_first_arg(argT)
   argT[1] = argT[1]:trim()
end

local function l_trim_all_strings_args(argT)
   for i = 1, argT.n do
      if (type(argT[1]) == "string") then
         argT[i] = argT[i]:trim()
      end
   end
end

------------------------------------------------------------------------
-- Rules tables checking arguments for setenv, prepend_path and
-- load module functions

local s_setenv_rulesT = {
   sizeN        = {min=2, max=3},
   checkA       = {l_stringCk, l_stringValueCk, l_booleanCk},
   checkTblArgs = { l_modeCk },
   trimArg      = l_trim_first_arg,
}

local s_pushenv_rulesT = {
   sizeN        = {min=2, max=2},
   checkA       = {l_stringCk, l_stringValueCk},
   checkTblArgs = { l_modeCk },
   trimArg      = l_trim_first_arg,
}

local s_unsetenv_rulesT = {
   sizeN        = {min=1, max=2},
   checkA       = {l_stringCk, l_stringValueCk},
   checkTblArgs = { l_modeCk },
   trimArg      = l_trim_first_arg,
}

local s_prepend_rulesT = {
   sizeN = {min=2, max=3},
   checkA = {l_stringCk, l_stringCk, l_stringCk },
   checkTblArgs = { l_modeCk, l_priorityCk, l_delimCk},
   trimArg      = l_trim_first_arg,
}

local s_remove_rulesT = {
   sizeN = {min=2, max=3},
   checkA = {l_stringCk, l_stringCk, l_stringCk },
   checkTblArgs = { l_modeCk, l_delimCk},
   trimArg      = l_trim_first_arg,
}

local s_load_rulesT = {
   sizeN        = {min = 1, max = huge},
   checkList    = l_validateModules,
   checkTblArgs = { l_modeCk },
   trimArg      = l_trim_all_strings_args,
}


      
      
------------------------------------------------------------------------
-- This function uses the rules table to check all the arguments

local function l_check_argT(argT, rulesT)

   -- check number of regular arguments
   if (argT.n < rulesT.sizeN.min or argT.n > rulesT.sizeN.max) then
      -- replace with mcp:report
      print(argT.__cmdName.." has the wrong number of args")
      os.exit(1)
   end

   if (rulesT.checkA and next(rulesT.checkA) ~= nil) then
      l_validateArgs(argT, rulesT.checkA) -- Will not return if error
   end

   if (next(rulesT.checkTblArgs) ~= nil) then
      l_validateTblArgs(argT, rulesT.checkTblArgs) -- Will not return if error
   end

   if (rulesT.checkArgList) then
      rulesT.checkArgList(argT) -- Will not return if error
   end
   
   if (rulesT.trimArg) then
      rulesT.trimArg(argT)
   end
end


------------------------------------------------------------------------
-- This function uses the argT.modeA to return the correct mcp
-- Note that all argT must have a argT.modeA array

local function l_chose_mcp(argT)
   local my_mode = mode()
   if (my_mode == "show" or purgeFlg()) then
      return mcp
   end

   local modeA   = argT.modeA
   local action  = false
   local my_mcp
   for i = 1, #modeA do
      if (modeA[i] == "normal") then
         my_mcp = mcp
         action = true
         break
      end
      if (my_mode == modeA[i]) then
         my_mcp = MCP
         action = true
         break
      end
   end
   if (not action) then
      my_mcp = MCPQ
   end
   return my_mcp
end


------------------------------------------------------------------------
-- This function converts the arg list into an arg table called argT.
-- If the mode is not specified then the mode is set to "normal"

local function l_build_argTable(cmdName, first_elem, ... )
   local argT

   if (type(first_elem) == "table") then
      argT           = first_elem
      argT.__cmdName = cmdName
      argT.kind      = "Table"
      argT.n         = #argT
      if (not argT.modeA) then
         if (not (type(argT.modeA) == "table" and next(argT.modeA) ~= nil)) then
            argT.modeA = {"normal"}
         end
      end
   else
      argT           = pack(first_elem, ...)
      argT.__cmdName = cmdName
      argT.modeA     = {"normal"}
      argT.kind      = "Array"
   end
   return argT
end
      
------------------------------------------------------------------------
-- This function is the one to rule then all.
--  1) It uses l_build_argTable to build argT
--  2) It uses l_check_argT  to see all arguments are valid.
--  3) If dbg is active it generate the dbg.start() string
--     for the parent routine (not this one)

local function l_build_check_argT(cmdName, rulesT, first_elem, ... )
   local argT = l_build_argTable(cmdName, first_elem, ... )
   l_check_argT(argT, rulesT)  -- Will not return if error
   if (dbg.active()) then
      local s = cmdName .. serializeTbl{value=argT,tight="tight",dsplyNum="string",ignoreKeysT = {n = true, kind = true}} --:gsub("\n"," "):gsub(", *}"," }")
      dbg.start{s}
   end
   return argT
end

------------------------------------------------------------------------
-- Fake modfunc routine to similate evaluating a modulefile


function setenv(...)
   local argT    = l_build_check_argT("setenv", s_setenv_rulesT, ...)
   local mcp_old = mcp
   mcp = l_chose_mcp(argT)

   ---mcp:setenv(argT)
   mcp_setenv(mcp, argT)
   mcp = mcp_old
   dbg.fini("setenv")
end

function pushenv(...)
   local argT    = l_build_check_argT("pushenv", s_pushenv_rulesT, ...)
   local mcp_old = mcp
   mcp = l_chose_mcp(argT)

   ---mcp:pushenv(argT)
   mcp_pushenv(mcp, argT)
   mcp = mcp_old
   dbg.fini("pushenv")
end

function prepend_path(...)
   local argT    = l_build_check_argT("prepend_path", s_prepend_rulesT, ...)
   local mcp_old = mcp
   mcp = l_chose_mcp(argT)

   ---mcp:prepend_path(argT)
   mcp_prepend_path(mcp, argT)
   mcp = mcp_old
   dbg.fini("prepend_path")
end

function append_path(...)
   local argT    = l_build_check_argT("append_path", s_prepend_rulesT, ...)
   local mcp_old = mcp
   mcp = l_chose_mcp(argT)

   ---mcp:append_path(argT)
   mcp_append_path(mcp, argT)
   mcp = mcp_old
   dbg.fini("append_path")
end

function load_module(...)
   local argT    = l_build_check_argT("load_module", s_load_rulesT, ...)
   local mcp_old = mcp
   mcp = l_chose_mcp(argT)

   --mcp:load_module(argT)
   mcp_load_module(mcp, argT)
   mcp = mcp_old
   dbg.fini("load_module")
end

------------------------------------------------------------------------
-- Fake MainControl routines to show the action


function mcp_setenv(mcp, argT)
   if (mcp ~= "quiet") then
      print("  export ".. argT[1] .. "=" .. tostring(argT[2]))
   end
end

function mcp_pushenv(mcp, argT)
   if (mcp ~= "quiet") then
      print("  pushenv ".. argT[1] .. "=" .. tostring(argT[2]))
   end
end

function mcp_prepend_path(mcp, argT)
   if (mcp ~= "quiet") then
      print("  Prepending \""..argT[2].." to "..argT[1])
   end
end

function mcp_append_path(mcp, argT)
   if (mcp ~= "quiet") then
      print("  Appending \""..argT[2].." to "..argT[1])
   end
end

function mcp_load_module(mcp, argT)
   if (mcp ~= "quiet") then
      print("  loading modules: ",table.concat(argT, " "))
   end
end

------------------------------------------------------------------------
-- Driver routine.

function main()
   dbg:activateDebug(1)
   
   print("My mode is: ",mode(),"\n")


   setenv("A ", "B")
   setenv{"A", "B"}
   setenv("A", false)
   setenv("A", "B", true)
   setenv{"A", "B", modeA = {"unload"}}

   pushenv("A", "B")
   pushenv{"A", "B", modeA = {"unload"}}
   
   prepend_path("PATH", "/a/B")
   prepend_path("PATH", "/a/B",":")
   prepend_path{"PATH", "/a/B"}
   prepend_path{"PATH", "/a/B", priority=10, delim=";"}
   append_path("MODULEPATH", "/a/B")
   append_path("MODULEPATH", "/a/B",":")
   append_path{"MODULEPATH", "/a/B"}

   load_module("A", "B", "C")

   setenv{"A", "B", modeA = true}

end

main()
