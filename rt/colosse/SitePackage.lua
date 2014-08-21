require("strict")
local hook = require("Hook")

local mapT = {
   ['/Compilers/'] = "Your compiler dependent modules"
   ['/Core.*']     = "Core Modules"
}


function avail_hook(t)
   for k,v in pairs(t) do
      for pat,label in pairs(mapT) do
         if (k:find(pat)) then
            t[k] = label
            break
         end
      end
   end
end


hook.register("avail",avail_hook)


