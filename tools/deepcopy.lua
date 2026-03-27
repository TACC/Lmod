require("strict")

function deepcopy(t)
   if (type(t) ~= 'table') then
      return t
   end
   local mt = getmetatable(t)
   local r  = {}
   for k,myValue in pairs(t) do
      local v = myValue
      if (type(v) == 'table' and k ~= '__index') then
         v = deepcopy(v)
      end
      r[k] = v
   end
   setmetatable(r,mt)
   return r
end

