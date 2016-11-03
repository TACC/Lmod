require("strict")

local MName = require("MName")
local M     = inheritsFrom(MName)
M.my_name   = "exact"


local s_stepA = {
   MName.find_exact_match,
}

function M.steps()
   return s_stepA
end

return M
