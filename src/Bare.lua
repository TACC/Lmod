-- -*- lua -*-
require("strict")
local BaseShell	   = BaseShell
local pairsByKeys  = pairsByKeys
local table        = table
local io           = io

Bare	     = inheritsFrom(BaseShell)
Bare.my_name = 'bare'

function Bare.expand(self,tbl)
   local t = {}
   for k in pairsByKeys(tbl) do
      local v = tbl[k]:expand()
      t[#t + 1] = k .. ": " .. "'" .. v .. "'"
   end
   io.stderr:write(table.concat(t,"\n"),"\n")
end

return Bare
