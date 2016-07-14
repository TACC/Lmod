#!@path_to_lua@/lua
-- -*- lua -*-

--------------------------------------------------------------------------
-- Fixme
-- @script processMT

--------------------------------------------------------------------------
-- Lmod License
--------------------------------------------------------------------------
--
--  Lmod is licensed under the terms of the MIT license reproduced below.
--  This means that Lmod is free software and can be used for both academic
--  and commercial purposes at absolutely no cost.
--
--  ----------------------------------------------------------------------
--
--  Copyright (C) 2008-2014 Robert McLay
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

-----------------------------------------------------------------
-- This program reads the saved module tables from a user and records the results

local sys_lua_path = "@sys_lua_path@"
if (sys_lua_path:sub(1,1) == "@") then
   sys_lua_path = package.path
end

local sys_lua_cpath = "@sys_lua_cpath@"
if (sys_lua_cpath:sub(1,1) == "@") then
   sys_lua_cpath = package.cpath
end

package.path   = sys_lua_path
package.cpath  = sys_lua_cpath

local arg_0    = arg[0]
local posix    = require("posix")
local readlink = posix.readlink
local stat     = posix.stat

local st       = stat(arg_0)
while (st.type == "link") do
   arg_0 = readlink(arg_0)
   st    = stat(arg_0)
end

local ia,ja = arg_0:find(".*/")
local cmd_dir = "./"
if (ia) then
   cmd_dir = arg_0:sub(1,ja)
end

package.path  = cmd_dir .. "../tools/?.lua;"  ..
                cmd_dir .. "../shells/?.lua;" ..
                cmd_dir .. "?.lua;"           ..
                sys_lua_path
package.cpath = sys_lua_cpath

require("strict")
require("fileOps")
require("string_utils")
require("myGlobals")
require("declare")


_ModuleTable_ = false
moduleInfoT = false
local dbg         = require("Dbg"):dbg()
local Optiks      = require("Optiks")
local ProgressBar = require("ProgressBar")
local concatTbl   = table.concat
local lfs         = require("lfs")

function cmdDir()
   return cmd_dir
end
function main()
   local optionTbl = options()
   if (optionTbl.debug) then
      dbg:activateDebug(1)
   end

   dbg.start{"processMT()"}

   local outputFh  = io.open(optionTbl.fn,"a")

   --------------------------------------------------------------
   -- count number of active users

   -- get number of user from number of lines in /etc/passwd

   local passwd = optionTbl.passwd
   local line   = capture("wc -l " .. passwd)
   local nusers = line:match("(%d+)")
   local pb     = ProgressBar:new{stream = io.stdout, max = nusers, barWidth=100}

   dbg.print{"nusers: ",nusers,"\n"}

   local iuser = 0
   for userName, homeDir in processPWRec(passwd) do
      iuser   = iuser + 1
      if (not optionTbl.quiet) then
         pb:progress(iuser)
      end


      local dir  = pathJoin(homeDir,".lmod.d",USER_SAVE_DIR_NAME)
      local attr = lfs.attributes(dir)
      dbg.print{"user: ",iuser," userName: ",userName," dir: ",dir,"\n"}
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

      dir  = pathJoin(homeDir,".lmod.d",USER_SBATCH_DIR_NAME)
      attr = lfs.attributes(dir)
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
   dbg.fini("processMT")
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


   if (moduleInfoT and isDefined("moduleInfo") and type(moduleInfoT) == "table" and
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
      name   = {'--quiet'},
      dest   = 'quiet',
      action = 'store_true',
   }

   cmdlineParser:add_option{
      name   = {'-D'},
      dest   = 'debug',
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
