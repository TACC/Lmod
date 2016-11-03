--------------------------------------------------------------------------
--------------------------------------------------------------------------
-- This class reads all the cache files in.  It will on occasion
-- write a user cache file.  This is a singleton class.
--
-- Rules: The rules about when to trust a cache file or not also when to
-- write a cache file out in the user directory.
--
--   0.   Cache files are trusted to know what module files are in the
--        MODULEPATH.  This means that if one adds a modulefile WITHOUT
--        updating the cache, LMOD DOES NOT KNOW ABOUT IT!!!.  This is
--        not a bug but a feature.
--
--   1.   A cache file can have a system timestamp associated with it.
--        If it does then as long as the cache file is the same or newer
--        then the timestamp then it is good forever.
--   2.   A cache file without a timestamp is considered good for no more
--        than "ancient" seconds old.  It is whatever was configured with
--        Lmod. Typically "ancient" is 86400 seconds or 24 hours.
--   3.   Modulefiles under system control can (should?) have a timestamp
--        associated with but personal modulefiles typically do not.
--   4.   Any PATH in MODULEPATH that are not covered by any modulefiles
--        are walked.  If the time associated with building the cache file
--        is short then no user cache file is written. Short is typically
--        10 seconds and it is set at configure time.
-- @classmod Cache

require("strict")

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
--  Copyright (C) 2008-2016 Robert McLay
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

require("myGlobals")
require("fileOps")
require("declare")
require("lmod_system_execute")
require("string_utils")
require("utils")

local CTimer     = require("CTimer")
local FrameStk   = require("FrameStk")
local M          = {}
local MRC        = require("MRC")
local ReadLmodRC = require('ReadLmodRC')
local Spider     = require("Spider")
local concatTbl  = table.concat
local dbg        = require("Dbg"):dbg()
local hook       = require("Hook")
local lfs        = require("lfs")
local posix      = require("posix")
local s_cache    = false
local timer      = require("Timer"):singleton()

--------------------------------------------------------------------------
-- This singleton construct reads the scDescriptT table that can be
-- defined in the lmodrc.lua.  Typically this table, if it exists
-- by the configure script.  If it does not then scDescriptT will
-- be an array with zero entries.  This ctor finds all the system
-- and user directories where cache files are stored.  It also
-- figure out the timestamps.
-- @param self A Cache object
-- @param t A table with possible dontWrite and quiet entries.
local function new(self, t)
   local o = {}
   setmetatable(o,self)
   self.__index = self

   dbg.start{"Cache:new()"}

   local readLmodRC  = ReadLmodRC:singleton()
   local scDescriptT = readLmodRC:scDescriptT()

   local scDirA = {}

   local systemEpoch = epoch() - ancient

   dbg.print{"#scDescriptT: ",#scDescriptT, "\n"}
   local CLuaV = 0
   for s in LuaV:split("%.") do
      CLuaV = CLuaV*1000+tonumber(s)
   end
   CLuaV  = tostring(CLuaV)


   local compiled_ext_sys = "luac_"..LuaV
   local compiled_ext_usr = "luac_"..CLuaV
   for j  = 1, #scDescriptT  do
      local entry = scDescriptT[j]
      local tt    = {}
      if (entry.timestamp) then
         hook.apply("parse_updateFn", entry.timestamp, tt)
      end

      local lastUpdate = tt.lastUpdateEpoch or systemEpoch

      local a = {}
      if (tt.hostType and tt.hostType ~= "") then
         a[#a+1] = tt.hostType
      end
      a[#a+1] = ""
      for i = 1,#a do
         local dir  = pathJoin(entry.dir ,a[i])
         local attr = lfs.attributes(dir) or {}
         if (attr.mode == "directory") then
            dbg.print{"Adding: dir: ",dir,", timestamp: ",lastUpdate, "\n"}
            scDirA[#scDirA+1] =
               { fileA = { pathJoin(dir, "spiderT."     .. compiled_ext_sys),
                           pathJoin(dir, "spiderT.old." .. compiled_ext_sys),
                           pathJoin(dir, "spiderT.lua"),
                           pathJoin(dir, "spiderT.old.lua"),
                         },
                 timestamp = lastUpdate,
                 fileT = "system",
               }
            break
         end
      end
   end

   local usrSpiderT   = hook.apply("groupName","spiderT.lua")
   local usrSpiderT_C = hook.apply("groupName","spiderT."..compiled_ext_usr)

   local usrSpiderTFnA = {
      { fileA = { pathJoin(usrCacheDir, usrSpiderT_C),
                  pathJoin(usrCacheDir, usrSpiderT),
                  pathJoin(usrCacheDir, "spiderT."..compiled_ext_usr),
                  pathJoin(usrCacheDir, "spiderT.lua"),
                },
        fileT = "your",
        timestamp = systemEpoch
      },
   }

   t                   = t or {}
   o.spiderDirT        = {}
   o.mDT               = {}
   o.usrCacheDir       = usrCacheDir
   o.usrCacheInvalidFn = pathJoin(usrCacheDir,"invalidated")
   o.usrSpiderTFnA     = usrSpiderTFnA
   o.usrSpiderTFN      = pathJoin(usrCacheDir,usrSpiderT)
   o.systemDirA        = scDirA
   o.dontWrite         = t.dontWrite or false
   o.buildCache        = false
   o.quiet             = t.quiet     or false

   o.dbT               = {}
   o.spiderT           = {}
   o.mpathMapT         = {}
   o.moduleDirA        = {}
   dbg.fini("Cache.new")
   return o
end

--------------------------------------------------------------------------
-- This is the front-end to the singleton ctor.  It
-- (obviously) constructs the static s_cache var once
-- then serves s_cache to subsequent callers.  Since
-- the MODULEPATH can change during execution, we set
-- spiderDirT[path] to -1 for any we have not already
-- processed.
-- @param self a Cache object
-- @param t A table with possible dontWrite and quiet entries.
-- @return A singleton Cache object.
function M.singleton(self, t)
   dbg.start{"Cache:cache()"}

   if (not s_cache) then
      s_cache   = new(self, t)
   end

   t                = t or {}
   s_cache.quiet    = t.quiet or s_cache.quiet
   if (t.buildCache) then
      s_cache.buildCache = t.buildCache
   end

   dbg.print{"s_cache.buildCache: ",self.buildCache,"\n"}

   local frameStk  = FrameStk:singleton()
   local mt        = frameStk:mt()
   local mpathA    = mt:modulePathA()

   -- Since this function can get called many times, we need to only recompute
   -- on the directories we have not yet seen.

   local mDT        = s_cache.mDT
   local spiderDirT = s_cache.spiderDirT
   for i = 1, #mpathA  do
      local mpath = mpathA[i]
      if (isDir(mpath)) then
         local attr = lfs.attributes(mpath) or {}
         if (attr.mode == "directory") then
            mDT[mpath]        = mDT[mpath]        or -1
            spiderDirT[mpath] = spiderDirT[mpath] or false
            dbg.print{"spiderDirT[",mpath,"]: ",spiderDirT[mpath], "\n",level=2}
         end
      end
   end

   dbg.fini("Cache:cache")
   return s_cache
end

--------------------------------------------------------------------------
-- This routine finds and reads in a cache file.  If it
-- finds a cache file is simply does a "loadfile" on it
-- and updates moduleT and spiderDirT.
-- @param self a Cache object
-- @param spiderTFnA An array of cache files to read and process.
-- @return the number of directories read.
local function readCacheFile(self, spiderTFnA)
   dbg.start{"Cache:readCacheFile(spiderTFnA)"}
   local dirsRead  = 0
   if (masterTbl().ignoreCache or LMOD_IGNORE_CACHE) then
      dbg.print{"LMOD_IGNORE_CACHE is true\n"}
      dbg.fini("Cache:readCacheFile")
      return dirsRead
   end

   declare("spiderT")
   declare("mpathMapT")
   declare("mrcT")
   local mDT        = self.mDT
   local mpathMapT  = self.mpathMapT
   local spiderDirT = self.spiderDirT
   local spiderT    = self.spiderT
   local mrc        = MRC:singleton()

   dbg.print{"#spiderTFnA: ",#spiderTFnA,"\n"}

   for i = 1,#spiderTFnA do
      repeat
         local fileA = spiderTFnA[i].fileA
         local fn    = false
         local found = false
         local attr  = false

         for j = 1,#fileA do
            fn   = fileA[j]
            attr = lfs.attributes(fn) or {}
            if (next(attr) ~= nil and attr.size > 0) then
               found = true
               break
            else
               dbg.print{"Did not find: ",fn,"\n"}
            end
         end

         if (not found) then
            dbg.print{"No cache files found\n"}
            break
         end

         dbg.print{"cacheFile found: ",fn,"\n"}

         -- Check Time

         local diff  = attr.modification - spiderTFnA[i].timestamp
         local valid = diff >= 0
         dbg.print{"valid: ",valid,", timeDiff: ",diff,"\n"}
         if (valid) then

            -- Check for matching default MODULEPATH.
            assert(loadfile(fn))()
            mrc:import(_G.mrcT)

            local G_spiderT = _G.spiderT
            for k, v in pairs(G_spiderT) do
               --dbg.print{"spiderT dir: ", k,", mDT[k]: ",mDT[k],"\n"}
               if ( k:sub(1,1) == '/' ) then
                  local dirTime = mDT[k] or 0
                  if (attr.modification > dirTime) then
                     k             = path_regularize(k)
                     mDT[k]        = attr.modification
                     spiderDirT[k] = true
                     spiderT[k]    = v
                     dirsRead      = dirsRead + 1
                  end
               else
                  spiderT[k] = spiderT[k] or v
               end
            end
            local G_mpathMapT = _G.mpathMapT
            for k, v in pairs(G_mpathMapT) do
               mpathMapT[k] = v
            end
         end
      until true
   end

   dbg.fini("Cache:readCacheFile")
   return dirsRead
end

--------------------------------------------------------------------------
-- This is the client code interface to getting the cache
-- files.  It is also responsible for writing the user cache
-- file if it takes to long to build the cache data.  If the
-- data already exists from previous calls then it just
-- re-used.  If there are any directories that are not known
-- then this function call on Spider:findAllModules() to build
-- the cache data that is not known.
--
-- If the time to rebuild the cache is quick (time < short) then
-- the build time is recorded in the ModuleTable.  That way if
-- it is quick, Lmod will report that it is rebuilding the spider
-- cache the first time but not any other times during a login
-- session.
--
-- There is a hook function "writeCache" that gets called.
-- There may be times when the cache file should never be written.
-- For example, if you have a build machine where packages
-- and modulefiles are being generated at random times then
-- the cache file could be out-of-date.  So instead of trying
-- to rebuild the cache file every second, just do not write it
-- and live with slightly slower response time from Lmod.
--
-- The "fast" option.  Lmod starts up in "fast" mode.
-- This mode means that Lmod will try to read any cache files
-- if it finds none, it doesn't try to build them, instead
-- Lmod will walk only the directories in MODULEPATH and not
-- spider everything.
--
-- @param self a Cache object
-- @param fast if true then only read cache files, do not build them.
function M.build(self, fast)
   dbg.start{"Cache:build(fast=", fast,")"}
   local spiderT   = self.spiderT
   local dbT       = self.dbT
   local mpathMapT = self.mpathMapT
   local spider    = Spider:new()

   dbg.print{"self.buildCache: ",self.buildCache,"\n"}
   if (not self.buildCache) then
      dbg.fini("Cache:build")
      return false, false
   end

   if (next(spiderT) ~= nil) then
      dbg.print{"Using pre-built spiderT!\n"}
      dbg.fini("Cache:build")
      return spiderT, dbT
   end

   local Pairs       = dbg.active() and pairsByKeys or pairs
   local frameStk    = FrameStk:singleton()
   local mt          = frameStk:mt()
   local masterTbl   = masterTbl()
   local T1          = epoch()
   local sysDirsRead = 0
   if (not masterTbl.checkSyntax) then
      sysDirsRead = readCacheFile(self, self.systemDirA)
   end

   ------------------------------------------------------------------------
   -- Read user cache file if it exists and is not out-of-date.

   local spiderDirT  = self.spiderDirT
   local usrDirsRead = 0
   if (not isFile(self.usrCacheInvalidFn))then
      usrDirsRead = readCacheFile(self, self.usrSpiderTFnA)
   end

   local dirA   = {}
   local numMDT = 0
   for k, v in Pairs(spiderDirT) do
      numMDT = numMDT + 1
      if (not v) then
         dbg.print{"rebuilding cache for directory: ",k,"\n"}
         dirA[#dirA+1] = k
      end
   end

   local dirsRead = sysDirsRead + usrDirsRead
   if (dirsRead == 0 and fast and numMDT == #dirA) then
      dbg.print{"Fast and dirsRead: ",dirsRead,"\n"}
      dbg.fini("Cache:build")
      return nil, nil
   end

   local userSpiderTFN = self.usrSpiderTFN
   local buildSpiderT  = (#dirA > 0)
   local userSpiderT   = {}
   dbg.print{"buildSpiderT: ",buildSpiderT,"\n"}

   dbg.print{"mt: ", tostring(mt), "\n",level=2}

   local short     = mt:getShortTime()
   if (not buildSpiderT) then
      ancient = _G.ancient or ancient
      mt:setRebuildTime(ancient, short)
   else
      local prtRbMsg = ((not quiet())                        and
                        (not masterTbl.initial)              and
                        ((not short) or (short > shortTime)) and
                        (not self.quiet)
                       )
      dbg.print{"short:    ", short,  ", shortTime: ", shortTime,"\n", level=2}
      dbg.print{"quiet:    ", quiet(),", initial:   ", masterTbl.initial,"\n"}
      dbg.print{"prtRbMsg: ",prtRbMsg,", quiet:     ",self.quiet,"\n"}

      local cTimer = CTimer:singleton("Rebuilding cache, please wait ...",
                                      Threshold, prtRbMsg, masterTbl.timeout)

      local mcp_old  = mcp
      dbg.print{"Setting mcp to ", mcp:name(),"\n"}
      mcp            = MasterControl.build("spider")

      local t1       = epoch()
      local st, msg  = pcall(Spider.findAllModules, spider, dirA, userSpiderT)
      if (not st) then
         if (msg) then io.stderr:write("Msg: ",msg,'\n') end
         LmodSystemError("Spider searched timed out\n")
      end
      local t2       = epoch()
      mpathMapT      = masterTbl.mpathMapT
      mcp            = mcp_old
      dbg.print{"Setting mcp to ", mcp:name(),"\n"}

      dbg.print{"t2-t1: ",t2-t1, " shortTime: ", shortTime, "\n", level=2}

      local r = {}
      hook.apply("writeCache",r)

      dbg.print{"self.dontWrite: ", self.dontWrite, ", r.dontWriteCache: ",
                r.dontWriteCache, "\n"}

      local dontWrite = self.dontWrite or r.dontWriteCache or LMOD_IGNORE_CACHE

      local doneMsg

      if (t2 - t1 < shortTime or dontWrite) then
         ancient = shortLifeCache

         ------------------------------------------------------------------------
         -- This is a bit of a hack.  Lmod needs to know the time it takes to
         -- build the cache and it needs to store it in the ModuleTable.  The
         -- trouble is with regression testing.  The module table is only written
         -- out when it value changes.  We do not want a new module written out
         -- if the only thing that has changed is the slight variation that it
         -- took to build the cache between Lmod command runs during a regression
         -- test.  So if the previous t2-t1 is also less than shortTime DO NOT
         -- reset short to the new value.

         local newShortTime = t2-t1
         if (short and short < shortTime) then
            newShortTime = short
         end
         mt:setRebuildTime(ancient, newShortTime)
         dbg.print{"mt: ", tostring(mt), "\n", level=2}
         doneMsg = " (not written to file) done"
      else
         local mrc = MRC:singleton()
         mkdir_recursive(self.usrCacheDir)
         local s0 = "-- Date: " .. os.date("%c",os.time()) .. "\n"
         local s1 = "ancient = " .. tostring(math.floor(ancient)) .."\n"
         local s2 = mrc:export()
         local s3 = serializeTbl{name="spiderT",      value=userSpiderT, indent=true}
         local s4 = serializeTbl{name="mpathMapT",    value=mpathMapT,   indent=true}
         os.rename(userSpiderTFN, userSpiderTFN .. "~")
         local f  = io.open(userSpiderTFN,"w")
         if (f) then
            f:write(s0,s1,s2,s3,s4)
            f:close()
         end
         posix.unlink(userSpiderTFN .. "~")
         dbg.print{"Wrote: ",userSpiderTFN,"\n"}
         if (LUAC_PATH ~= "") then
            if (LUAC_PATH:sub(1,1) == "@") then
               LUAC_PATH="luac"
            end
            local ext = ".luac_"..LuaV
            local fn = userSpiderTFN:gsub(".lua$",ext)
            local a  = {}
            a[#a+1]  = LUAC_PATH
            a[#a+1]  = "-o"
            a[#a+1]  = fn
            a[#a+1]  = userSpiderTFN
            lmod_system_execute(concatTbl(a," "))
         end
         if (isFile(self.usrCacheInvalidFn)) then
            dbg.print{"unlinking: ",self.usrCacheInvalidFn,"\n"}
            posix.unlink(self.usrCacheInvalidFn)
         end

         local buildT   = t2-t1
         local ancient2 = math.min(buildT * 120, ancient)

         mt:setRebuildTime(ancient2, buildT)
         dbg.print{"mt: ", tostring(mt), "\n"}
         doneMsg = " (written to file) done."
      end
      cTimer:done(doneMsg)
      dbg.print{"Transfer from userSpiderT to spiderT\n"}
      for k in Pairs(userSpiderT) do
         dbg.print{"k: ",k,"\n"}
         spiderT[k] = userSpiderT[k]
      end
      dbg.print{"Show that these directories have been walked\n"}
      t2 = epoch()
      for i = 1,#dirA do
         local k = dirA[i]
         spiderDirT[k] = t2
      end

   end


   -- With a valid spiderT build dbT if necessary:
   if (next(dbT) == nil or buildSpiderT) then
      spider:buildDbT(mpathMapT, spiderT, dbT)
   end

   -- remove user cache file if old
   if (isFile(userSpiderTFN)) then
      local attr   = lfs.attributes(userSpiderTFN)
      local diff   = os.time() - attr.modification
      if (diff > ancient) then
         posix.unlink(userSpiderTFN);
         dbg.print{"Deleted: ",userSpiderTFN,"\n"}
      end
   end
   local T2 = epoch()
   timer:deltaT("Cache:build", T2 - T1)

   dbg.fini("Cache:build")
   return spiderT, dbT, mpathMapT
end

return M
