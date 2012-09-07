------------------------------------------------------------------------
-- The command functions
------------------------------------------------------------------------

require("strict")
require("myGlobals")
require("string_trim")
require("TermWidth")
local BeautifulTbl = require('BeautifulTbl')
local ColumnTable  = require('ColumnTable')
local Dbg          = require("Dbg")
local concatTbl    = table.concat
local getenv       = os.getenv

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
   dbg.fini()
end

local __expert = false

function expert()
   if (__expert == false) then
      __expert = getenv("LMOD_EXPERT")
   end
   return __expert
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

function length(self)
   local i,j = self:find("\027[^m]+m")
   if (i == nil) then
      local r = self:len()
      return r
   end
   local k   = self:find("\027[^m]+m",j+1)
   local r   = k - j - 1
   return  r
end

function List(...)
   local dbg    = Dbg:dbg()
   dbg.start("List(...)")
   local mt = MT:mt()

   local propT = readRC()

   local totalA = mt:list("short","any")
   if (#totalA < 1) then
      local dbg = Dbg:dbg()
      dbg.warning("No modules installed\n")
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

   io.stderr:write(msg,msg2,"\n")
   local k = 0
   local legendT = {}
   for i = 1, #activeA do
      local m = mt:fullName(activeA[i])
      for j = 1, #wanted do
         local p = wanted[j]
         if (m:find(p,1,true) or m:find(p)) then
            k = k + 1
            a[#a + 1] = mt:list_property(k, m, "short", legendT)
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
      if (not mt:have(v,"active")) then
         local m = mt:fullName(v)
         for j = 1, #wanted do
            local p = wanted[j]
            if (m:find(p,1,true) or m:find(p)) then
               k       = k + 1
               a[#a+1] = {"  " .. tostring(k).. ")" , m}
            end
         end
      end
   end

   if (#a > 0) then
      io.stderr:write("Inactive Modules",msg2,"\n")
      local ct = ColumnTable:new{tbl=a,gap=0}
      io.stderr:write(ct:build_tbl(),"\n")
   end
   dbg.fini()
end
