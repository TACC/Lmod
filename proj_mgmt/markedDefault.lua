#!/usr/bin/env lua
-- -*- lua -*-

require("strict")
require("string_utils")
require("deepcopy")

local dbg             = require("Dbg"):dbg()
local concatTbl       = table.concat
local s_fullNameDfltT = {}

local function l_marked_default(t, fullName, weight)
   local a = {}
   local n = 0
   for s in fullName:split("/") do
      n = n + 1
      a[n] = s
   end

   local function l_marked_default_helper(i,n,a,t,weight)
      --dbg.start{"l_marked_default_helper(i: ",i,", n: ",n,", weight: ",weight,")"}
      local s = a[i]
      t[s] = t[s] or {}
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

local function l_find_all_sn(sn, t)
   dbg.print{"\nl_find_all_sn(sn: \"",sn,"\", t)"}

   local snA = {}
   local n = 0
   for s in sn:split("/") do
      n      = n + 1
      snA[n] = s
   end

   if (n < 1) then
      print("not found")
      return
   end

   local found = false
   for i = 1, n do
      local s = snA[i]
      if (t[s] and t[s].tree) then
         t = t[s].tree
         found = (i == n)
      end
   end

   if (not found) then
      print("not found")
      return
   end
   dbg.print{"\n"}
   dbg.printT("t",t)

   local a = {}
   for k, v in pairs(t) do
      find_all_versions(k,v,a,{})
   end
   dbg.print{"\n"}
   dbg.printT("a",a)
end

function find_all_versions(k,t,a,b)
   --dbg.start{"find_all_versions(k,t,a,b)"}
   b[#b+1] = k
   if (t.tree) then
      t = t.tree
      for kk, v in pairs(t) do
         find_all_versions(kk,v,a,deepcopy(b))
      end
   elseif (t.weight) then
      a[#a+1] = { version = concatTbl(b,"/"), weight = t.weight}
   else
      print("Something went wrong!")
      os.exit(-1)
   end
   --dbg.fini("find_all_versions")
end

function main()
   local fullA = {{"compiler/intel/x86/24.1","s"},
                  {"compiler/intel/x86/22.1","s"},
                  {"compiler/intel/x86/blue/22.1","s"},
                  {"compiler/intel/x86/blue/24.1","s"},
                  {"compiler/intel/arm64/22.1","s"},
                  {"compiler/gcc/14.1",      "s"},
                  {"gcc/12.1",               "s"},
                  {"gcc/14.1",               "s"},
                  {"gcc/14.1",               "s"},
                  {"gcc/14.1",               "u"},
                  {"gcc/13.1",               "u"},
                  {"intel/24.1",             "s"},
                  {"intel/22.1",             "s"},
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
   --dbg.printT("s_fullNameDfltT",t)
   l_find_all_sn("compiler/intel",s_fullNameDfltT)
   l_find_all_sn("compiler/gcc",s_fullNameDfltT)
   l_find_all_sn("gcc",s_fullNameDfltT)
end


main()
