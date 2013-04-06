require("strict")
require("myGlobals")
require("string_trim")
require("fileOps")

local Dbg     = require("Dbg")
local M       = {}
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

local function new(self)
   local o = {}
   setmetatable(o,self)
   self.__index = self

   scDescriptT = getSCDescriptT()
   
   local scDirA = {}

   local systemEpoch = epoch() - ancient

   for j  = 1, #scDescriptT  do
      local entry = scDescriptT[j]
      hook.apply("parse_updateFn", entry.timestamp, t)

      local lastUpdate = t.lastUpdateEpoch or systemEpoch

      local a = {}
      if (t.hostType) then
         a[#a+1] = t.hostType
      end
      a[#a+1] = ""
      for i = 1,#a do
         local dir  = pathJoin(entry.dir ,a[i])
         local attr = lfs.attributes(entry.dir)
         if (attr and type(attr) == table and attr.mode == "directory") then
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
   o.systemDirA   = sdDirA

   o.moduleT      = {}
   o.moduleDirA   = {}
   return o
end

function M.cache(self)
   if (not s_cache) then
      s_cache   = new(self)
   end
   return s_cache
end

function M._readCacheFile(self, cacheFileA)

   local dbg        = Dbg:dbg()
   dbg.start("Cache:_readCacheFile(cacheFileA)")
   local mt         = MT:mt()

   local dirsRead = 0

   for i = 1,#cacheFileA do
      local f = cacheFileA[i].file

      if (not isFile(f)) then
         dbg.print("non-existant cacheFile: ",f,"\n")
      else
         dbg.print("cacheFile found: ",f,"\n")
         local attr   = lfs.attributes(f)

         -- Check Time

         local diff         = attr.modification - cacheFileA.timestamp
         local buildModuleT = diff < 0  -- rebuild when older than timestamp
         dbg.print("timeDiff: ",diff," buildModuleT: ", tostring(buildModuleT),"\n")

         if (not buildModuleT) then
         
            -- Check for matching default MODULEPATH.
            assert(loadfile(f))()
            
            local version = (rawget(_G,"moduleT") or {}).version or 0

            dbg.print("version: ",tostring(version),"\n")
            if (version < Cversion) then
               dbg.print("Ignoring old style cache file!\n")
            else
               for k, v in pairs(_G.moduleT) do
                  if ( k:sub(1,1) == '/' ) then
                     local dirTime = moduleDirT[k] or -1
                     if (attr.modification > dirTime) then
                        dbg.print("saving directory: ",k," from cache file: f\n")
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
   dbg.fini("readCacheFile")
   return dirsRead
end

function M.build(self, fast)
   local dbg = Dbg:dbg()
   local mt = MT:mt()
   
   dbg.start("Cache:build(fast=", fast,")")


   dbg.fini()

end

return M
