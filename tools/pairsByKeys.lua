--------------------------------------------------------------------------
-- Return an iterator where the keys are sorted.
-- @module pairsByKeys

--------------------------------------------------------------------------
-- This function is described in the book: Programming in Lua by
-- Roberto Ierusalimschy.  It has been updated for Lua 5.1.
-- distributed under the Lua license: http://www.lua.org/license.html
--------------------------------------------------------------------------

require("strict")
local sort = table.sort

------------------------------------------------------------------------
-- Return an iterator where the keys are sorted.
-- @param t input table
-- @param[opt] f sort function
--function pairsByKeys (t, f)
--   local a = {}
--   local n = 0
--   for k in pairs(t) do
--      n    = n + 1
--      a[n] = k
--   end
--   sort(a, f)
--   local i = 0                -- iterator variable
--   local iter = function ()   -- iterator function
--                   i = i + 1
--                   if a[i] == nil then return nil
--                   else return a[i], t[a[i]]
--                   end
--                end
--   return iter
--end

function pairsByKeys (t, f)
   local strA = {}
   for k in pairs(t) do
      if (type(k) == "string") then
         strA[#strA+1] = k
      else
         strA[#strA+1] = tostring(k)
      end
   end
   sort(strA, f)

   local i = 0                -- iterator variable
   local iter = function ()   -- iterator function
                   i = i + 1
                   if strA[i] == nil then return nil
                   else return strA[i], t[strA[i]]
                   end
                end
   return iter
end

