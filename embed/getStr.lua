#!/usr/bin/env lua
-- -*- lua -*-

require("strict")
local rtm = require("rtm")

function main()
   local s, t = rtm.rtm_string()
   print(s)
   print(t)
end


main()
