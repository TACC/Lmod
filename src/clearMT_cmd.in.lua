#!@path_to_lua@/lua
-- -*- lua -*-
-----------------------------------------------------------------
-- getmt:  prints to screen what the value of the ModuleTable is.
--         optionly it writes the state of the ModuleTable is to a
--         dated file.
--
require("strict")
require("fileOps")

local cmd = abspath(arg[0])
local i,j = cmd:find(".*/")
local cmd_dir = "./"
if (i) then
   cmd_dir = cmd:sub(1,j)
end
package.path = cmd_dir .. '?.lua;' .. package.path

local concatTbl    = table.concat
local format       = string.format
local getenv       = os.getenv
local huge         = math.huge

function bash_export(name, value)
   local a = {}
   if (value == "") then
      a[#a+1] = "unset "
      a[#a+1] = name
      a[#a+1] = "\n"
   else
      a[#a+1] = name
      a[#a+1] = "=\""
      a[#a+1] = value
      a[#a+1] = "\"; export "
      a[#a+1] = name
      a[#a+1] = "\n"
   end
   io.stdout:write(concatTbl(a,""))
end

function csh_setenv(name, value)
   local a = {}
   if (value == "") then
      a[#a+1] = "unsetenv "
      a[#a+1] = name
      a[#a+1] = "\n"
   else
      a[#a+1] = "setenv "
      a[#a+1] = name
      a[#a+1] = " \""
      a[#a+1] = value
      a[#a+1] = "\"\n"
   end
   io.stdout:write(concatTbl(a,""))
end



function main()
   local unset = "unset"
   local setenv = bash_export
   if ( arg[1] == "csh" ) then
      unset = "unsetenv"
      setenv = csh_setenv
   end

   for i = 1, huge do
      local name = format("_ModuleTable%03d_",i)
      local v = getenv(name)
      if (v == nil) then break end
      io.stdout:write(unset, " ", name, "\n")
   end
   local mpath = getenv("LMOD_DEFAULT_MODULEPATH") or ""
   io.stdout:write(unset, " ", "_ModuleTable_Sz_\n")
   io.stdout:write(unset, " ", "LMOD_DEFAULT_MODULEPATH\n")
   setenv("MODULEPATH",mpath)

end

main()
