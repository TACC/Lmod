#!@path_to_lua@/lua
-- -*- lua -*-

--------------------------------------------------------------------------
-- Fixme
-- @script processModuleUsage

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

package.path =  cmd_dir .. "../tools/?.lua;"  ..
                cmd_dir .. "../shells/?.lua;" ..
                cmd_dir .. "?.lua;"           ..
                sys_lua_path
package.cpath = sys_lua_cpath

function cmdDir()
   return cmd_dir
end

function LmodError()
end
function LmodMessage()
end

require("strict")
require("utils")
local Spider = require("Spider")
local Optiks = require("Optiks")
local dbg    = require("Dbg"):dbg()

min = math.min
max = math.max

blacklistT = { build = 1, hpctest1 = 1, hpctest2 = 1, bbarth   = 1, root  = 1, minyard = 1,
               karl  = 1, jtemple  = 1, sgeadmin = 1, eijkhout = 1, david = 1, mclay   = 1,
               cazes = 1, bdkim    = 1, dcarver  = 1, dooley   = 1, yye00 = 1, kelly   = 1,
}

dateT = {"year", "month", "day", "hour", "minute", "second"}

function convert_time_2_epoch(s)
   if (s:sub(1,3) == "now") then return os.time() end
   local t = {}
   local i = 0
   for v in s:split("_") do
      i = i + 1
      t[dateT[i]] = tonumber(v)
   end
   return os.time(t)
end

function pairsByValueKey(t)
   local a = {}
   for k,v in pairs(t) do
      a[#a + 1] = { name = k, value = v }
   end
   table.sort(a, function(x,y)
                    if (x.value == y.value) then
                       return x.name  < y.name
                    else
                       return x.value > y.value
                    end
                 end
           )
   local i = 0  -- iterator variable
   local iter = function ()
                   i = i + 1
                   if (a[i] == nil) then return nil
                   else return a[i].name, a[i].value
                   end
                end
   return iter
end




function main()

   options()
   local masterTbl  = masterTbl()
   local pargs      = masterTbl.pargs
   local moduleD    = {}
   local moduleDirA = {}
   local f, whole

   if (masterTbl.debug) then
      dbg:activateDebug(1)
   end

   dbg.start{"main()"}

   ------------------------------------------------------------
   -- Read list of module files from input argument
   -- Or spider the module file directories.
   if (masterTbl.mlist) then
      f = assert(io.open(masterTbl.mlist))
      whole = f:read("*all")
      f:close()
      for moduleFn in whole:split("\n") do
         moduleFn = moduleFn:gsub(".lua$","")
         moduleD[moduleFn] = 0
      end
   elseif (masterTbl.mpath) then
      for path in masterTbl.mpath:split(":") do
         moduleDirA[#moduleDirA+1] = path
      end
      local moduleT = {}
      local spider  = Spider:new()

      spider:findAllModules(moduleDirA, moduleT)
      spider:dictModule(moduleT, moduleD)
   else
      print ("Must specify either --file or --modulepath")
      dbg.fini()
      return
   end


   local dateRange      = {}
   dateRange[1]         = 0
   dateRange[2]         = os.time()
   local inputDateRange = {math.huge, 0}

   if (masterTbl.dateRange) then
      dateRange[1] = convert_time_2_epoch(masterTbl.dateRange:gsub(":.*$",""))
      dateRange[2] = convert_time_2_epoch(masterTbl.dateRange:gsub("^.*:","") .."_23_59_59")
   end

   for _, fn in ipairs(pargs) do
      f     = assert(io.open(fn))
      whole = f:read("*all")
      f:close()

      for record in whole:split("\n") do
         local a = fromCSV(record)
         local user = a[1]
         if (user ~= "") then
            local date = convert_time_2_epoch(a[2])
            inputDateRange[1] = min(date, inputDateRange[1])
            inputDateRange[2] = max(date, inputDateRange[2])

            if (blacklistT[user] == nil and
                dateRange[1] <= date and date <= dateRange[2]) then
               for i = 3, #a do
                  local module = a[i]:gsub("^.*:","")
                  local v      = moduleD[module]
                  if (v) then
                     moduleD[module] = v + 1
                  end
               end
            end
         end
      end
   end

   inputDateRange[1] = os.date("%c",inputDateRange[1])
   inputDateRange[2] = os.date("%c",inputDateRange[2])

   io.stdout:write("\n# Module Usage: Dates: (",inputDateRange[1],":",inputDateRange[2],")\n\n")

   for k, v in pairsByValueKey(moduleD) do
      if (k ~= "") then
         io.stdout:write(v,",",k,"\n")
      end
   end

   dbg.fini()
end

function options()
   local masterTbl     = masterTbl()
   local usage         = "Usage: processModuleUsage [options] moduleUsage.csv ..."
   local cmdlineParser = Optiks:new{usage=usage, version="1.0"}

   cmdlineParser:add_option{
      name    = {"-d","--debug"},
      dest    = "debug",
      action  = "store_true",
      help    = "Turn on tracing",
      default = false,
   }

   cmdlineParser:add_option{
      name    = {"-m","--modulepath"},
      dest    = "mpath",
      action  = "store",
      help    = "Colon separated list of module directories",
      default = false,
   }

   cmdlineParser:add_option{
      name    = {"-f","--file"},
      dest    = "mlist",
      action  = "store",
      help    = "file containing list of modules",
      default = false,
   }

   cmdlineParser:add_option{
      name    = {"--date"},
      dest    = "dateRange",
      action  = "store",
      help    = "A date range: 2009_01_01:2009_03_31 or 2009_01_01:now",
      default = false,
   }



   local optionTbl, pargs = cmdlineParser:parse(arg)

   for v in pairs(optionTbl) do
      masterTbl[v] = optionTbl[v]
   end
   masterTbl.pargs = pargs

end
function fromCSV (s)
   s = s .. ','        -- ending comma
   local t = {}        -- table to collect fields
   local fieldstart = 1
   repeat
      -- next field is quoted? (start with `"'?)
      if s:find('^"', fieldstart) then
         local a, c
         local i  = fieldstart
         repeat
            -- find closing quote
            a, i, c = s:find('"("?)', i+1)
         until c ~= '"'    -- quote not followed by quote?
         if not i then error('unmatched "') end
         local f = s:sub(fieldstart+1, i-1)
         t[#t + 1] = f:gsub('""', '"')
         fieldstart = s:find(',', i) + 1
      else                -- unquoted; find next comma
         local nexti = s:find(',', fieldstart)
         t[#t + 1] =  s:sub(fieldstart, nexti-1)
         fieldstart = nexti + 1
      end
   until fieldstart > s:len(s)
   return t
end

main()
