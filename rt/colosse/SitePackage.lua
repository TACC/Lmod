require("strict")
local hook = require("Hook")
local dbg  = require("Dbg"):dbg()

local mapT = {
   ['/Compilers/'] = "Your compiler dependent modules",
   ['/Core.*']     = "Core Modules",
}


function avail_hook(t)
   local availStyle = masterTbl().availStyle
   if (not availStyle) then
      return
   end

   dbg.print{"avail hook called\n"}
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


