#!@path_to_lua@/lua
-- -*- lua -*-
-----------------------------------------------------------------
-- This program reads the saved module tables from a user and records the results

local cmd = arg[0]

local i,j = cmd:find(".*/")
local cmd_dir = "./"
if (i) then
   cmd_dir = cmd:sub(1,j)
end
package.path = cmd_dir .. "?.lua;" .. package.path
require("strict")
require("fileOps")
require("string_split")

local Optiks    = require("Optiks")
local concatTbl = table.concat
local floor     = math.floor
local lfs       = require("lfs")
local mod       = math.mod

function main()
   local optionTbl = options()
   local outputFh  = io.open(optionTbl.fn,"a")
   local iuser     = 0
   local unit      = 2
   local fence     = unit

   --------------------------------------------------------------
   -- count number of active users

   for userName, homeDir in processPWRec("/etc/passwd") do
      local dir = pathJoin(homeDir,".lmod.d",".save")
      if ( isDir(dir)) then
         iuser = iuser + 1
      end
   end
   local nusers = iuser

   iuser = 0
   for userName, homeDir in processPWRec("/etc/passwd") do
      local dir = pathJoin(homeDir,".lmod.d",".save")
      if ( isDir(dir)) then
         iuser   = iuser + 1
         local j = floor(iuser/nusers*100)
         if ( j > fence) then
            io.stdout:write("#")
            io.stdout:flush()
            fence = fence + unit
         end
         for file in lfs.dir(dir) do
            if (file:sub(-4,-1) == ".lua") then
               local mt_date = file:sub(1,19)
               local f = pathJoin(dir,file)
               process(userName, mt_date, f, outputFh)
               if (optionTbl.delete) then
                  os.remove(f)
               end
            end
         end
      end
   end
   io.stdout:write("\n")
end

------------------------------------------------------------------------
-- This function process one saved module table state.  The result is one
-- more line written to the output file.
--
-- Each line is userName,date,MF,MF,...
--   where MF is "full Module Name : modulefile

function process(userName, mt_date, f, outputFh)

   local a = {}
   local resultFn = loadfile(f)

   if (not resultFn) then
      return
   end
   resultFn()

   local mt = _ModuleTable_

   a[#a+1] = userName
   a[#a+1] = mt_date

   for i, v  in ipairs(mt.active.FN) do
      if (v:sub(-4,-1) == ".lua") then
         v = v:sub(1,-5)
      end
      a[#a+1] = "\"" .. mt.active.fullModName[i] .. ":" .. v .. "\""
   end
   local s = concatTbl(a,",")
   outputFh:write(s,"\n")
end






------------------------------------------------------------------------
-- This function returns an iterator:  The iterator returns the next
-- username and homeDir or nil if there are no users left.


function processPWRec(fn)
   io.input(fn)
   return 
     function()
        local line = io.read()
        if (line == nil) then
           return nil
        end
        local a    = {}
        for v in line:split(':') do
           a[#a + 1] = v
        end
        return a[1], a[6]
     end
end


function options()
   local usage         = "Usage: processMT [options]"
   local cmdlineParser = Optiks:new{usage=usage, version="1.0"}

   cmdlineParser:add_option{ 
      name   = {'-v','--verbose'},
      dest   = 'verbosityLevel',
      action = 'count',
   }

   cmdlineParser:add_option{ 
      name    = {'-f', '--file'},
      dest    = 'fn',
      action  = 'store',
      default = "moduleUsage.csv"
   }

   cmdlineParser:add_option{ 
      name   = {'-d', '--delete'},
      dest   = 'delete',
      action = 'store_true',
   }

   local optionTbl, pargs = cmdlineParser:parse(arg)

   return optionTbl

end
main()
