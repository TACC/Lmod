-- -*- lua -*-
-- $Id: Bare.lua 194 2008-06-25 21:43:50Z mclay $

local BeautifulTbl = require ('BeautifulTbl')
local BaseShell    = BaseShell
local pairs        = pairs

Bare         = inheritsFrom(BaseShell)
Bare.my_name = 'bare'

function Bare.expand(self,tbl)
   local t = {}
   for k in pairs(tbl) do
      local v = tbl[k]
      t[#t + 1] = {k, '"'..v..'"'}
   end

   local bt = BeautifulTbl:new(t)
   io.stdout:write(bt:build_tbl(),"\n")
end

return Bare
