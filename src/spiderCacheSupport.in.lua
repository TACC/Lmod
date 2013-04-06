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
require("strict")
require("fileOps")
require("string_split")
require("string_trim")
require("serializeTbl")

function main()

   local optionTbl, pargs = options()

   local fn = pargs[1]
   if (not isFile(fn)) then
      return
   end

   local f = io.open(fn,"r")
   if (not f) then
      io.stderr:write("unable open file: ",fn,"\n")
      return
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

   io.stdout:write(serializeTbl{ indent = true, name = "scDescriptT", value = scDescriptT })

end

function options()
   local usage         = "Usage: spiderCacheSupport [options] descriptFn"
   local cmdlineParser = Optiks:new{usage=usage, version="1.0"}

   cmdlineParser:add_option{ 
      name   = {'-v','--verbose'},
      dest   = 'verbosityLevel',
      action = 'count',
   }

   local optionTbl, pargs = cmdlineParser:parse(arg)

   return optionTbl, pargs

end
main()
