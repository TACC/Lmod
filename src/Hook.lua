require("strict")

local M={}

local validT =
{
   load = false,
}
   
function M.register(name, func)
   if (validT[name] ~= nil) then
      validT[name] = func
   end
end

function M.apply(name, ...)
   if (validT[name]) then
      validT[name](...)
   end
end
return M
