#!@path_to_lua@/lua
-- -*- lua -*-
local LuaCommandName = arg[0]
local i,j = LuaCommandName:find(".*/")
local LuaCommandName_dir = "./"
if (i) then
   LuaCommandName_dir = LuaCommandName:sub(1,j)
end

local sys_lua_path = "@sys_lua_path@"
if (sys_lua_path:sub(1,1) == "@") then
   sys_lua_path = package.path
end
local sys_lua_cpath = "@sys_lua_cpath@"
if (sys_lua_cpath:sub(1,1) == "@") then
   sys_lua_cpath = package.cpath
end

package.path  = LuaCommandName_dir .. "../tools/?.lua;"  ..
                LuaCommandName_dir .. "../shells/?.lua;" ..
                LuaCommandName_dir .. "?.lua;"           ..
                sys_lua_path
package.cpath = sys_lua_cpath

require("strict")
local epoch = false
_G._DEBUG   = false               -- Required by the new lua posix
local posix = require("posix")

---------------------------------------------------------------------
-- Build the Epoch function.  This function returns the *epoch*
-- depending on what version of posix.gettimeofday is installed.
function build_epoch()
   if (posix.gettimeofday) then
      local x1, x2 = posix.gettimeofday()
      if (x2 == nil) then
         epoch = function()
            local t = posix.gettimeofday()
            return t.sec + t.usec*1.0e-6
         end
      else
         epoch = function()
            local t1, t2 = posix.gettimeofday()
            return t1 + t2*1.0e-6
         end
      end
   else
      epoch = function()
         return os.time()
      end
   end
end

--------------------------------------------------------------------------
-- Build the epoch function and call it.
function main()
   build_epoch()
   print (epoch())
end

main()
