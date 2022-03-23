require("strict")

local hook      = require("Hook")

local otherBin  = os.getenv("OTHERBIN") or ""

local ignoreA = {
   otherBin
}
local keepA = { }

local function l_reverseMapPathFilter()
   return keepA, ignoreA
end

hook.register("reverseMapPathFilter",l_reverseMapPathFilter)
