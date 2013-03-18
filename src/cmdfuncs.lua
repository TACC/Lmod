------------------------------------------------------------------------
-- The command functions
------------------------------------------------------------------------

require("strict")
require("myGlobals")
require("string_trim")
require("escape")
require("TermWidth")
local BeautifulTbl = require('BeautifulTbl')
local ColumnTable  = require('ColumnTable')
local Dbg          = require("Dbg")
local MName        = require("MName")
local Spider       = require("Spider")
local concatTbl    = table.concat
local getenv       = os.getenv
local posix        = require("posix")

function UUIDString(epoch)
   local ymd  = os.date("*t", epoch)

   --                                y    m    d    h    m    s
   local uuid_date = string.format("%d_%02d_%02d_%02d_%02d_%02d", 
                                   ymd.year, ymd.month, ymd.day, 
                                   ymd.hour, ymd.min,   ymd.sec)
   
   local uuid_str  = capture("uuidgen"):sub(1,-2)
   local uuid      = uuid_date .. "-" .. uuid_str

   return uuid
end

function Purge()
   local master = Master:master()
   local mt     = MT:mt()
   local dbg    = Dbg:dbg()

   local totalA  = mt:list("short","any")

   if (#totalA < 1) then
      return
   end

   local a = {}
   for _,v in ipairs(totalA) do
      a[#a + 1] = v
   end
   dbg.start("Purge(",concatTbl(a,", "),")")

   MCP:unload(unpack(a))

   -- Make Default Path be the new MODULEPATH

   mt:buildMpathA(mt:getBaseMPATH())

   dbg.fini()
end

local __expert = false

function expert()
   if (__expert == false) then
      __expert = getenv("LMOD_EXPERT")
   end
   return __expert
end


function extractVersion(full, sn)
   local pat     = '^' .. escape(sn) .. '/?'
   local version = full:gsub(pat,"")
   if (version == "") then
      version = nil
   end
   return version
end


function path_regularize(value)
   if value == nil then return nil end

   value = value:gsub("//+","/")
   value = value:gsub("/%./","/")
   value = value:gsub("/$","")
   return value
end

function readAdmin()

   -- If there is anything in [[adminT]] then return because
   -- this routine has already read in the file.
   if (next (adminT)) then return end

   local adminFn = getenv("LMOD_ADMIN_FILE") or pathJoin(cmdDir(),"../../etc/admin.list")
   local f       = io.open(adminFn)

   -- Put something in adminT so that this routine will not be
   -- run again even if the file does not exist.
   adminT["foo"] = "bar"

   if (f) then
      local whole = f:read("*all") .. "\n"
      f:close()


      -- Parse file: ignore "#" comment lines and blank lines
      -- Split lines on ":" module:message

      local state = "init"
      local key   = "unknown"
      local value = nil
      local a     = {}

      for v in whole:split("\n") do

         if (v:sub(1,1) == "#") then
            -- ignore this comment line


         elseif (v:find("^%s*$")) then
            if (state == "value") then
               value       = concatTbl(a, " ")
               a           = {}
               adminT[key] = value
               state       = "init"
            end

            -- Ignore blank lines
         elseif (state == "value") then
            a[#a+1]     = v:trim()
         else
            local i     = v:find(":")
            if (i) then
               key      = v:sub(1,i-1):trim()
               local  s = v:sub(i+1):trim()
               if (s:len() > 0) then
                  a[#a+1]  = s
               end
               state    = "value"
            end
         end
      end
   end
end


function prtErr(...)
   io.stderr:write(...)
end

function length(s)
   s = s:gsub("\027[^m]+m","")
   return s:len()
end

function List(...)
   local dbg    = Dbg:dbg()
   dbg.start("List(...)")
   local mt = MT:mt()

   local totalA = mt:list("userName","any")
   if (#totalA < 1) then
      local dbg = Dbg:dbg()
      LmodWarning("No modules installed\n")
      return
   end

   local wanted = {}
   for i,v in ipairs{...} do
      wanted[i] = v
   end


   local msg     = "Currently Loaded Modules"
   local activeA = mt:list("short","active")
   local a       = {}
   local msg2    = ":"

   if (#wanted == 0) then
      wanted[1] = ".*"
   else
      msg2 = " Matching: " .. table.concat(wanted," or ")
   end

   io.stderr:write("\n",msg,msg2,"\n")
   local k = 0
   local legendT = {}
   for i = 1, #activeA do
      local mname = MName:new("mt",activeA[i])
      local sn    = mname:sn()
      local m = mt:fullName(sn)
      for j = 1, #wanted do
         local p = wanted[j]
         if (m:find(p,1,true) or m:find(p)) then
            k = k + 1
            a[#a + 1] = mt:list_property(k, sn, "short", legendT)
         end
      end
   end

   if (k == 0) then
      io.stderr:write("  None found.\n")
   else
      local ct = ColumnTable:new{tbl=a, gap=0, len=length}
      io.stderr:write(ct:build_tbl(),"\n")
   end

   if (next(legendT)) then
      local term_width = TermWidth()
      io.stderr:write("\n  Where:\n")
      a = {}
      for k, v in pairsByKeys(legendT) do
         a[#a+1] = { "   " .. k ..":", v}
      end
      local bt = BeautifulTbl:new{tbl=a, column = term_width-1}
      io.stderr:write(bt:build_tbl(),"\n")
   end
   a = {}
   k = 0

   local k = 0
   for i = 1, #totalA do
      local v = totalA[i]
      dbg.print("inactive check v: ",v.name,"\n")
      if (not mt:have(v.sn,"active")) then
         local name = v.name
         for j = 1, #wanted do
            local p = wanted[j]
            if (name:find(p,1,true) or name:find(p)) then
               k       = k + 1
               a[#a+1] = {"  " .. tostring(k).. ")" , name}
            end
         end
      end
   end

   if (#a > 0) then
      io.stderr:write("\nInactive Modules",msg2,"\n")
      local ct = ColumnTable:new{tbl=a,gap=0}
      io.stderr:write(ct:build_tbl(),"\n")
   end
   dbg.fini()
end

function activateWarning()
   s_haveWarnings = true
end

function deactivateWarning()
   s_haveWarnings = false
end

function haveWarnings()
   return s_haveWarnings
end

function setWarningFlag()
   s_warning = true
end
function getWarningFlag()
   return s_warning
end

function epoch()
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

function readCacheFile(cacheType, cacheFileA, moduleDirT, moduleT)

   local dbg        = Dbg:dbg()
   dbg.start("readCacheFile(cacheType, cacheFileA, moduleDirT, moduleT)")
   local mt         = MT:mt()
   ancient = mt:getRebuildTime() or ancient

   local lastUpdateEpoch = epoch() - ancient
   local attr = lfs.attributes(updateSystemFn)
   if (attr and cacheType == "system") then
      lastUpdateEpoch = attr.modification
   end

   local dirsRead = 0

   for i = 1,#cacheFileA do
      local f = cacheFileA[i].file

      if (not isFile(f)) then
         dbg.print("non-existant cacheFile: ",f,"\n")
      else
         dbg.print("cacheFile found: ",f,"\n")
         attr   = lfs.attributes(f)

         -- Check Time

         local diff         = attr.modification - lastUpdateEpoch
         local buildModuleT = diff < 0  -- rebuild when older than lastUpdateEpoch
         dbg.print("timeDiff: ",diff," buildModuleT: ", tostring(buildModuleT),"\n")

         if (not buildModuleT) then
         
            -- Check for matching default MODULEPATH.
            assert(loadfile(f))()
            
            rawget(_G,"moduleT")

            if (not rawget(_G,"moduleT") or _G.moduleT.version == nil ) then
               dbg.print("Ignoring old style cache file!\n")
            else
               for k, v in pairs(_G.moduleT) do
                  if ( k:sub(1,1) == '/' ) then
                     local dirTime = moduleDirT[k] or -1
                     dbg.print("processing directory: ",k," with dirTime: ",dirTime,"\n")
                     if (attr.modification > dirTime) then
                        dbg.print("saving directory: ",k,"\n")
                        moduleDirT[k] = attr.modification
                        moduleT[k]    = v
                        dirsRead      = dirsRead + 1
                     end
                  else
                     moduleT[k] = v
                  end
               end
            end
         end

         break
      end
   end
   dbg.fini()
   return dirsRead
end

s_moduleDirT = {}
s_moduleT    = {}

function getModuleT(fast)

   local dbg        = Dbg:dbg()
   local mt         = MT:mt()
   local HOME       = os.getenv("HOME") or ""
   local cacheDir   = pathJoin(HOME,".lmod.d",".cache")
   local masterTbl  = masterTbl()
   local sysCacheFileA = {
      { file = pathJoin(sysCacheDir,"moduleT.lua"),     fileT = "system"},
      { file = pathJoin(sysCacheDir,"moduleT.old.lua"), fileT = "system"},
   }
   local usrCacheFileA = {
      { file = pathJoin(cacheDir,   "moduleT.lua"),     fileT = "your"  },
   }
   local userModuleTFN = pathJoin(cacheDir,"moduleT.lua")

   dbg.start("getModuleT(fast=", tostring(fast),")")


   local baseMpath = mt:getBaseMPATH()
   if (baseMpath == nil) then
     LmodError("The Env Variable: \"", DfltModPath, "\" is not set\n")
   end

   ---------------------------------------------------------------------------
   -- Since this function can get called many time, we need to only recompute
   -- Directories we have not yet seen

   for path in baseMpath:split(":") do
      s_moduleDirT[path] = s_moduleDirT[path] or -1
   end

   local buildModuleT = true
   local moduleTFN    = nil

   -----------------------------------------------------------------------------
   -- Read system cache file if it exists and is not out-of-date.

   local sysDirsRead = 0
   if (not masterTbl.checkSyntax) then
      sysDirsRead = readCacheFile("system", sysCacheFileA, s_moduleDirT, s_moduleT)
   end
   
   ------------------------------------------------------------------------
   -- Read user cache file if it exists and is not out-of-date.

   local usrDirsRead = readCacheFile("user", usrCacheFileA, s_moduleDirT, s_moduleT)
   
   ------------------------------------------------------------------------
   -- Find all the directories not read in yet.

   local moduleDirA = {}
   for k,v in pairs(s_moduleDirT) do
      if (v < 0) then
         dbg.print("rebuilding cache for directory: ",k,"\n")
         moduleDirA[#moduleDirA+1] = k
      end
   end

   local buildModuleT = (#moduleDirA > 0)
   local userModuleT  = {}
   local dirsRead     = sysDirsRead + usrDirsRead

   dbg.print("buildModuleT: ",tostring(buildModuleT),"\n")

   ------------------------------------------------------------
   -- Do not build cache if fast is required and no cache files
   -- have been found.
   
   if (dirsRead == 0 and fast) then
      dbg.fini()
      return nil
   end


   if (buildModuleT) then
      local errRtn  = LmodError
      local message = LmodMessage
      LmodError     = dbg.quiet
      LmodMessage   = dbg.quiet
      local short   = mt:getShortTime()
      local prtRbMsg = ((not masterTbl.expert) and (not masterTbl.initial) and
                        ((not short) or (short > shortTime)))
      dbg.print("short: ", tostring(short), " shortTime: ", tostring(shortTime),"\n")

      if (prtRbMsg) then
         io.stderr:write("Rebuilding cache file, please wait ...")
      end

      local t1 = epoch()
      Spider.findAllModules(moduleDirA, userModuleT)
      local t2 = epoch()
      if (prtRbMsg) then
         io.stderr:write(" done.\n\n")
      end
      LmodError    = errRtn
      LmodMessage  = message
      dbg.print("t2-t1: ",t2-t1, " shortTime: ", shortTime, "\n")

      if (t2 - t1 < shortTime) then
         ancient = shortLifeCache
         mt:setRebuildTime(ancient, t2-t1)
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
         local ancient2 = math.min(buildT * 3600, ancient)

         mt:setRebuildTime(ancient2, buildT)
      end
      for k, v in pairs(userModuleT) do
         s_moduleT[k] = userModuleT[k]
      end

   else
      ancient = _G.ancient or ancient
      mt:setRebuildTime(ancient, false)
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

   dbg.fini()
   return s_moduleT
end
