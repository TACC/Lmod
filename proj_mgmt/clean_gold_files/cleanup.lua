#!/usr/bin/env lua
-- -*- lua -*-

require("strict")
require("string_utils")
local Cleanup = require("Cleanup")
local dbg     = require("Dbg"):dbg()



function main()
   -- dbg:activateDebug(1)
   local fn = arg[1]
   local f  = io.open(fn)
   local s
   if (f) then
      local cleanup = Cleanup:new()
      local whole = f:read("*all")
      f:close()
      local resultA = cleanup:filter(whole)
      local s       = table.concat(resultA,"\n")
      fn = arg[2]
      f = io.open(fn,"w")
      f:write(s)
      f:close()
   end
end

main()
