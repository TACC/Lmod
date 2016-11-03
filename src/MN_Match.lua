require("strict")

local MName = require("MName")
local M     = inheritsFrom(MName)
M.my_name   = "match"


local s_stepA = {
   MName.find_exact_match,
   MName.find_highest,
}

function M.steps()
   return s_stepA
end

return M
