require("strict")
local hook   = require("Hook")
local getenv = os.getenv
local lfs    = require("lfs")
local posix  = require("posix")

local function parse_updateFn_hook(updateSystemFn, t)
   local attr = lfs.attributes(updateSystemFn)
   if (attr and type(attr) == "table") then
      local f           = io.open(updateSystemFn, "r")
      local hostType    = f:read("*line") or ""
      t.hostType        = hostType:trim()
      t.lastUpdateEpoch = attr.modification
   end
end

hook.register("parse_updateFn",parse_updateFn_hook)


