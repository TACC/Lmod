local hook    = require("Hook")
local function visible_hook(modT)
   if (modT.fullName:find("EESSI/")) then
      modT.isVisible = false
   end
end
hook.register("isVisibleHook", visible_hook)
