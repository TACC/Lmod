--------------------------------------------------------------------------
-- Lmod License
--------------------------------------------------------------------------
--
--  Lmod is licensed under the terms of the MIT license reproduced below.
--  This means that Lua is free software and can be used for both academic
--  and commercial purposes at absolutely no cost.
--
--  ----------------------------------------------------------------------
--
--  Copyright (C) 2008-2013 Robert McLay
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

require("strict")
require("myGlobals")
require("string_trim")
require("fileOps")
require("cmdfuncs")
require("utils")
--------------------------------------------------------------------------
-- Cache: This class reads all the cache files in.  It will on occasion
--        write a user cache file.  This is a singleton class.  
--
-- Rules: The rules about when to trust a cache file or not also when to
--        write a cache file out in the user directory.
--
------------------------------------------------------------------------
-->   0)  Cache files are trusted to know what module files are in the
-->       MODULEPATH.  This means that if one adds a modulefile WITHOUT
-->       updating the cache, LMOD DOES NOT KNOW ABOUT IT!!!.  This is
-->       not a bug but a feature.
------------------------------------------------------------------------
--
--    1)  A cache file can have a system timestamp associated with it.
--        If it does then as long as the cache file is the same or newer
--        then the timestamp then it is good forever.
--    2)  A cache file without a timestamp is considered good for no more
--        than "ancient" seconds old.  It is whatever was configured with
--        Lmod. Typically "ancient" is 86400 seconds or 24 hours.
--    3)  Modulefiles under system control can (should?) have a timestamp
--        associated with but personal modulefiles typically do not.
--    4)  Any PATH in MODULEPATH that are not covered by any modulefiles
--        are walked.  If the time associated with building the cache file
--        is short then no user cache file is written. Short is typically
--        10 seconds and it is set at configure time.



local CTimer  = require("CTimer")
local dbg     = require("Dbg"):dbg()
local M       = {}
local MT      = require("MT")
local Spider  = require("Spider")
local hook    = require("Hook")
local lfs     = require("lfs")
local posix   = require("posix")
local s_cache = false
local timer   = require("Timer"):timer()

--------------------------------------------------------------------------
-- new(): This singleton construct reads the scDescriptT table that can be
--        defined in the .lmodrc.lua.  Typically this table, if it exists
--        by the configure script.  If it does not then scDescriptT will
--        be an array with zero entries.  This ctor finds all the system 
--        and user directories where cache files are stored.  It also
--        figure out the timestamps.

local function new(self, t)
   local o = {}
   setmetatable(o,self)
   self.__index = self

   dbg.start("Cache:new()")

   scDescriptT = getSCDescriptT()

   local scDirA = {}

   local systemEpoch = epoch() - ancient

   dbg.print("#scDescriptT: ",#scDescriptT, "\n")
   for j  = 1, #scDescriptT  do
      local entry = scDescriptT[j]
      local t     = {}
      if (entry.timestamp) then
         hook.apply("parse_updateFn", entry.timestamp, t)
      end

      local lastUpdate = t.lastUpdateEpoch or systemEpoch

      local a = {}
      if (t.hostType and t.hostType ~= "") then
         a[#a+1] = t.hostType
      end
      a[#a+1] = ""
      for i = 1,#a do
         local dir  = pathJoin(entry.dir ,a[i])
         local attr = lfs.attributes(dir) or {}
         if (attr.mode == "directory") then
            dbg.print("Adding: dir: ",dir,", timestamp: ",lastUpdate, "\n")
            scDirA[#scDirA+1] =
               { file   = pathJoin(dir, "moduleT.lua"),     fileT = "system",
                 backup = pathJoin(dir, "moduleT.old.lua"),
                 timestamp = lastUpdate,
               }
            break
         end
      end
   end

   local usrCacheDirA = {
      { file = pathJoin(usrCacheDir, "moduleT.lua"), fileT = "your",
        timestamp = systemEpoch
      }
   }

   t              = t or {}
   o.moduleDirT   = {}
   o.usrCacheDir  = usrCacheDir
   o.usrCacheDirA = usrCacheDirA
   o.usrModuleTFN = pathJoin(usrCacheDir,"moduleT.lua")
   o.systemDirA   = scDirA
   o.dontWrite    = t.dontWrite or false
   o.quiet        = t.quiet     or false

   o.moduleT      = {}
   o.moduleDirA   = {}
   dbg.fini("Cache.new")
   return o
end

--------------------------------------------------------------------------
-- Cache:cache(): This is the front-end to the singleton ctor.  It
--                (obviously) constructs the static s_cache var once
--                then serves s_cache to subsequent callers.  Since
--                the MODULEPATH can change during execution, we set
--                moduleDirT[path] to -1 for any we have not already
--                processed.

function M.cache(self, t)
   dbg.start("Cache:cache()")
   if (not s_cache) then
      s_cache   = new(self, t)
   end

   s_cache.quiet    = (t or {}).quiet or s_cache.quiet

   local mt        = MT:mt()
   local baseMpath = mt:getBaseMPATH()
   if (baseMpath == nil) then
     LmodError("The Env Variable: \"", DfltModPath, "\" is not set.\n")
   end

   -- Since this function can get called many time, we need to only recompute
   -- Directories we have not yet seen

   local moduleDirT = s_cache.moduleDirT
   for path in baseMpath:split(":") do
      local attr = lfs.attributes(path) or {}
      if (attr.mode == "directory") then
         moduleDirT[path] = moduleDirT[path] or -1
         dbg.print("moduleDirT[",path,"]: ",moduleDirT[path], "\n")
      end
   end

   dbg.fini("Cache:cache")
   return s_cache
end

--------------------------------------------------------------------------
-- readCacheFile(): This routine finds and reads in a cache file.  If it
--                  finds a cache file is simply does a "loadfile" on it
--                  and updates moduleT and moduleDirT.

local function readCacheFile(self, cacheFileA)

   dbg.start("Cache:readCacheFile(cacheFileA)")
   local mt         = MT:mt()

   local dirsRead = 0

   local moduleDirT = self.moduleDirT
   local moduleDirA = self.moduleDirA
   local moduleT    = self.moduleT

   dbg.print("#cacheFileA: ",#cacheFileA,"\n")
   for i = 1,#cacheFileA do
      local f     = cacheFileA[i].file
      local found = false

      local attr = lfs.attributes(f) or {}
      if (next(attr) ~= nil and attr.size > 0) then
         found = true
      elseif (cacheFileA[i].backup) then
         f     = cacheFileA[i].backup
         attr  = lfs.attributes(f) or {}
         found = (next(attr) ~= nil and attr.size > 0)
      end

      if (not found) then
         dbg.print("Did not find: ",f,"\n")
      else
         dbg.print("cacheFile found: ",f,"\n")

         -- Check Time

         local diff         = attr.modification - cacheFileA[i].timestamp
         dbg.print("timeDiff: ",diff,"\n")

         -- Read in cache file if not out of date.
         if (diff >= 0) then

            -- Check for matching default MODULEPATH.
            assert(loadfile(f))()

            local version = (rawget(_G,"moduleT") or {}).version or 0

            dbg.print("version: ",version,"\n")
            if (version < Cversion) then
               dbg.print("Ignoring old style cache file!\n")
            else
               local G_moduleT = _G.moduleT
               for k, v in pairs(G_moduleT) do
                  if ( k:sub(1,1) == '/' ) then
                     local dirTime = moduleDirT[k] or 0
                     if (moduleDirT[k] and attr.modification > dirTime) then
                        k             = path_regularize(k)
                        dbg.print("saving directory: ",k," from cache file: ",f,"\n")
                        moduleDirT[k] = attr.modification
                        moduleT[k]    = v
                        dirsRead      = dirsRead + 1
                     end
                  else
                     moduleT[k] = moduleT[k] or v
                  end
               end
            end
         end
      end
   end

   dbg.fini("Cache:readCacheFile")
   return dirsRead
end

--------------------------------------------------------------------------
-- Cache:build(): This is the client code interface to getting the cache
--                files.  It is also responsible for writing the user cache
--                file if it takes to long to build the cache data.  If the
--                data already exists from previous calls then it just
--                re-used.  If there are any directories that are not known
--                then this function call on Spider:findAllModules() to build
--                the cache data that is not known.
--
--                If the time to rebuild the cache is quick (time < short) then
--                the build time is recorded in the ModuleTable.  That way if
--                it is quick, Lmod will report that it is rebuilding the spider
--                cache the first time but not any other times during a login
--                session.
--
--                There is a hook function "writeCache" that gets called.
--                There may be times when the cache file should never be written.
--                For example, if you have a build machine where packages
--                and modulefiles are being generated at random times then
--                the cache file could be out-of-date.  So instead of trying
--                to rebuild the cache file every second, just do not write it
--                and live with slightly slower response time from Lmod.

--                The "fast" option.  Lmod starts up in "fast" mode.
--                This mode means that Lmod will try to read any cache files
--                if it finds none, it doesn't try to build them, instead
--                Lmod will walk only the directories in MODULEPATH and not
--                spider everything.


function M.build(self, fast)
   local mt = MT:mt()

   dbg.start("Cache:build(fast=", fast,")")
   local masterTbl = masterTbl()

   if (masterTbl.ignoreCache or LMOD_IGNORE_CACHE) then
      dbg.print("LMOD_IGNORE_CACHE is true\n")
      dbg.fini("Cache:build")
      return nil
   end

   local T1 = epoch()
   local sysDirsRead = 0
   if (not masterTbl.checkSyntax) then
      sysDirsRead = readCacheFile(self, self.systemDirA)
   end

   ------------------------------------------------------------------------
   -- Read user cache file if it exists and is not out-of-date.

   local moduleDirT  = self.moduleDirT
   local usrDirsRead = readCacheFile(self, self.usrCacheDirA)

   local dirA   = {}
   local numMDT = 0
   for k, v in pairs(moduleDirT) do
      numMDT = numMDT + 1
      if (v <= 0) then
         dbg.print("rebuilding cache for directory: ",k,"\n")
         dirA[#dirA+1] = k
      end
   end

   local dirsRead = sysDirsRead + usrDirsRead
   if (dirsRead == 0 and fast and numMDT == #dirA) then
      dbg.print("Fast and dirsRead: ",dirsRead,"\n")
      dbg.fini("Cache:build")
      return nil
   end

   local userModuleTFN = self.usrModuleTFN
   local buildModuleT  = (#dirA > 0)
   local userModuleT   = {}
   local moduleT       = self.moduleT
   dbg.print("buildModuleT: ",buildModuleT,"\n")

   dbg.print("mt: ", tostring(mt), "\n")

   local short    = mt:getShortTime()
   if (not buildModuleT) then
      ancient = _G.ancient or ancient
      mt:setRebuildTime(ancient, short)
   else
      local prtRbMsg = ( (not masterTbl.expert)               and
                         (not masterTbl.initial)              and
                         ((not short) or (short > shortTime)) and
                         (not self.quiet)
      )
      dbg.print("short: ", short, " shortTime: ", shortTime,"\n")

      local cTimer = CTimer:cTimer("Rebuilding cache, please wait ...",
                                   Threshold, prtRbMsg)

      local mcp_old = mcp
      mcp           = MasterControl.build("spider")

      local t1 = epoch()
      Spider.findAllModules(dirA, userModuleT)
      local t2 = epoch()

      mcp           = mcp_old
      dbg.print("Resetting mpc to ", mcp:name(),"\n")

      dbg.print("t2-t1: ",t2-t1, " shortTime: ", shortTime, "\n")

      local r = {}
      hook.apply("writeCache",r)

      dbg.print("self.dontWrite: ", self.dontWrite, ", r.dontWriteCache: ",
                r.dontWriteCache, "\n")

      local dontWrite = self.dontWrite or r.dontWriteCache

      local doneMsg = " done."

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
         dbg.print("mt: ", tostring(mt), "\n")
         doneMsg = " (not written to file) done"
      else
         mkdir_recursive(self.usrCacheDir)
         local s0 = "-- Date: " .. os.date("%c",os.time()) .. "\n"
         local s1 = "ancient = " .. tostring(math.floor(ancient)) .."\n"
         local s2 = serializeTbl{name="moduleT",      value=userModuleT,
                                 indent=true}
         local f  = io.open(userModuleTFN,"w")
         if (f) then
            f:write(s0,s1,s2)
            f:close()
         end
         dbg.print("Wrote: ",userModuleTFN,"\n")
         local buildT   = t2-t1
         local ancient2 = math.min(buildT * 120, ancient)

         mt:setRebuildTime(ancient2, buildT)
         dbg.print("mt: ", tostring(mt), "\n")
         doneMsg = " (written to file) done."
      end
      cTimer:done(doneMsg)
      dbg.print("Transfer from userModuleT to moduleT\n")
      for k, v in pairs(userModuleT) do
         dbg.print("k: ",k,"\n")
         moduleT[k] = userModuleT[k]
      end
      dbg.print("Show that these directories have been walked\n")
      t2 = epoch()
      for i = 1,#dirA do
         local k = dirA[i]
         moduleDirT[k] = t2
      end
   end

   -- remove user cache file if old
   if (isFile(userModuleTFN)) then
      local attr   = lfs.attributes(userModuleTFN)
      local diff   = os.time() - attr.modification
      if (diff > ancient) then
         posix.unlink(userModuleTFN);
         dbg.print("Deleted: ",userModuleTFN,"\n")
      end
   end
   local T2 = epoch()
   timer:deltaT("Cache:build", T2 - T1)
   mt:clearLocationAvailT()

   dbg.fini("Cache:build")
   return moduleT
end

return M
