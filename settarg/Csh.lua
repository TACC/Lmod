-- -*- lua -*-

local base64    = require("base64")
local BaseShell = BaseShell
local io        = io
local pairs     = pairs
local format    = string.format
local getenv    = os.getenv
local decode64  = base64.decode64

Csh             = inheritsFrom(BaseShell)
Csh.my_name     = 'csh'

function Csh.expand(self,tbl)
   for k in pairs(tbl) do
      local v = tbl[k]
      if (v == '') then
         io.stdout:write("unsetenv ",k,";\n")
      else
         io.stdout:write("setenv ",k," '",v,"';\n")
      end
   end
end

return Csh
