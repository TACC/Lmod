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

--function deepcopy(orig)
--    local orig_type = type(orig)
--    local copy
--    if orig_type == 'table' then
--        copy = {}
--        for orig_key, orig_value in next, orig, nil do
--            copy[deepcopy(orig_key)] = deepcopy(orig_value)
--        end
--        setmetatable(copy, deepcopy(getmetatable(orig)))
--    else -- number, string, boolean, etc
--        copy = orig
--    end
--    return copy
--end
