#!/usr/bin/env lua
-- -*- lua -*-

require("strict")
require("declare")

local load       = (_VERSION == "Lua 5.1") and loadstring or load
local runTCLprog = require("tcl2lua").runTCLprog

function main()
   declare("ModA",false)
   local n = 999
   for i = 0, n do
      ModA  = {}
      local fn=string.format("/home/mclay/w/lmod/embed/tcl_versionFiles/.version.%03d",tostring(i))
      local whole, status = runTCLprog("./RC2lua.tcl", fn)
      local ok, func = pcall(load, whole)
      func()
   end
end


main()
