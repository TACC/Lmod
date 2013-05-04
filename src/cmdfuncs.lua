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
local hook         = require("Hook")
local posix        = require("posix")

local s_readRC     = false
RCFileA = {
   pathJoin(os.getenv("HOME"),".lmodrc.lua"),
   pathJoin(cmdDir(),"../../etc/.lmodrc.lua"),
   pathJoin(cmdDir(),"../init/.lmodrc.lua"),
   os.getenv("LMOD_RC"),
}

function readRC()
   if (s_readRC) then
      s_readRC = true
      return 
   end

   declare("propT",       false)
   declare("scDescriptT", false)
   local results = {}

   for i = 1,#RCFileA do
      local f  = RCFileA[i]
      local fh = io.open(f)
      if (fh) then
         assert(loadfile(f))()
         fh:close()
         break
      end
   end
   s_propT       = _G.propT         or {}
   s_scDescriptT = _G.scDescriptT   or {}
end

function getPropT()
   return s_propT
end

function getSCDescriptT()
   return s_scDescriptT
end

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

   dbg.fini("Purge")
end

local __expert = false

function expert()
   if (__expert == false) then
      __expert = getenv("LMOD_EXPERT")
   end
   return __expert
end


function extractVersion(full, sn)
   if (full == nil or sn == nil) then
      return nil
   end
   local pat     = '^' .. escape(sn) .. '/?'
   local version = full:gsub(pat,"")
   if (version == "") then
      version = nil
   end
   return version
end

function readAdmin()

   -- If there is anything in [[adminT]] then return because
   -- this routine has already read in the file.
   if (next (adminT)) then return end

   local adminFn = getenv("LMOD_ADMIN_FILE") or pathJoin(cmdDir(),"../../etc/admin.list")
   local f       = io.open(adminFn,"r")

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
   local masterTbl = masterTbl()
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

   if (masterTbl.terse) then
      for i = 1,#activeA do
         local mname = MName:new("mt",activeA[i])
         local sn    = mname:sn()
         local full  = mt:fullName(sn)
         io.stderr:write(full,"\n")
      end
      dbg.fini("List")
      return
   end
         

   io.stderr:write("\n",msg,msg2,"\n")
   local kk = 0
   local legendT = {}
   for i = 1, #activeA do
      local mname = MName:new("mt",activeA[i])
      local sn    = mname:sn()
      local m = mt:fullName(sn)
      for j = 1, #wanted do
         local p = wanted[j]
         if (m:find(p,1,true) or m:find(p)) then
            kk = kk + 1
            a[#a + 1] = mt:list_property(kk, sn, "short", legendT)
         end
      end
   end


   if (kk == 0) then
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
   kk = 0

   for i = 1, #totalA do
      local v = totalA[i]
      dbg.print("inactive check v: ",v.name,"\n")
      if (not mt:have(v.sn,"active")) then
         local name = v.name
         for j = 1, #wanted do
            local p = wanted[j]
            if (name:find(p,1,true) or name:find(p)) then
               kk      = kk + 1
               a[#a+1] = {"  " .. tostring(kk).. ")" , name}
            end
         end
      end
   end

   if (#a > 0) then
      io.stderr:write("\nInactive Modules",msg2,"\n")
      local ct = ColumnTable:new{tbl=a,gap=0}
      io.stderr:write(ct:build_tbl(),"\n")
   end
   dbg.fini("List")
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

function Refresh()
   local dbg = Dbg:dbg()
   dbg.start("Refresh()")
   local mt     = MT:mt()

   local mcp_old = mcp
   mcp           = MasterControl.build("refresh","load")
   local master  = Master:master()

   master:reload()

   mcp = mcp_old
   dbg.print("Resetting mcp to : ",mcp:name(),"\n")
   dbg.fini("Refresh")
end
   
