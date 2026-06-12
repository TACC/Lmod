require("strict")

function deepcopy(t)
   if (type(t) ~= 'table') then
      return t
   end
   local mt = getmetatable(t)
   local r  = {}
   for k,v in pairs(t) do
      if (type(v) == 'table' and k ~= '__index') then
         v = deepcopy(v)
      end
      r[k] = v
   end
   setmetatable(r,mt)
   return r
end

