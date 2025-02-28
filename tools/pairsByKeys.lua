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
   local a = {}
   local numA = {}
   local strA = {}
   local n = 0
   for k in pairs(t) do
      if (type(k) == "number") then
         numA[#numA+1] = k
      else
         strA[#strA+1] = k
      end
      n    = n + 1
   end
   sort(numA, f)
   sort(strA, f)

   for i = 1,#numA do
      a[i] = numA[i]
   end

   local j = #numA
   for i = 1,#strA do
      j = j + 1
      a[j] = strA[i]
   end

   local i = 0                -- iterator variable
   local iter = function ()   -- iterator function
                   i = i + 1
                   if a[i] == nil then return nil
                   else return a[i], t[a[i]]
                   end
                end
   return iter
end

