#!/usr/bin/env lua
-- -*- lua -*-

require("strict")
require("string_utils")
local dbg = require("Dbg"):dbg()

local s_fullNameDfltT = {}

local function l_marked_default(fullName, weight)
   local t = s_fullNameDfltT
   local a = {}
   local n = 0
   for s in fullName:split("/") do
      a[#a+1] = s
      n = n + 1
   end

   local function l_marked_default_helper(i,n,a,t,weight)
      local s = a[i]
      if (not t[s] ) then
         t[s] = {}
      end
      if (i == n) then
         t[s].weight = weight
         return
      else
         t[s].tree   = {}
         l_marked_default_helper(i+1,n,a,t[s].tree)
      end
   end

   l_marked_default_helper(1,n,a,t,weight)
end      

function main()
   local fullA = {{"compiler/intel/x86/24.1","s"},
                  {"compiler/intel/x86/22.1","s"},
                  {"compiler/gcc/14.1",      "s"},
   }
   local fullA = {{"compiler/intel/x86/24.1","s"},
   }
   local fullA = {{"TACC","s"},
   }

   dbg:activateDebug()
   
   for i = 1,#fullA do
      local entry    = fullA[i]
      local fullName = entry[1]
      local weight   = entry[1]
      l_marked_default(fullName,weight)
      dbg.printT("s_fullNameDfltT",s_fullNameDfltT)
   end

end


main()
