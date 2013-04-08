require("strict")
require("myGlobals")
require("string_trim")
require("fileOps")

local Dbg     = require("Dbg")
local M       = {}
local MT      = require("MT")
local Spider  = require("Spider")
local hook    = require("Hook")
local lfs     = require("lfs")
local s_cache = false

local function epoch()
   if (posix.gettimeofday) then
      local t1, t2 = posix.gettimeofday()
      if (t2 == nil) then
         return t1.sec + t1.usec*1.0e-6
      else
         return t1 + t2*1.0e-6
      end
   else
      return os.time()
   end
end

local function new(self, dontWrite)
   local o = {}
   setmetatable(o,self)
   self.__index = self

   local dbg = Dbg:dbg()
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
               { file = pathJoin(dir, "moduleT.lua"),     fileT = "system",
                 timestamp = lastUpdate}
            scDirA[#scDirA+1] =
               { file = pathJoin(dir, "moduleT.old.lua"), fileT = "system",
                 timestamp = lastUpdate}
         end
      end
   end

   local usrCacheDir  = pathJoin(os.getenv("HOME"), ".lmod.d/.cache")
   local usrCacheDirA = {
      { file = pathJoin(usrCacheDir, "moduleT.lua"), fileT = "your",
        timestamp = systemEpoch
      }
   }
   local mt        = MT:mt()
   local baseMpath = mt:getBaseMPATH()
   if (baseMpath == nil) then
     LmodError("The Env Variable: \"", DfltModPath, "\" is not set\n")
   end

   -- Since this function can get called many time, we need to only recompute
   -- Directories we have not yet seen

   local moduleDirT   = {}
   for path in baseMpath:split(":") do
      moduleDirT[path] = -1
   end

   o.moduleDirT   = moduleDirT
   o.usrCacheDirA = usrCacheDirA 
   o.usrModuleTFN = pathJoin(usrCacheDir,"moduleT.lua")
   o.systemDirA   = scDirA
   o.dontWrite    = dontWrite or false

   o.moduleT      = {}
   o.moduleDirA   = {}
   dbg.fini("Cache.new")
   return o
end

function M.cache(self)
   if (not s_cache) then
      s_cache   = new(self)
   end
   return s_cache
end

local function readCacheFile(self, cacheFileA)

   local dbg        = Dbg:dbg()
   dbg.start("Cache:readCacheFile(cacheFileA)")
   local mt         = MT:mt()

   local dirsRead = 0

   local moduleDirT = self.moduleDirT
   local moduleDirA = self.moduleDirA
   local moduleT    = self.moduleT

   dbg.print("#cacheFileA: ",#cacheFileA,"\n")
   for i = 1,#cacheFileA do
      local f    = cacheFileA[i].file
      local attr = lfs.attributes(f) or {}
      
      if (next(attr) == nil or attr.size == 0) then
         dbg.print("cache file does not exist: ",f,"\n")
      else
         dbg.print("cacheFile found: ",f,"\n")

         -- Check Time

         local diff         = attr.modification - cacheFileA[i].timestamp
         local buildModuleT = diff < 0  -- rebuild when older than timestamp
         dbg.print("timeDiff: ",diff," buildModuleT: ", buildModuleT,"\n")

         if (not buildModuleT) then
            
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
                     local dirTime = moduleDirT[k]
                     if (attr.modification > dirTime) then
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

function M.build(self, fast)
   local dbg = Dbg:dbg()
   local mt = MT:mt()
   
   dbg.start("Cache:build(fast=", fast,")")
   local masterTbl = masterTbl()

   local sysDirsRead = 0
   if (not masterTbl.checkSyntax) then
      sysDirsRead = readCacheFile(self, self.systemDirA)
   end

   ------------------------------------------------------------------------
   -- Read user cache file if it exists and is not out-of-date.

   local usrDirsRead = readCacheFile(self, self.usrCacheDirA)

   local dirA = {}
   for k,v in pairs(self.moduleDirT) do
      if (v < 0) then
         dbg.print("rebuilding cache for directory: ",k,"\n")
         dirA[#dirA+1] = k
      end
   end
   
   local dirsRead = sysDirsRead + usrDirsRead
   if (dirsRead == 0 and fast) then
      dbg.fini("Cache:build")
      return nil
   end

   local userModuleTFN = self.usrModuleTFN
   local buildModuleT  = (#dirA > 0)
   local userModuleT   = {}
   local moduleT       = self.moduleT
   dbg.print("buildModuleT: ",buildModuleT,"\n")

   
   if (not buildModuleT) then
      ancient = _G.ancient or ancient
      mt:setRebuildTime(ancient, false)
   else
      local short    = mt:getShortTime()
      local prtRbMsg = ((not masterTbl.expert) and (not masterTbl.initial) and
                        ((not short) or (short > shortTime)))
      dbg.print("short: ", short, " shortTime: ", shortTime,"\n")
      
      if (prtRbMsg) then
         io.stderr:write("Rebuilding cache file, please wait ...")
      end
      
      local mcp_old = mcp
      mcp           = MasterControl.build("spider")
      dbg.print("Setting mpc to ", mcp:name(),"\n")
      
      local t1 = epoch()
      Spider.findAllModules(dirA, userModuleT)
      local t2 = epoch()
      
      mcp           = mcp_old
      dbg.print("Resetting mpc to ", mcp:name(),"\n")

      if (prtRbMsg) then
         io.stderr:write(" done.\n\n")
      end
      dbg.print("t2-t1: ",t2-t1, " shortTime: ", shortTime, "\n")
   
      local r = {}
      hook.apply("writeCache",r)
   
      local dontWrite = self.dontWrite or r.dontWriteCache
   
      if (t2 - t1 < shortTime or dontWrite) then
         ancient = shortLifeCache

         ------------------------------------------------------------------------
         -- This is a bit of a hack.  Lmod needs to know the time it takes to
         -- build the cache and it needs to store it in the ModuleTable.  The
         -- trouble is with regression testing.  The module table is only written
         -- out when it value changes.  We do not want a new module written out
         -- if the only thing that has changed is the slight variation that it
         -- took to build the cache between Lmod command runs during a regression
         -- test.  So if the old time is with-in a factor of 2 old time then
         -- keep the old time.
         
         local newShortTime = t2-t1
         if (short and 2*short > newShortTime) then
            newShortTime = short
         end
         mt:setRebuildTime(ancient, newShortTime)
      else
         mkdir_recursive(cacheDir)
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
      end
      dbg.print("Transfer from userModuleT to moduleT\n")
      for k, v in pairs(userModuleT) do
         dbg.print("k: ",k,"\n")
         moduleT[k] = userModuleT[k]
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
   dbg.fini("Cache:build")
   return moduleT
end

return M
