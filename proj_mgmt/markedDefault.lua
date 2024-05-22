#!/usr/bin/env lua
-- -*- lua -*-

require("strict")
require("string_utils")
local dbg = require("Dbg"):dbg()

local s_fullNameDfltT = {}

local function l_marked_default(t, fullName, weight)
   local a = {}
   local n = 0
   for s in fullName:split("/") do
      a[#a+1] = s
      n = n + 1
   end

   local function l_marked_default_helper(i,n,a,t,weight)
      --dbg.start{"l_marked_default_helper(i: ",i,", n: ",n,", weight: ",weight,")"}
      local s = a[i]
      if (not t[s] ) then
         t[s] = {}
      end
      if (i == n) then
         t[s].weight = weight
         --dbg.fini("l_marked_default_helper via end of recursiion")
         return
      else
         t[s].tree   = t[s].tree or {}
         l_marked_default_helper(i+1,n,a,t[s].tree, weight)
      end
      --dbg.fini("l_marked_default_helper")
   end

   l_marked_default_helper(1,n,a,t,weight)
   return t
end      

function main()
   local fullA = {{"compiler/intel/x86/24.1","s"},
                  {"compiler/intel/x86/22.1","s"},
                  {"compiler/gcc/14.1",      "s"},
   }

   dbg:activateDebug()
   
   local t = s_fullNameDfltT

   for i = 1,#fullA do
      local entry    = fullA[i]
      local fullName = entry[1]
      local weight   = entry[2]
      dbg.print{"fullName: ",fullName, ", weight: ",weight,"\n"}
      t = l_marked_default(t, fullName,weight)
   end
   dbg.printT("s_fullNameDfltT",t)

end


main()
