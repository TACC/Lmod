#!@path_to_lua@/lua
-- -*- lua -*-
-----------------------------------------------------------------
-- getmt:  prints to screen what the value of the ModuleTable is.
--         optionly it writes the state of the ModuleTable is to a
--         dated file.
--
local cmd = arg[0]

local i,j = cmd:find(".*/")
local cmd_dir = "./"
if (i) then
   cmd_dir = cmd:sub(1,j)
end
package.path = cmd_dir .. "tools/?.lua;" ..
               cmd_dir .. "?.lua;"       .. package.path

local Optiks = require("Optiks")
local lfs    = require("lfs")
require("strict")
require("fileOps")
require("string_split")
require("string_trim")
require("serializeTbl")

function main()

   local optionTbl, pargs = options()

   local scDescriptT = false
   local found       = false

   if (optionTbl.descriptFn and optionTbl.descriptFn ~= "") then 
      local attr = lfs.attributes(optionTbl.descriptFn) or {}
      found      = (attr.mode == "file")
   end

   if (found) then
      scDescriptT = buildFromDescript(optionTbl.descriptFn)
   elseif (optionTbl.cacheDirs and optionTbl.cacheDirs ~= "" ) then
      scDescriptT = buildFromEnvVars(optionTbl.cacheDirs,
                                     optionTbl.updateFn)
   end

   if (scDescriptT and next(scDescriptT) ~= nil) then
      local s = serializeTbl{ indent = true, name = "scDescriptT",
                              value = scDescriptT }
      io.stdout:write(s)
   end

end

function buildFromEnvVars(cacheDirs, updateFn)
   local scDescriptT = {}

   if (not updateFn or updateFn == "") then
      updateFn = false
   end

   local i = 0
   for dir in cacheDirs:split(":") do
      i = i + 1
      scDescriptT[i] = { dir = dir, timestamp = updateFn}
   end
   return scDescriptT
end

function buildFromDescript(descriptFn)
   local f = io.open(descriptFn,"r")
   if (not f) then
      io.stderr:write("unable open file: ",descriptFn,"\n")
      return nil
   end

   local whole = f:read("*all")
   f:close()

   local scDescriptT = {}

   local i = 0
   for line in whole:split('\n') do
      if (not line:find("^%s*#") and
          not line:find("^%s*$")) then
         local a = {}
         for v in line:split(':') do
            a[#a+1] = v:trim()
         end
         i = i + 1
         scDescriptT[i] = { dir = a[1], timestamp = a[2] or false }
      end
   end
   return scDescriptT
end

function options()
   local usage         = "Usage: spiderCacheSupport [options] descriptFn"
   local cmdlineParser = Optiks:new{usage=usage, version="1.0"}

   cmdlineParser:add_option{ 
      name   = {'-v','--verbose'},
      dest   = 'verbosityLevel',
      action = 'count',
   }

   cmdlineParser:add_option{ 
      name   = {'--cacheDirs'},
      dest   = 'cacheDirs',
      action = 'store',
      help   = "Cache directories"
   }

   cmdlineParser:add_option{ 
      name   = {'--updateFn'},
      dest   = 'updateFn',
      action = 'store',
      help   = "last update file"
   }

   cmdlineParser:add_option{ 
      name   = {'--descriptFn'},
      dest   = 'descriptFn',
      action = 'store',
      help   = "Cache Description File"
   }

   local optionTbl, pargs = cmdlineParser:parse(arg)

   return optionTbl, pargs

end
main()
