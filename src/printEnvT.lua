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
_G._DEBUG      = false
local posix    = require("posix")
local readlink = posix.readlink
local stat     = posix.stat

local st       = stat(arg_0)
while (st.type == "link") do
   local lnk = readlink(arg_0)
   if (arg_0:find("/") and (lnk:find("^/") == nil)) then
      local dir = arg_0:gsub("/[^/]*$","")
      lnk       = dir .. "/" .. lnk
   end
   arg_0 = lnk
   st    = stat(arg_0)
end

local ia,ja = arg_0:find(".*/")
local cmd_dir = "./"
if (ia) then
   cmd_dir  = arg_0:sub(1,ja)
end

package.path  = cmd_dir .. "../tools/?.lua;"      ..
                cmd_dir .. "../tools/?/init.lua;" ..
                cmd_dir .. "?.lua;"               ..
                sys_lua_path
package.cpath = cmd_dir .. "../lib/?.so;"..
                sys_lua_cpath

require("strict")

function cmdDir()
   return cmd_dir
end

function programName()
   return arg_0
end

require("string_utils")
require("serializeTbl")
require("utils")

local getenv       = os.getenv
local getenv_posix = posix.getenv
local setenv_posix = posix.setenv

function main()
   local envT = getenv_posix()
   for k,v in pairs(envT) do
      if ((k:find("^BASH_FUNC_.*()$") or k:find("%%$")) and v:sub(1,2) == "()") then
         envT[k] = nil
      end
   end
   local name = arg[1] or "envT"
   local s    = serializeTbl{name=name, value = envT, indent = true, keep_double_underscore = true}
   io.stdout:write(s)
end

main()
