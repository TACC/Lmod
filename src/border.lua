require("strict")
require("TermWidth")
local rep=string.rep
borderG = nil
nspacesG = 0
function border(nspaces)
   if (not borderG or nspaces ~= nspacesG) then
      nspacesG = nspaces
      local term_width = TermWidth() - 4
      borderG = rep(" ",nspaces) .. rep("-", term_width) .. "\n"
   end
   return borderG
end
