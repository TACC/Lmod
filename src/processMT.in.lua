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
require("declare")


_ModuleTable_ = false
moduleInfoT = false
local Optiks      = require("Optiks")
local ProgressBar = require("ProgressBar")
local concatTbl   = table.concat
local lfs         = require("lfs")

function main()
   local optionTbl = options()
   local outputFh  = io.open(optionTbl.fn,"a")

   --------------------------------------------------------------
   -- count number of active users

   -- get number of user from number of lines in /etc/passwd
   
   local passwd = optionTbl.passwd
   local line   = capture("wc -l " .. passwd)
   local nusers = line:match("(%d+)")
   local pb     = ProgressBar:new{stream = io.stdout, max = nusers, barWidth=100}


   local iuser = 0
   for userName, homeDir in processPWRec(passwd) do
      iuser   = iuser + 1
      pb:progress(iuser)

      local dir  = pathJoin(homeDir,".lmod.d",".save")
      local attr = lfs.attributes(dir)
      if ( attr and attr.mode == "directory") then
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

      local dir = pathJoin(homeDir,".lmod.d",".saveBatch")
      local attr = lfs.attributes(dir)
      if ( attr and attr.mode == "directory") then
         for file in lfs.dir(dir) do
            if (file:sub(-4,-1) == ".lua") then
               local mt_date = file:sub(1,19)
               local f = pathJoin(dir,file)
               processBatch(userName, mt_date, f, outputFh)
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
   if (_ModuleTable_ == nil or type(_ModuleTable_) ~= "table" ) then return end

   a[#a+1] = userName
   a[#a+1] = mt_date

   if (_ModuleTable_.version == 1) then
      local mt=_ModuleTable_
      if (mt           and type(mt)           == "table" and
          mt.active    and type(mt.active)    == "table" and
          mt.active.FN and type(mt.active.FN) == "table") then
         for i, v  in ipairs(mt.active.FN) do
            if (v and mt.active.fullModName and type(mt.active.fullModName) == table )then
               a[#a+1] = "\"" .. mt.active.fullModName[i] .. ":" .. v:gsub("%.lua$","") .. "\""
            end
         end
      end
   else
      local mT = _ModuleTable_.mT
      if (mT and type(mT) == "table") then
         for pkg, v in pairs(mT) do
            if (v.fullName and v.FN) then
               a[#a+1] = "\"" .. v.fullName .. ":" .. v.FN:gsub("%.lua$","") .. "\""
            end
         end
      end
   end
   if (#a > 2) then
      local s = concatTbl(a,",")
      outputFh:write(s,"\n")
   end
end

------------------------------------------------------------------------
-- This function process one saved module table state.  The result is one
-- more line written to the output file.
--
-- Each line is userName,date,MF,MF,...
--   where MF is "full Module Name : modulefile

function processBatch(userName, mt_date, f, outputFh)

   local a = {}
   local resultFn = loadfile(f)

   if (not resultFn) then
      return
   end
   resultFn()

   
   if (moduleInfoT and isDefined("moduleInfo") and type(moduleInfo) == "table" and
       moduleInfoT.modFullName and
       moduleInfoT.fn) then
      a[#a+1] = userName
      a[#a+1] = mt_date
      a[#a+1] = moduleInfoT.modFullName
      a[#a+1] = moduleInfoT.fn:gsub("%.lua$","")
      local s = concatTbl(a,",")
      outputFh:write(s,"\n")
   end
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
      name   = {'--delete'},
      dest   = 'delete',
      action = 'store_true',
   }

   cmdlineParser:add_option{ 
      name   = {'--passwd'},
      dest   = 'passwd',
      action = 'store',
      default = "/etc/passwd",
   }

   local optionTbl, pargs = cmdlineParser:parse(arg)

   return optionTbl

end
main()
