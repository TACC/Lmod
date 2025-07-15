#!/usr/bin/env lua
-- -*- lua -*-

local arg_0    = arg[0]
_G._DEBUG      = false
local posix    = require("posix")
local readlink = posix.readlink
local stat     = posix.stat
local st       = stat(arg_0)
while (st.type == "link") do
   local lnk = readlink(arg_0)
   if (arg_0:find("/") and (lnk:find("^/") == nil)) then
      local dir = arg_0:gsub("/[^/]*$","")
      lnk       = dir .. "/" .. lnk
   end
   arg_0 = lnk
   st    = stat(arg_0)
end

local ia,ja = arg_0:find(".*/")
local LuaCommandName     = false
local LuaCommandName_dir = "./"
if (ia) then
   LuaCommandName_dir = arg_0:sub(1,ja)
   LuaCommandName     = arg_0:sub(ja+1)
end

package.path  = LuaCommandName_dir .. "?.lua;"              ..
                LuaCommandName_dir .. "../../tools/?.lua;"  ..
                package.path

require("strict")
require("string_utils")
local Cleanup = require("Cleanup")
local dbg     = require("Dbg"):dbg()



function main()
   -- dbg:activateDebug(1)
   local shellName = "bash"
   if ( arg[1]:sub(1,1) == "-") then
      shellName = arg[1]:sub(3,-1)
      table.remove(arg,1)
   end

   local fn = arg[1]
   local f  = io.open(fn)
   local s
   if (f) then
      local cleanup = Cleanup:new(shellName)
      local whole = f:read("*all")
      f:close()
      local resultA = cleanup:filter(whole)
      local s       = table.concat(resultA,"\n")
      fn = arg[2]
      f = io.open(fn,"w")
      if (s and s ~= "") then 
         f:write(s,"\n")
      end
      f:close()
   end
end

main()
